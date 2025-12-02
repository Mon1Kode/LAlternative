// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';

class ActivityModel {
  final String id;
  final Color color;
  final String title;
  final String subTitle;
  final String description;
  final DateTime creationDate;
  final DateTime updatedDate;
  final List<Map> videos;
  final List<Map> testimonials;
  final List<Map<String, List<Map<String, String>>>> steps;
  final bool isCompleted;

  ActivityModel({
    required this.id,
    required this.color,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.creationDate,
    required this.updatedDate,
    required this.videos,
    required this.testimonials,
    required this.steps,
    this.isCompleted = false,
  });

  ActivityModel copyWith({
    String? id,
    Color? color,
    String? title,
    String? subTitle,
    String? description,
    DateTime? creationDate,
    DateTime? updatedDate,
    List<Map>? videos,
    List<Map>? testimonials,
    List<Map<String, List<Map<String, String>>>>? newSteps,
    bool? isCompleted,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      color: color ?? this.color,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      description: description ?? this.description,
      creationDate: creationDate ?? this.creationDate,
      updatedDate: updatedDate ?? this.updatedDate,
      videos: videos ?? this.videos,
      testimonials: testimonials ?? this.testimonials,
      steps: newSteps ?? steps,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  static ActivityModel empty() {
    return ActivityModel(
      id: DateTime.now().toString(),
      color: Colors.deepOrange,
      title: "TITLE",
      subTitle: "SUBTITLE",
      description: "DESCRIPTION",
      creationDate: DateTime.now(),
      updatedDate: DateTime.now(),
      videos: [],
      testimonials: [],
      steps: [],
    );
  }

  toMap() {
    return {
      'id': id,
      'color': color.toARGB32(),
      'title': title,
      'subTitle': subTitle,
      'description': description,
      'creationDate': creationDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
      'videos': videos,
      'testimonials': testimonials,
      'steps': steps,
      'isCompleted': isCompleted,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as String,
      color: Color(map['color'] as int),
      title: map['title'] as String,
      subTitle: map['subTitle'] as String? ?? 'SUBTITLE',
      description: map['description'] as String,
      creationDate: DateTime.parse(map['creationDate'] as String),
      updatedDate: DateTime.parse(map['updatedDate'] as String),
      videos: List<Map>.from(map['videos'] as List? ?? []),
      testimonials: List<Map>.from(map['testimonials'] as List? ?? []),
      steps: List<Map<String, List<Map<String, String>>>>.from(
        (map['steps'] as List).map((step) {
          final stepMap = step as Map;
          return stepMap.map((key, value) {
            final valueList = value as List;
            return MapEntry(
              key.toString(),
              List<Map<String, String>>.from(
                valueList.map(
                  (item) => Map<String, String>.from(
                    (item as Map).map(
                      (k, v) => MapEntry(k.toString(), v.toString()),
                    ),
                  ),
                ),
              ),
            );
          });
        }),
      ),
      isCompleted: map['isCompleted'] as bool,
    );
  }

  void setCompleted(bool bool) {
    copyWith(isCompleted: bool);
  }
}
