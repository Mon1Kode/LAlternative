// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';
import 'package:l_alternative/src/features/relaxation/view/activity_template.dart';

class ActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final bool isLast;
  final EdgeInsets padding;
  final bool hasImage;
  final bool hasShadow;

  const ActivityCard({
    super.key,
    required this.activity,
    this.isLast = false,
    this.padding = const EdgeInsets.all(16),
    this.hasImage = true,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, -4),
                ),
              ]
            : [],
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 4,
          ),
          left: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 4,
          ),
          right: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 4,
          ),
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 0.5,
          ),
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: RoundedContainer(
        width: MediaQuery.of(context).size.width - 32 - 8,
        hasBorder: false,
        color: activity.color,
        padding: padding,
        borderRadius: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    activity.subTitle,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  if (isLast)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                ActivityTemplate(model: activity),
                          ),
                        );
                      },
                      child: Text(
                        "Voir l'activité",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                ],
              ),
            ),
            if (hasImage)
              Image.network(
                activity.illustration,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
          ],
        ),
      ),
    );
  }
}
