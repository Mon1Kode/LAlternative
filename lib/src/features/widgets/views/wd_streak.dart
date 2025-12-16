// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';

class WdStreak extends ConsumerStatefulWidget {
  const WdStreak({super.key});

  @override
  ConsumerState<WdStreak> createState() => _WdStreakState();
}

class _WdStreakState extends ConsumerState<WdStreak> {
  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    return Stack(
      children: [
        RoundedContainer(
          color: Colors.transparent,
          width: 150,
          height: 150,
          borderWidth: 1,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: Image.asset(
              "assets/images/plants/${user.streakIcon.toString().split(".").last}/${user.streakCount > 14 ? "14" : user.streakCount}.png",
              width: double.infinity,
              height: 150,
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        RoundedContainer(
          width: 150,
          height: 150,
          borderWidth: 1,
          child: Column(
            children: [
              Text(
                "${user.streakCount} jour${user.streakCount > 1 ? "s" : ""}",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "WdStreak";
  }
}
