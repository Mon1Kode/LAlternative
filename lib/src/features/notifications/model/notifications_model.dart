// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

class NotificationsModel {
  final List<NotificationModel> notifications;

  NotificationsModel({required this.notifications});

  NotificationsModel copyWith({List<NotificationModel>? newNotifications}) =>
      NotificationsModel(notifications: newNotifications ?? notifications);

  void removeOneNotification(int index) {
    notifications.removeAt(index);
  }

  Map toJson() {
    return notifications.asMap().map(
      (key, value) => MapEntry(key.toString(), value.toJson()),
    );
  }

  NotificationsModel fromJson(Map<String, dynamic> json) {
    List<NotificationModel> loadedNotifications = [];
    json.forEach((key, value) {
      loadedNotifications.add(
        NotificationModel(
          title: value['title'],
          body: value['body'],
          date: DateTime.parse(value['date']),
          bodyBold: value['bodyBold'],
          actionDetails: value['actionDetails'],
          ctaText: value['ctaText'],
        ),
      );
    });
    return NotificationsModel(notifications: loadedNotifications);
  }
}

class NotificationModel {
  final int id = DateTime.now().millisecondsSinceEpoch % 2147483647;
  final String title;
  final String body;
  final DateTime date;
  final String bodyBold;
  final String actionDetails;
  final String ctaText;

  NotificationModel({
    required this.title,
    required this.body,
    required this.date,
    this.bodyBold = "",
    this.actionDetails = "",
    this.ctaText = "Continuer",
  });

  NotificationModel copyWith({
    String? newTitle,
    String? newBody,
    DateTime? newDate,
    String? newBodyBold,
    String? newActionDetails,
    String? newCtaText,
  }) => NotificationModel(
    title: newTitle ?? title,
    body: newBody ?? body,
    date: newDate ?? date,
    bodyBold: newBodyBold ?? bodyBold,
    actionDetails: newActionDetails ?? actionDetails,
    ctaText: newCtaText ?? ctaText,
  );

  Map toJson() {
    return {
      "id": id,
      "title": title,
      "body": body,
      "date": date.toIso8601String(),
      "bodyBold": bodyBold,
      "actionDetails": actionDetails,
      "ctaText": ctaText,
    };
  }

  NotificationModel fromJson() {
    return NotificationModel(
      title: title,
      body: body,
      date: date,
      bodyBold: bodyBold,
      actionDetails: actionDetails,
      ctaText: ctaText,
    );
  }
}
