// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';

class ActivityCard extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;
  final Widget actionView;
  final Color color;
  final bool isLast;
  final EdgeInsets padding;
  final bool hasImage;

  const ActivityCard({
    super.key,
    required this.title,
    required this.description,
    required this.imagePath,
    required this.actionView,
    required this.color,
    this.isLast = false,
    this.padding = const EdgeInsets.all(16),
    this.hasImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: RoundedContainer(
        width: MediaQuery.of(context).size.width - 32 - 8,
        hasBorder: false,
        color: color,
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
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    description,
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
                          MaterialPageRoute(builder: (context) => actionView),
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
              Image.asset(
                imagePath,
                width: MediaQuery.of(context).size.width * 0.3,
              ),
          ],
        ),
      ),
    );
  }
}
