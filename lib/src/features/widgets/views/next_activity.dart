// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:components_toolbox/components/markdown_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/core/utils/app_utils.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';
import 'package:l_alternative/src/features/admin/provider/activities_provider.dart';
import 'package:l_alternative/src/features/widgets/model/custom_widget.dart';

class NextActivity extends ConsumerStatefulWidget implements CustomWidget {
  const NextActivity({super.key});

  @override
  int get widthInGrid => 2;

  @override
  ConsumerState<NextActivity> createState() => _NextActivityState();
}

class _NextActivityState extends ConsumerState<NextActivity> {
  @override
  Widget build(BuildContext context) {
    var nextActivity = ref
        .watch(activitiesProvider)
        .activities
        .where((e) {
          // e.date the closest in the future
          return e.date.isAfter(DateTime.now());
        })
        .toList()
        .fold(null, (ActivityModel? previous, ActivityModel element) {
          if (previous == null) {
            return element;
          }
          return element.date.isBefore(previous.date) ? element : previous;
        });
    return nextActivity != null
        ? RoundedContainer(
            width: 300,
            height: 150,
            borderWidth: 1,
            padding: const EdgeInsets.all(8.0),
            color: nextActivity.color,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                spacing: 2,
                children: [
                  Text(
                    nextActivity.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Le ${Utils.formatDate(nextActivity.date)}",
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                  MarkdownText(
                    paragraphs: [
                      "soit dans ${Utils.timeRemaining(nextActivity.date)}",
                    ],
                    fontSize: 12,
                  ),
                ],
              ),
            ),
          )
        : RoundedContainer(
            width: 300,
            height: 150,
            borderWidth: 1,
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.tertiary,
              ),
            ),
          );
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return "NextActivity";
  }
}
