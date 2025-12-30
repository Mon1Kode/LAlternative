// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:ui';

import 'package:l_alternative/src/features/widgets/model/custom_widget.dart';

class NextActivityModel extends CustomWidget {
  final String title;
  final String dateString;
  final Color color;

  @override
  final int widthInGrid = 2;

  NextActivityModel({
    required this.title,
    required this.dateString,
    required this.color,
  });
}
