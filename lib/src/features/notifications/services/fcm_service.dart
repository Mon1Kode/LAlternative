// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:l_alternative/src/features/notifications/services/notifications_services.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

/// Handle background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await EventStore.getInstance().eventLogger.log(
    "fcm.background_message_received",
    EventLevel.info,
    {
      "parameters": {
        "messageId": message.messageId,
        "title": message.notification?.title,
        "body": message.notification?.body,
      },
    },
  );

  // Show notification using local notifications
  if (message.notification != null) {
    await NotificationService.showInstantNotification(
      message.notification!.title ?? "Notification",
      message.notification!.body ?? "",
    );
  }
}

class FCMService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  /// Initialize FCM
  static Future<void> initialize() async {
    // Request permission for iOS
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await EventStore.getInstance().eventLogger.log(
      "fcm.permission_result",
      EventLevel.info,
      {
        "parameters": {
          "authorizationStatus": settings.authorizationStatus.toString(),
        },
      },
    );

    // For iOS, check if APNS token is available before attempting to get FCM token
    // On iOS, the APNS token is obtained asynchronously and calling getToken()
    // before APNS is ready will cause an error
    if (Platform.isIOS) {
      await EventStore.getInstance().eventLogger.log(
        "fcm.ios_checking_apns",
        EventLevel.debug,
        {
          "parameters": {
            "message": "iOS detected - checking APNS token availability",
          },
        },
      );

      try {
        final apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          await EventStore.getInstance().eventLogger.log(
            "fcm.apns_token_available",
            EventLevel.debug,
            {
              "parameters": {
                "message":
                    "APNS token is available, proceeding to get FCM token",
              },
            },
          );
        } else {
          await EventStore.getInstance().eventLogger.log(
            "fcm.apns_token_null",
            EventLevel.debug,
            {
              "parameters": {
                "message": "APNS token is null, will wait for it via retries",
              },
            },
          );
          // Schedule retries to get the token once APNS is ready
          _scheduleTokenRetry();
          return; // Don't attempt to get FCM token yet
        }
      } catch (e) {
        // APNS token not ready yet
        await EventStore.getInstance().eventLogger.log(
          "fcm.apns_token_not_ready",
          EventLevel.debug,
          {
            "parameters": {
              "message":
                  "APNS token not ready yet, will wait for it via retries",
              "error": e.toString(),
            },
          },
        );
        // Schedule retries to get the token once APNS is ready
        _scheduleTokenRetry();
        return; // Don't attempt to get FCM token yet
      }
    }

    // Get FCM token (only reached if not iOS or if APNS token is ready)
    try {
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _saveFCMToken(token);
        await EventStore.getInstance().eventLogger.log(
          "fcm.token_obtained",
          EventLevel.info,
          {
            "parameters": {"token": token},
          },
        );
      } else {
        await EventStore.getInstance().eventLogger.log(
          "fcm.token_null",
          EventLevel.warning,
          {
            "parameters": {"message": "FCM token is null, will retry"},
          },
        );
        // Schedule retries to get the token
        _scheduleTokenRetry();
      }
    } catch (e) {
      // Unexpected error getting FCM token
      await EventStore.getInstance().eventLogger.log(
        "fcm.token_error",
        EventLevel.warning,
        {
          "parameters": {
            "error": e.toString(),
            "message": "Failed to get FCM token, will retry",
          },
        },
      );
      // Don't throw - allow app to continue, token will be obtained via retries or onTokenRefresh
      _scheduleTokenRetry();
    }

    // Listen for token refresh
    _firebaseMessaging.onTokenRefresh.listen((newToken) async {
      await _saveFCMToken(newToken);
      await EventStore.getInstance().eventLogger.log(
        "fcm.token_refreshed",
        EventLevel.debug,
        {
          "parameters": {"token": newToken},
        },
      );
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      await EventStore.getInstance().eventLogger.log(
        "fcm.foreground_message_received",
        EventLevel.info,
        {
          "parameters": {
            "messageId": message.messageId,
            "title": message.notification?.title,
            "body": message.notification?.body,
          },
        },
      );

      // Show notification when app is in foreground
      if (message.notification != null) {
        await NotificationService.showInstantNotification(
          message.notification!.title ?? "Notification",
          message.notification!.body ?? "",
        );
      }
    });

    // Handle notification taps when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await EventStore.getInstance().eventLogger.log(
        "fcm.notification_opened",
        EventLevel.info,
        {
          "parameters": {
            "messageId": message.messageId,
            "title": message.notification?.title,
          },
        },
      );
      // Handle navigation based on message data
    });

    // Check if app was opened from a terminated state
    RemoteMessage? initialMessage = await _firebaseMessaging
        .getInitialMessage();
    if (initialMessage != null) {
      await EventStore.getInstance().eventLogger.log(
        "fcm.app_opened_from_terminated",
        EventLevel.info,
        {
          "parameters": {
            "messageId": initialMessage.messageId,
            "title": initialMessage.notification?.title,
          },
        },
      );
      // Handle navigation based on message data
    }

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  /// Save FCM token to Firebase Realtime Database
  static Future<void> _saveFCMToken(String token) async {
    try {
      // Get user ID from Firebase Auth
      final userId = await _getCurrentUserId();
      if (userId != null) {
        final DatabaseReference ref = FirebaseDatabase.instance.ref(
          'users/$userId/fcmToken',
        );
        await ref.set({
          'token': token,
          'updatedAt': ServerValue.timestamp,
          'platform': _getPlatform(),
        });

        // Log successful save
        await EventStore.getInstance().eventLogger.log(
          "fcm.token_saved_to_database",
          EventLevel.info,
          {
            "parameters": {
              "userId": userId,
              "platform": _getPlatform(),
              "tokenLength": token.length,
            },
          },
        );
      } else {
        await EventStore.getInstance().eventLogger.log(
          "fcm.token_save_skipped",
          EventLevel.warning,
          {
            "parameters": {"reason": "User ID is null, user not authenticated"},
          },
        );
      }
    } catch (e) {
      await EventStore.getInstance().eventLogger.log(
        "fcm.token_save_error",
        EventLevel.error,
        {
          "parameters": {"error": e.toString()},
        },
      );
    }
  }

  /// Get current user ID from Firebase Auth
  static Future<String?> _getCurrentUserId() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await EventStore.getInstance().eventLogger.log(
          "fcm.user_id_obtained",
          EventLevel.debug,
          {
            "parameters": {"userId": user.uid},
          },
        );
        return user.uid;
      } else {
        await EventStore.getInstance().eventLogger.log(
          "fcm.user_not_authenticated",
          EventLevel.warning,
          {
            "parameters": {
              "message": "User not authenticated, cannot save FCM token",
            },
          },
        );
        return null;
      }
    } catch (e) {
      await EventStore.getInstance().eventLogger.log(
        "fcm.user_id_error",
        EventLevel.error,
        {
          "parameters": {"error": e.toString()},
        },
      );
      return null;
    }
  }

  /// Get platform name
  static String _getPlatform() {
    if (Platform.isIOS) {
      return "iOS";
    } else if (Platform.isAndroid) {
      return "android";
    }
    return "unknown";
  }

  /// Subscribe to a topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      await EventStore.getInstance().eventLogger.log(
        "fcm.topic_subscribed",
        EventLevel.info,
        {
          "parameters": {"topic": topic},
        },
      );
    } catch (e) {
      await EventStore.getInstance().eventLogger.log(
        "fcm.topic_subscription_error",
        EventLevel.error,
        {
          "parameters": {"topic": topic, "error": e.toString()},
        },
      );
    }
  }

  /// Unsubscribe from a topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      await EventStore.getInstance().eventLogger.log(
        "fcm.topic_unsubscribed",
        EventLevel.info,
        {
          "parameters": {"topic": topic},
        },
      );
    } catch (e) {
      await EventStore.getInstance().eventLogger.log(
        "fcm.topic_unsubscription_error",
        EventLevel.error,
        {
          "parameters": {"topic": topic, "error": e.toString()},
        },
      );
    }
  }

  /// Get FCM token
  static Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  /// Schedule a retry to get FCM token after APNS token becomes available
  static void _scheduleTokenRetry() {
    // Retry after 3 seconds, then 10 seconds, then 30 seconds
    Future.delayed(Duration(seconds: 3), () => _retryGetToken(1));
    Future.delayed(Duration(seconds: 10), () => _retryGetToken(2));
    Future.delayed(Duration(seconds: 30), () => _retryGetToken(3));
    Future.delayed(Duration(minutes: 1), () => _retryGetToken(4));
    Future.delayed(Duration(minutes: 5), () => _retryGetToken(5));
  }

  /// Retry getting FCM token
  static Future<void> _retryGetToken(int attemptNumber) async {
    try {
      await EventStore.getInstance().eventLogger.log(
        "fcm.token_retry_attempt",
        EventLevel.debug,
        {
          "parameters": {"attempt": attemptNumber},
        },
      );

      // On iOS, check if APNS token is available before attempting to get FCM token
      if (Platform.isIOS) {
        try {
          final apnsToken = await _firebaseMessaging.getAPNSToken();
          if (apnsToken == null) {
            await EventStore.getInstance().eventLogger.log(
              "fcm.apns_token_not_ready",
              EventLevel.debug,
              {
                "parameters": {
                  "attempt": attemptNumber,
                  "message": "APNS token not ready yet, skipping retry",
                },
              },
            );
            return; // Skip this retry, let later retries or onTokenRefresh handle it
          }
          await EventStore.getInstance().eventLogger.log(
            "fcm.apns_token_ready",
            EventLevel.debug,
            {
              "parameters": {
                "attempt": attemptNumber,
                "message": "APNS token is now available",
              },
            },
          );
        } catch (e) {
          // APNS token not ready yet
          await EventStore.getInstance().eventLogger.log(
            "fcm.apns_token_error_on_retry",
            EventLevel.debug,
            {
              "parameters": {
                "attempt": attemptNumber,
                "message": "APNS token not ready yet: ${e.toString()}",
              },
            },
          );
          return; // Skip this retry, let later retries or onTokenRefresh handle it
        }
      }

      // Now attempt to get FCM token
      String? token = await _firebaseMessaging.getToken();
      if (token != null) {
        await _saveFCMToken(token);
        await EventStore.getInstance().eventLogger.log(
          "fcm.token_obtained_on_retry",
          EventLevel.info,
          {
            "parameters": {"attempt": attemptNumber, "token": token},
          },
        );
      } else {
        await EventStore.getInstance().eventLogger.log(
          "fcm.token_retry_null",
          EventLevel.warning,
          {
            "parameters": {
              "attempt": attemptNumber,
              "message": "Token still null, will rely on onTokenRefresh",
            },
          },
        );
      }
    } catch (e) {
      await EventStore.getInstance().eventLogger.log(
        "fcm.token_retry_error",
        EventLevel.warning,
        {
          "parameters": {"attempt": attemptNumber, "error": e.toString()},
        },
      );
      // Don't throw - allow other retries to continue
    }
  }
}
