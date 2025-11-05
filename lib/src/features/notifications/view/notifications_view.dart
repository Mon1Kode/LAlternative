// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/features/notifications/provider/notifications_provider.dart';

class NotificationsView extends ConsumerStatefulWidget {
  const NotificationsView({super.key});

  @override
  ConsumerState<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends ConsumerState<NotificationsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Notifications",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (var notif
                in ref
                    .watch(notificationsProvider)
                    .notifications
                    .where((e) => e.date.isBefore(DateTime.now()))
                    .toList()
                    .reversed)
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text(notif.title),
                subtitle: Text(notif.body),
                trailing: Text(
                  "${notif.date.hour}:${notif.date.minute.toString().padLeft(2, '0')}",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
