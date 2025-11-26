// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';

var newActivityProvider =
    StateNotifierProvider<NewActivityProvider, ActivityModel>(
      (ref) => NewActivityProvider(),
    );

class NewActivityProvider extends StateNotifier<ActivityModel> {
  NewActivityProvider() : super(ActivityModel.empty());

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController paragraphController = TextEditingController();

  void updateActivity(ActivityModel activity) {
    state = activity;
  }

  void updateCreationDate(DateTime creationDate) {
    state = state.copyWith(creationDate: creationDate);
  }

  void updateUpdatedDate(DateTime updatedDate) {
    state = state.copyWith(updatedDate: updatedDate);
  }

  void updateTitle(String title) {
    state = state.copyWith(title: title);
  }

  void updateDescription(String description) {
    state = state.copyWith(description: description);
  }

  void updateSteps(List<Map<String, List<Map<String, String>>>> steps) {
    state = state.copyWith(newSteps: steps);
  }

  void addStep(Map<String, List<Map<String, String>>> step) {
    final updatedSteps = List<Map<String, List<Map<String, String>>>>.from(
      state.steps,
    )..add(step);
    state = state.copyWith(newSteps: updatedSteps);
  }

  void addCategory(String categoryTitle) {
    final updatedSteps = List<Map<String, List<Map<String, String>>>>.from(
      state.steps,
    )..add({categoryTitle: []});
    state = state.copyWith(newSteps: updatedSteps);
  }

  void addParagraphInACategory(
    String categoryTitle,
    Map<String, String> paragraph,
  ) {
    final updatedSteps = state.steps.map((step) {
      if (step.keys.first == categoryTitle) {
        final updatedParagraphs = List<Map<String, String>>.from(
          step[categoryTitle]!,
        )..add(paragraph);
        return {categoryTitle: updatedParagraphs};
      }
      return step;
    }).toList();
    state = state.copyWith(newSteps: updatedSteps);
  }

  void resetActivity() {
    state = ActivityModel.empty();
    titleController.text = "";
    descriptionController.text = "";
    categoryController.text = "";
    paragraphController.text = "";
  }

  void updateColor(Color color) {
    state = state.copyWith(color: color);
  }

  void updateCategoryTitle(String first, String text) {
    final updatedSteps = state.steps.map((step) {
      if (step.keys.first == first) {
        final paragraphs = step[first]!;
        return {text: paragraphs};
      }
      return step;
    }).toList();
    state = state.copyWith(newSteps: updatedSteps);
  }

  void updateParagraphInACategory(String text, Map<String, String> map) {
    final updatedSteps = state.steps.map((step) {
      final categoryTitle = step.keys.first;
      final updatedParagraphs = step[categoryTitle]!.map((paragraph) {
        if (paragraph.keys.first == text) {
          return map;
        }
        return paragraph;
      }).toList();
      return {categoryTitle: updatedParagraphs};
    }).toList();
    state = state.copyWith(newSteps: updatedSteps);
  }
}
