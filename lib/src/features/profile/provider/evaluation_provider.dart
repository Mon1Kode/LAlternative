// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/features/profile/model/evaluation_model.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

final evaluationsProvider =
    StateNotifierProvider<EvaluationsNotifier, EvaluationsModel>((ref) {
      return EvaluationsNotifier(ref);
    });

class EvaluationsNotifier extends StateNotifier<EvaluationsModel> {
  final Ref ref;
  final String evaluationsKey = 'evaluations_key';
  final List<EvaluationModel> defaultEvaluations = [
    EvaluationModel(date: DateTime(2025, 07, 09)),
    EvaluationModel(date: DateTime(2025, 08, 04)),
  ];

  EvaluationsNotifier(this.ref)
    : super(
        EvaluationsModel(
          evaluations: [
            EvaluationModel(date: DateTime(2025, 07, 09)),
            EvaluationModel(date: DateTime(2025, 08, 04)),
          ],
        ),
      ) {
    _getStoredDate();
  }

  Future<void> _getStoredDate() async {
    // Implementation to get stored date
  }

  Future<void> addEvaluation() async {
    // Implementation to add evaluation
    state = state.copyWith(newEvaluations: defaultEvaluations);
  }

  Future<void> deleteEvaluations(int index) async {
    // Implementation to delete evaluations
  }

  Future<void> clearEvaluations() async {
    // Implementation to clear evaluations
    state = state.copyWith(newEvaluations: []);
    EventStore.getInstance().localEventStore.log(
      "evaluation_clear",
      EventLevel.warning,
      {"message": "All evaluations cleared"},
    );
  }
}
