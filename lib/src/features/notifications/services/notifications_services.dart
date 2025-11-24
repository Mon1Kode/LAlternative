// // All rights reserved
// // Monikode Mobile Solutions
// // Created by MoniK on 2024.

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:l_alternative/src/features/notifications/model/notifications_model.dart';
import 'package:monikode_event_store/monikode_event_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> onDidReceiveNotification(
    NotificationResponse notificationResponse,
  ) async {
    await EventStore.getInstance().eventLogger.log(
      "notif.received",
      EventLevel.info,
      {
        "parameters ": {
          "payload": notificationResponse.payload,
          "actionId": notificationResponse.actionId,
          "input": notificationResponse.input,
        },
      },
    );
  }

  static Future<void> removeNotification(NotificationModel notif) async {
    var id = notif.id;
    await flutterLocalNotificationsPlugin.cancel(id);
    // EventStore.getInstance(collectionName: "Notifs_logs").eventLogger.log(
    //   "notif.canceled",
    //   EventLevel.debug,
    //   {"id": id, "title": notif.title},
    // );
  }

  static Future<void> init() async {
    tz_data.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("@mipmap/ic_launcher");
    const DarwinInitializationSettings iOSInitializationSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: androidInitializationSettings,
          iOS: iOSInitializationSettings,
        );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotification,
      onDidReceiveBackgroundNotificationResponse: onDidReceiveNotification,
    );

    final androidImpl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    final granted = await androidImpl?.requestNotificationsPermission();

    final iosImpl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    final iosGranted = await iosImpl?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    await EventStore.getInstance().eventLogger.log(
      "notif.permission_result",
      granted == true || iosGranted == true
          ? EventLevel.debug
          : EventLevel.warning,
      {
        "parameters ": {"granted": granted, "iosGranted": iosGranted},
      },
    );
  }

  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: AndroidNotificationDetails(
        'instant_notification_channel_id',
        'Instant Notifications',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'instant_notification',
    );
  }

  static Future<void> scheduleNotification(
    int id,
    String title,
    String body,
    DateTime scheduledTime,
  ) async {
    // Check if exact alarms are permitted on Android
    final androidImpl = flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    bool canScheduleExactAlarms = true;
    AndroidScheduleMode scheduleMode = AndroidScheduleMode.exact;

    if (androidImpl != null) {
      canScheduleExactAlarms =
          await androidImpl.canScheduleExactNotifications() ?? false;

      if (!canScheduleExactAlarms) {
        // Request permission to schedule exact alarms
        final granted = await androidImpl.requestExactAlarmsPermission();

        if (granted == true) {
          canScheduleExactAlarms = true;
          scheduleMode = AndroidScheduleMode.exact;
        } else {
          scheduleMode = AndroidScheduleMode.inexact;
        }
      }
    }

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      const NotificationDetails(
        iOS: DarwinNotificationDetails(),
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminder Channel',
          importance: Importance.high,
          priority: Priority.high,
          setAsGroupSummary: true,
          styleInformation: BigTextStyleInformation(''),
        ),
      ),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
      androidScheduleMode: scheduleMode,
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_scheduled_notif_id', id);
    // EventStore.getInstance(collectionName: "Notifs_logs").eventLogger.log(
    //   "notif.scheduled",
    //   EventLevel.debug,
    //   {"id": id, "title": title, "scheduleMode": scheduleMode.toString()},
    // );
  }

  static void setNotification(NotificationModel notif) async {
    var id = notif.id;
    await scheduleNotification(id, notif.title, notif.body, notif.date);
    await EventStore.getInstance().eventLogger.log(
      "notif.set",
      EventLevel.info,
      {
        "parameters ": {
          "id": id,
          "title": notif.title,
          "date": notif.date.toIso8601String(),
        },
      },
    );
  }

  static Future<void> persistNotifications(
    List<NotificationModel> notifications,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final notificationsModel = NotificationsModel(notifications: notifications);
    await prefs.setString(
      'stored_notifications',
      notificationsModel.toJson().toString(),
    );
  }
}
