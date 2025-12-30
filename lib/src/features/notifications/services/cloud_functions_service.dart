// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:monikode_event_store/monikode_event_store.dart';

class CloudFunctionsService {
  // Firebase Cloud Functions URL (deployed successfully)
  static const String _baseUrl =
      'https://us-central1-l-alternative-bf37d.cloudfunctions.net';

  /// Send a notification to a specific user via Cloud Functions
  ///
  /// Parameters:
  /// - userId: The user ID to send the notification to
  /// - title: Notification title
  /// - body: Notification body/message
  /// - data: Optional additional data to include
  static Future<bool> sendNotificationToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sendNotification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'body': body,
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        await EventStore.getInstance().eventLogger.log(
          "cloud_function.notification_sent",
          EventLevel.info,
          {
            "parameters": {"userId": userId, "title": title},
          },
        );
        return true;
      } else {
        await EventStore.getInstance().eventLogger.log(
          "cloud_function.notification_failed",
          EventLevel.error,
          {
            "parameters": {
              "userId": userId,
              "statusCode": response.statusCode,
              "body": response.body,
            },
          },
        );
        return false;
      }
    } catch (e) {
      await EventStore.getInstance().eventLogger.log(
        "cloud_function.notification_error",
        EventLevel.error,
        {
          "parameters": {"userId": userId, "error": e.toString()},
        },
      );
      return false;
    }
  }

  /// Send a notification to a topic via Cloud Functions
  ///
  /// Parameters:
  /// - topic: The topic to send the notification to
  /// - title: Notification title
  /// - body: Notification body/message
  /// - data: Optional additional data to include
  static Future<bool> sendNotificationToTopic({
    required String topic,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/sendNotificationToTopic'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'topic': topic,
          'title': title,
          'body': body,
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        await EventStore.getInstance().eventLogger.log(
          "cloud_function.topic_notification_sent",
          EventLevel.info,
          {
            "parameters": {"topic": topic, "title": title},
          },
        );
        return true;
      } else {
        await EventStore.getInstance().eventLogger.log(
          "cloud_function.topic_notification_failed",
          EventLevel.error,
          {
            "parameters": {
              "topic": topic,
              "statusCode": response.statusCode,
              "body": response.body,
            },
          },
        );
        return false;
      }
    } catch (e) {
      await EventStore.getInstance().eventLogger.log(
        "cloud_function.topic_notification_error",
        EventLevel.error,
        {
          "parameters": {"topic": topic, "error": e.toString()},
        },
      );
      return false;
    }
  }

  /// Schedule a notification to be sent after a delay
  ///
  /// Parameters:
  /// - userId: The user ID to send the notification to
  /// - title: Notification title
  /// - body: Notification body/message
  /// - delaySeconds: Number of seconds to wait before sending
  /// - data: Optional additional data to include
  static Future<bool> scheduleDelayedNotification({
    required String userId,
    required String title,
    required String body,
    required int delaySeconds,
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/scheduleNotification'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'title': title,
          'body': body,
          'delaySeconds': delaySeconds,
          'data': data ?? {},
        }),
      );

      if (response.statusCode == 200) {
        await EventStore.getInstance().eventLogger.log(
          "cloud_function.scheduled_notification",
          EventLevel.info,
          {
            "parameters": {
              "userId": userId,
              "title": title,
              "delaySeconds": delaySeconds,
            },
          },
        );
        // Note: The notification will be delivered via FCM and handled
        // by the FCM message handlers in fcm_service.dart
        // Local notification state should be updated when FCM notification is received
        return true;
      } else {
        await EventStore.getInstance().eventLogger.log(
          "cloud_function.scheduled_notification_failed",
          EventLevel.error,
          {
            "parameters": {
              "userId": userId,
              "statusCode": response.statusCode,
              "body": response.body,
            },
          },
        );
        return false;
      }
    } catch (e) {
      await EventStore.getInstance().eventLogger.log(
        "cloud_function.scheduled_notification_error",
        EventLevel.error,
        {
          "parameters": {"userId": userId, "error": e.toString()},
        },
      );
      return false;
    }
  }
}
