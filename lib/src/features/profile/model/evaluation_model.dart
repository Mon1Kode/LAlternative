// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:l_alternative/src/features/evaluations/model/evaluation_row_model.dart';

class EvaluationsModel {
  final List<EvaluationModel> evaluations;

  EvaluationsModel({required this.evaluations});

  EvaluationsModel copyWith({List<EvaluationModel>? newEvaluations}) =>
      EvaluationsModel(evaluations: newEvaluations ?? evaluations);
}

class EvaluationModel {
  final DateTime date;
  final List<EvaluationRowModel> rows;

  EvaluationModel({required this.date, required this.rows});

  EvaluationModel copyWith({
    DateTime? newDate,
    List<EvaluationRowModel>? newRows,
  }) => EvaluationModel(date: newDate ?? date, rows: newRows ?? rows);
}
