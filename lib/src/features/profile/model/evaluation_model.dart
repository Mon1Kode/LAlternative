// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

class EvaluationsModel {
  final List<EvaluationModel> evaluations;

  EvaluationsModel({required this.evaluations});

  EvaluationsModel copyWith({List<EvaluationModel>? newEvaluations}) =>
      EvaluationsModel(evaluations: newEvaluations ?? evaluations);
}

class EvaluationModel {
  final DateTime date;

  EvaluationModel({required this.date});

  EvaluationModel copyWith({DateTime? newDate}) =>
      EvaluationModel(date: newDate ?? date);
}
