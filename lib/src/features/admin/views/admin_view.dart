// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/block_picker.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/core/service/app_service.dart';
import 'package:l_alternative/src/features/admin/provider/activities_provider.dart';
import 'package:l_alternative/src/features/admin/provider/new_activity_provier.dart';

class AdminView extends ConsumerStatefulWidget {
  const AdminView({super.key});

  @override
  ConsumerState<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends ConsumerState<AdminView> {
  final StatService _statService = StatService();

  @override
  Widget build(BuildContext context) {
    var newActivity = ref.watch(newActivityProvider.notifier);
    var activities = ref.watch(activitiesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Admin Dashboard",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16,
          children: [
            RoundedContainer(
              padding: EdgeInsets.all(16),
              child: FutureBuilder<Map<String, int>>(
                future: _statService.getLoginStatsPerDay(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text("Aucune donnée valide"));
                  } else {
                    final stats = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 16,
                      children: [
                        Text(
                          "Statistiques de connexion par jour",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 180,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                ...stats.entries.map((entry) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          entry.key,
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            "${entry.value} connection${entry.value > 1 ? 's' : ''}",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(
                                                context,
                                              ).primaryColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
            Expanded(
              child: RoundedContainer(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(
                      "Activités créées",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: activities.activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities.activities[index];
                          return ListTile(
                            tileColor: Theme.of(
                              context,
                            ).colorScheme.secondary.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            leading: CircleAvatar(
                              backgroundColor: activity.color,
                            ),
                            trailing: ImageButton(
                              imagePath: "edit.png",
                              size: 24,
                            ),
                            title: Text(activity.title),
                            subtitle: Text(
                              "${activity.steps.length} partie${activity.steps.length > 1 ? 's' : ''}",
                            ),
                            onTap: () {
                              activity.setCompleted(false);
                              Navigator.pushNamed(
                                context,
                                "/admin/edit_activity",
                                arguments: activity,
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Ajouter une activité"),
                content: SingleChildScrollView(
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWithTitle(
                        title: "Nom",
                        hintText: "Nom de l'activité",
                        onChanged: (value) {
                          newActivity.updateTitle(value);
                        },
                      ),
                      SizedBox(
                        height: 100,
                        width: 200,
                        child: BlockPicker(
                          pickerColor: ref.read(newActivityProvider).color,
                          onColorChanged: (color) {
                            newActivity.updateColor(color);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  CustomButton(
                    text: "Ajouter des catégories",
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushNamed(
                        context,
                        "/admin/new_activity",
                        arguments: ref.read(newActivityProvider),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
