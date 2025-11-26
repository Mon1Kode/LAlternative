// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/resource_row.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';
import 'package:l_alternative/src/features/admin/provider/new_activity_provier.dart';

class ActivityTemplate extends ConsumerStatefulWidget {
  final ActivityModel model;
  const ActivityTemplate({super.key, required this.model});

  @override
  ConsumerState<ActivityTemplate> createState() => _ActivityTemplateState();
}

class _ActivityTemplateState extends ConsumerState<ActivityTemplate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.model.color,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            ref.watch(newActivityProvider.notifier).resetActivity();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.chevron_left),
        ),
        title: Text(
          widget.model.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              for (var step in widget.model.steps)
                RoundedContainer(
                  borderColor: widget.model.color,
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    spacing: 16,
                    children: [
                      Text(
                        step.keys.first,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      for (var texts in step.values)
                        for (var text in texts)
                          ResourceRow(
                            title: text.keys.first,
                            content: text.values.first,
                          ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
