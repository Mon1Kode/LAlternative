// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/service/database_services.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

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

  Future<void> completeActivity() async {
    var id = state.id.replaceAll(RegExp(r'[.#$[\]/]'), '');
    state = state.copyWith(isCompleted: true, id: id);
    await DatabaseServices.update("/activites", {id: state.toMap()});
    await EventStore.getInstance().eventLogger.log(
      "admin.activities.update",
      EventLevel.info,
      {
        "parameters": {
          "activityId": id,
          "userId": FirebaseAuth.instance.currentUser?.uid,
        },
      },
    );
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

  void updateSubTitle(String subTitle) {
    state = state.copyWith(subTitle: subTitle);
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

  void updateContent(String party, String paragraphe, String newContent) {
    final updatedSteps = state.steps.map((step) {
      if (step.keys.first == party) {
        final updatedParagraphs = step[party]!.map((paragraph) {
          if (paragraph.keys.first == paragraphe) {
            return {paragraphe: newContent};
          }
          return paragraph;
        }).toList();
        return {party: updatedParagraphs};
      }
      return step;
    }).toList();
    state = state.copyWith(newSteps: updatedSteps);
  }

  void updateParagraphTitle(String party, String paragraph, String newTitle) {
    final updatedSteps = state.steps.map((step) {
      if (step.keys.first == party) {
        final updatedParagraphs = step[party]!.map((para) {
          if (para.keys.first == paragraph) {
            return {newTitle: para.values.first};
          }
          return para;
        }).toList();
        return {party: updatedParagraphs};
      }
      return step;
    }).toList();
    state = state.copyWith(newSteps: updatedSteps);
  }

  void set(ActivityModel model) {
    state = model;
  }

  void updateCompletion(bool bool) {
    state = state.copyWith(isCompleted: bool);
  }

  void addVideoResource(String title, String url) {
    final updatedVideos = List<Map>.from(state.videos)
      ..add({"title": title, "url": url});
    state = state.copyWith(videos: updatedVideos);
  }

  void addTestimonialResource(String title, String url) {
    final updatedTestimonials = List<Map>.from(state.testimonials)
      ..add({"title": title, "url": url});
    state = state.copyWith(testimonials: updatedTestimonials);
  }

  Future<void> deleteParagraphInACategory(String cate, String para) async {
    final updatedSteps = state.steps.map((step) {
      if (step.keys.first == cate) {
        final updatedParagraphs = step[cate]!
            .where((paragraph) => paragraph.keys.first != para)
            .toList();
        return {cate: updatedParagraphs};
      }
      return step;
    }).toList();
    await EventStore.getInstance().eventLogger.log(
      "admin.activities.paragraph.delete",
      EventLevel.info,
      {
        "params": {
          "activityId": state.id,
          "userId": FirebaseAuth.instance.currentUser?.uid,
        },
      },
    );
    state = state.copyWith(newSteps: updatedSteps);
  }

  void updateDate(DateTime date) {
    state = state.copyWith(date: date);
  }

  void updateIllustration(newValue) {
    state = state.copyWith(illustration: newValue);
  }
}
