// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';
import 'package:l_alternative/src/features/connections/service/connection_service.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectionService = ConnectionService();
    final isLoggedIn = connectionService.isUserLoggedIn();
    var user = ref.watch(userProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (isLoggedIn) {
        await user.loadUserData();
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    });

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
