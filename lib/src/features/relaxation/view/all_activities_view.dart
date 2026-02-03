// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/activity_card.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';

class AllActivitiesView extends StatelessWidget {
  final List<ActivityModel> activities;
  const AllActivitiesView({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Toutes les activités',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: activities.isEmpty
          ? Center(
              child: Text(
                'Aucune activité disponible pour le moment.',
                style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.6),
                ),
              ),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  spacing: 16,
                  children: activities
                      .asMap()
                      .entries
                      .map(
                        (entry) => ActivityCard(
                          activity: entry.value,
                          isLast: true,
                          hasShadow: false,
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
    );
  }
}
