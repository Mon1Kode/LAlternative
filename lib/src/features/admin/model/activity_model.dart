// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';

class ActivityModel {
  final String id;
  final Color color;
  final String title;
  final String description;
  final DateTime creationDate;
  final DateTime updatedDate;
  final List<Map<String, List<Map<String, String>>>> steps;

  ActivityModel({
    required this.id,
    required this.color,
    required this.title,
    required this.description,
    required this.creationDate,
    required this.updatedDate,
    required this.steps,
  });

  ActivityModel copyWith({
    String? id,
    Color? color,
    String? title,
    String? description,
    DateTime? creationDate,
    DateTime? updatedDate,
    List<Map<String, List<Map<String, String>>>>? newSteps,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      color: color ?? this.color,
      title: title ?? this.title,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
      updatedDate: updatedDate ?? this.updatedDate,
      steps: newSteps ?? steps,
    );
  }

  static ActivityModel empty() {
    return ActivityModel(
      id: DateTime.now().toString(),
      color: Colors.deepOrange,
      title: "TITLE",
      description: "DESCRIPTION",
      creationDate: DateTime.now(),
      updatedDate: DateTime.now(),
      steps: [],
    );
  }
}
