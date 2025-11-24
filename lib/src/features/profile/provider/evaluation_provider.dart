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

  EvaluationsNotifier(this.ref) : super(EvaluationsModel(evaluations: [])) {
    _getStoredDate();
  }

  Future<void> _getStoredDate() async {
    state = EvaluationsModel(evaluations: []);
  }

  Future<void> addEvaluation(EvaluationModel newEval) async {
    state = state.copyWith(newEvaluations: [...state.evaluations, newEval]);
  }

  Future<void> deleteEvaluations(EvaluationModel eval) async {
    state = state.copyWith(
      newEvaluations: state.evaluations
          .where((e) => e.date != eval.date)
          .toList(),
    );
    await EventStore.getInstance().eventLogger.log(
      "evaluation.delete",
      EventLevel.warning,
      {
        "parameters ": {"deleted_evaluation_date": eval.date.toIso8601String()},
      },
    );
  }

  Future<void> clearEvaluations() async {
    // Implementation to clear evaluations
    state = state.copyWith(newEvaluations: []);
    await EventStore.getInstance().eventLogger.log(
      "evaluation.clear",
      EventLevel.warning,
      {
        "parameters ": {"message": "All evaluations cleared"},
      },
    );
  }
}
