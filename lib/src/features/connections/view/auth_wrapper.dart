// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/service/database_services.dart';
import 'package:l_alternative/src/core/utils/app_utils.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';
import 'package:l_alternative/src/features/connections/service/connection_service.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionService = ConnectionService();
    final isLoggedIn = connectionService.isUserLoggedIn();
    var userNotifier = ref.watch(userProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await DatabaseServices.checkDatabaseStatus();
      } catch (e) {
        if (context.mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
        }
        return;
      }
      if (isLoggedIn) {
        await userNotifier.loadUserData();
        var user = userNotifier.getUser();
        if (user.lastLoginDate != null) {
          var hasTodayLoggedIn = false;
          if (Utils.isSameDay(DateTime.now(), user.lastLoginDate!)) {
            hasTodayLoggedIn = true;
          }
          if (!hasTodayLoggedIn) {
            await EventStore.getInstance().eventLogger.log(
              "user.daily_login",
              EventLevel.info,
              {
                "parameters": {"user_id": user.id},
              },
            );
            if (DateTime.now().difference(user.lastLoginDate!).inDays <= 1) {
              userNotifier.incrementStreak();
            } else if (DateTime.now().difference(user.lastLoginDate!).inDays >
                1) {
              userNotifier.resetStreak();
            }
          }
        }
        await DatabaseServices.update("/users/${user.id}/", {
          "last_login_date": DateTime.now().millisecondsSinceEpoch,
        });
        if (context.mounted) {
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false);
        }
      } else {
        if (context.mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
