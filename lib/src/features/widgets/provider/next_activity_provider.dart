// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/features/widgets/model/next_activity_model.dart';

final nextActivityProvider =
    StateNotifierProvider<NextActivityProvider, NextActivityModel>(
      (ref) => NextActivityProvider(),
    );

class NextActivityProvider extends StateNotifier<NextActivityModel> {
  NextActivityProvider()
    : super(
        NextActivityModel(
          title: 'No Upcoming Activity',
          dateString: '',
          color: const Color(0xFFE0E0E0),
        ),
      );

  void updateNextActivity(NextActivityModel nextActivity) {
    state = nextActivity;
  }
}
