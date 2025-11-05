// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/features/notifications/model/notifications_model.dart';
import 'package:l_alternative/src/features/notifications/services/notifications_services.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsModel>(
      (ref) => NotificationsNotifier(),
    );

class NotificationsNotifier extends StateNotifier<NotificationsModel> {
  NotificationsNotifier() : super(NotificationsModel(notifications: []));

  Future<void> _persistNotifications(
    List<NotificationModel> notifications,
  ) async {
    await NotificationService.persistNotifications(notifications);
  }

  void addNotification(NotificationModel notification) {
    final updatedNotifications = List<NotificationModel>.from(
      state.notifications,
    )..add(notification);
    NotificationService.setNotification(notification);
    _persistNotifications(updatedNotifications);
    state = state.copyWith(newNotifications: updatedNotifications);
  }

  void removeNotification(int index) {
    NotificationService.removeNotification(state.notifications[index]);
    final updatedNotifications = List<NotificationModel>.from(
      state.notifications,
    )..removeAt(index);
    _persistNotifications(updatedNotifications);
    state = state.copyWith(newNotifications: updatedNotifications);
  }
}
