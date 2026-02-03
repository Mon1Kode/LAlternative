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
  final DateTime date;
  final DateTime creationDate;
  final DateTime updatedDate;
  final List<Map> videos;
  final List<Map> testimonials;
  final List<Map<String, List<Map<String, String>>>> steps;
  final bool isCompleted;
  final String illustration;

  ActivityModel({
    required this.id,
    required this.color,
    required this.title,
    required this.subTitle,
    required this.description,
    required this.date,
    required this.creationDate,
    required this.updatedDate,
    required this.videos,
    required this.testimonials,
    required this.steps,
    this.isCompleted = false,
    this.illustration =
        "https://firebasestorage.googleapis.com/v0/b/l-alternative-bf37d.firebasestorage.app/o/illustrations%2Fone.png?alt=media&token=d1e05486-1832-44d3-9a35-3c0d4ca307a8",
  });

  ActivityModel copyWith({
    String? id,
    Color? color,
    String? title,
    String? subTitle,
    String? description,
    DateTime? date,
    DateTime? creationDate,
    DateTime? updatedDate,
    List<Map>? videos,
    List<Map>? testimonials,
    List<Map<String, List<Map<String, String>>>>? newSteps,
    bool? isCompleted,
    String? illustration,
  }) {
    return ActivityModel(
      id: id ?? this.id,
      color: color ?? this.color,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      description: description ?? this.description,
      date: date ?? this.date,
      creationDate: creationDate ?? this.creationDate,
      updatedDate: updatedDate ?? this.updatedDate,
      videos: videos ?? this.videos,
      testimonials: testimonials ?? this.testimonials,
      steps: newSteps ?? steps,
      isCompleted: isCompleted ?? this.isCompleted,
      illustration: illustration ?? this.illustration,
    );
  }

  static ActivityModel empty() {
    return ActivityModel(
      id: DateTime.now().toString(),
      color: Colors.deepOrange,
      title: "TITLE",
      subTitle: "SUBTITLE",
      description: "DESCRIPTION",
      date: DateTime.now(),
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
      'date': date.toIso8601String(),
      'creationDate': creationDate.toIso8601String(),
      'updatedDate': updatedDate.toIso8601String(),
      'videos': videos,
      'testimonials': testimonials,
      'steps': steps,
      'isCompleted': isCompleted,
      'illustration': illustration,
    };
  }

  static fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      id: map['id'] as String,
      color: Color(map['color'] as int),
      title: map['title'] as String,
      subTitle: map['subTitle'] as String? ?? 'SUBTITLE',
      description: map['description'] as String,
      date: DateTime.parse(map['date'] as String),
      creationDate: DateTime.parse(map['creationDate'] as String),
      updatedDate: DateTime.parse(map['updatedDate'] as String),
      videos: List<Map>.from(map['videos'] as List? ?? []),
      testimonials: List<Map>.from(map['testimonials'] as List? ?? []),
      steps: List<Map<String, List<Map<String, String>>>>.from(
        (map['steps'] as List?)?.map((step) {
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
            }) ??
            [],
      ),
      isCompleted: map['isCompleted'] as bool,
      illustration:
          map['illustration'] as String? ??
          "https://firebasestorage.googleapis.com/v0/b/l-alternative-bf37d.firebasestorage.app/o/illustrations%2Fone.png?alt=media&token=d1e05486-1832-44d3-9a35-3c0d4ca307a8",
    );
  }

  void setCompleted(bool bool) {
    copyWith(isCompleted: bool);
  }
}
