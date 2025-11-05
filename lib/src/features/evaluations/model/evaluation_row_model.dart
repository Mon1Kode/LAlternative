// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/cupertino.dart';

class EvaluationRowModel {
  String title;
  int score;
  String comments;
  TextEditingController commentsController = TextEditingController();

  EvaluationRowModel({this.title = '', this.score = 0, this.comments = ''});

  EvaluationRowModel copyWith({int? newScore, String? newComments}) {
    return EvaluationRowModel(
      score: newScore ?? score,
      comments: newComments ?? comments,
    );
  }
}
