// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/service/database_services.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';

var activitiesProvider =
    StateNotifierProvider<ActivitiesProvider, ActivitiesModel>((ref) {
      return ActivitiesProvider();
    });

class ActivitiesModel {
  final List<ActivityModel> activities;

  ActivitiesModel({required this.activities});

  ActivitiesModel copyWith({List<ActivityModel>? newActivities}) =>
      ActivitiesModel(activities: newActivities ?? activities);

  ActivityModel? getNextScheduledActivity() {
    final upcomingActivities = activities
        .where((activity) => activity.date.isAfter(DateTime.now()))
        .toList();
    upcomingActivities.sort((a, b) => a.date.compareTo(b.date));
    return upcomingActivities.isNotEmpty ? upcomingActivities.first : null;
  }
}

class ActivitiesProvider extends StateNotifier<ActivitiesModel> {
  ActivitiesProvider() : super(ActivitiesModel(activities: [])) {
    fetchActivities();
  }

  Future<void> fetchActivities() async {
    DataSnapshot data = await DatabaseServices.get("/activites");
    List<ActivityModel> loadedActivities = [];
    for (var child in data.children) {
      final activity = ActivityModel.fromMap(
        Map<String, dynamic>.from(child.value as Map),
      );
      loadedActivities.add(activity);
    }
    state = state.copyWith(newActivities: loadedActivities);
  }

  void addOrUpdateActivity(ActivityModel read) {
    final existingIndex = state.activities.indexWhere((a) => a.id == read.id);
    List<ActivityModel> updatedActivities = List.from(state.activities);
    if (existingIndex >= 0) {
      updatedActivities[existingIndex] = read;
    } else {
      updatedActivities.add(read);
    }
    DatabaseServices.update("/activites", {read.id: read.toMap()});
    state = state.copyWith(newActivities: updatedActivities);
  }

  Future<void> deleteActivity(String id) async {
    final updatedActivities = state.activities
        .where((activity) => activity.id != id)
        .toList();
    await DatabaseServices.remove("/activites/$id");
    state = state.copyWith(newActivities: updatedActivities);
  }
}
