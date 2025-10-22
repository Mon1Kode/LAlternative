// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/circle_image_button.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/features/evaluations/model/evaluation_row_model.dart';
import 'package:l_alternative/src/features/profile/model/evaluation_model.dart';
import 'package:l_alternative/src/features/profile/provider/evaluation_provider.dart';

class EvaluationsView extends ConsumerStatefulWidget {
  final EvaluationModel? evaluation;
  const EvaluationsView({super.key, this.evaluation});

  @override
  ConsumerState<EvaluationsView> createState() => _EvaluationsViewState();
}

class _EvaluationsViewState extends ConsumerState<EvaluationsView> {
  EvaluationModel _evalModel = EvaluationModel(date: DateTime.now(), rows: []);

  final List<String> _texts = [
    "Comment évalues-tu globalement l’atelier ?",
    "Cet atelier a-t-il répondu à tes attentes ?",
    "Te sens-tu écouté·e et compris·e pendant l’atelier ?",
    "Le contenu t’a-t-il semblé clair et accessible ?",
    "Le thème abordé t’a-t-il semblé pertinent par rapport à tes besoins ?",
    "Le rythme et la durée étaient-ils adaptés ?",
    "L’animateur·rice t’a-t-il semblé bienveillant·e et compétent·e ?",
  ];

  @override
  void initState() {
    if (widget.evaluation != null) {
      _evalModel = widget.evaluation!;
    } else {
      for (var text in _texts) {
        _evalModel.rows.add(EvaluationRowModel(title: text));
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Evaluations",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          if (widget.evaluation != null)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: ImageButton(
                imagePath: "trash.png",
                color: Colors.red,
                size: 32,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Supprimer l'évaluation"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Es-tu sûr·e de vouloir supprimer cette évaluation ?",
                          ),
                          Text(
                            "Cette action est irréversible.",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Annuler",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            ref
                                .read(evaluationsProvider.notifier)
                                .deleteEvaluations(widget.evaluation!);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Supprimer",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            spacing: 24,
            children: [
              RoundedContainer(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(
                      "Partie 1 – Impression générale",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    for (var i = 0; i < 4; i++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            _evalModel.rows[i].title,
                            style: TextStyle(fontSize: 16),
                          ),
                          EvaluationsRow(eval: _evalModel.rows[i]),
                        ],
                      ),
                  ],
                ),
              ),
              RoundedContainer(
                width: double.infinity,
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 16,
                  children: [
                    Text(
                      "Partie 2 – Contenu et animation",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    for (var i = 4; i < 7; i++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 8,
                        children: [
                          Text(
                            _evalModel.rows[i].title,
                            style: TextStyle(fontSize: 16),
                          ),
                          EvaluationsRow(eval: _evalModel.rows[i]),
                        ],
                      ),
                  ],
                ),
              ),
              if (widget.evaluation == null)
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.tertiary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    ref
                        .read(evaluationsProvider.notifier)
                        .addEvaluation(_evalModel);
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Terminer l'évaluation",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class EvaluationsRow extends StatefulWidget {
  final EvaluationRowModel eval;
  const EvaluationsRow({super.key, required this.eval});

  @override
  State<EvaluationsRow> createState() => _EvaluationsRowState();
}

class _EvaluationsRowState extends State<EvaluationsRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircleImageButton(
          imagePath: widget.eval.score >= 1 ? "star_filled.png" : "star.png",
          isSelected: widget.eval.score >= 1,
          onPressed: () {
            setState(() {
              widget.eval.score = 1;
            });
          },
        ),
        CircleImageButton(
          imagePath: widget.eval.score >= 2 ? "star_filled.png" : "star.png",
          isSelected: widget.eval.score >= 2,
          onPressed: () {
            setState(() {
              widget.eval.score = 2;
            });
          },
        ),
        CircleImageButton(
          imagePath: widget.eval.score >= 3 ? "star_filled.png" : "star.png",
          isSelected: widget.eval.score >= 3,
          onPressed: () {
            setState(() {
              widget.eval.score = 3;
            });
          },
        ),
        CircleImageButton(
          imagePath: widget.eval.score >= 4 ? "star_filled.png" : "star.png",
          isSelected: widget.eval.score >= 4,
          onPressed: () {
            setState(() {
              widget.eval.score = 4;
            });
          },
        ),
        CircleImageButton(
          imagePath: widget.eval.score == 5 ? "star_filled.png" : "star.png",
          isSelected: widget.eval.score == 5,
          onPressed: () {
            setState(() {
              widget.eval.score = 5;
            });
          },
        ),
      ],
    );
  }
}
