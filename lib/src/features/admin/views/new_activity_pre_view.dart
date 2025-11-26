// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';
import 'package:l_alternative/src/features/admin/provider/new_activity_provier.dart';
import 'package:l_alternative/src/features/relaxation/view/activity_template.dart';

class NewActivityPreView extends ConsumerStatefulWidget {
  final ActivityModel activityModel;
  const NewActivityPreView({super.key, required this.activityModel});

  @override
  ConsumerState<NewActivityPreView> createState() => _NewActivityPreViewState();
}

class _NewActivityPreViewState extends ConsumerState<NewActivityPreView> {
  late ActivityModel currentActivity = widget.activityModel;

  @override
  Widget build(BuildContext context) {
    var newActivity = ref.watch(newActivityProvider.notifier);
    return Scaffold(
      body: ActivityTemplate(model: currentActivity),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 16,
                  children: [
                    CustomButton(
                      text: "Ajouter une category",
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Ajouter une nouvelle catégorie"),
                              content: SingleChildScrollView(
                                child: Column(
                                  spacing: 16,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextFieldWithTitle(
                                      textController:
                                          newActivity.categoryController,
                                      title: "Titre",
                                      hintText: "Titre de la catégorie",
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                CustomButton(
                                  text: "Ajouter des paragraphes",
                                  onPressed: () async {
                                    newActivity.addCategory(
                                      newActivity.categoryController.text,
                                    );
                                    await showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Ajouter un paragraphe"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              spacing: 16,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                TextFieldWithTitle(
                                                  title: "Titre",
                                                  hintText:
                                                      "Titre du paragraphe",
                                                  textController: newActivity
                                                      .titleController,
                                                ),
                                                TextFieldWithTitle(
                                                  title: "Contenu",
                                                  hintText:
                                                      "Contenu du paragraphe",
                                                  textController: newActivity
                                                      .paragraphController,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            CustomButton(
                                              text: "Ajouter",
                                              onPressed: () {
                                                newActivity
                                                    .addParagraphInACategory(
                                                      newActivity
                                                          .categoryController
                                                          .text,
                                                      {
                                                        newActivity
                                                            .titleController
                                                            .text: newActivity
                                                            .paragraphController
                                                            .text,
                                                      },
                                                    );
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    //ignore: use_build_context_synchronously
                                    if (mounted) Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        setState(() {
                          currentActivity = ref.read(newActivityProvider);
                        });
                      },
                    ),
                    CustomButton(
                      text: "Modifier une category",
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Selectioner une catégorie"),
                              content: SingleChildScrollView(
                                child: Column(
                                  spacing: 16,
                                  children: [
                                    for (var cate in currentActivity.steps) ...{
                                      ListTile(
                                        title: Text(cate.keys.first),
                                        onTap: () => showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              "Modifier la catégorie ${cate.keys.first}",
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                spacing: 16,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextFieldWithTitle(
                                                    textController: newActivity
                                                        .categoryController,
                                                    title: "Titre",
                                                    hintText:
                                                        "Titre de la catégorie",
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              CustomButton(
                                                text: "Ajouter des paragraphes",
                                                onPressed: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Ajouter un paragraphe",
                                                        ),
                                                        content: SingleChildScrollView(
                                                          child: Column(
                                                            spacing: 16,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              TextFieldWithTitle(
                                                                title: "Titre",
                                                                hintText:
                                                                    "Titre du paragraphe",
                                                                textController:
                                                                    newActivity
                                                                        .titleController,
                                                              ),
                                                              TextFieldWithTitle(
                                                                title:
                                                                    "Contenu",
                                                                hintText:
                                                                    "Contenu du paragraphe",
                                                                textController:
                                                                    newActivity
                                                                        .paragraphController,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          CustomButton(
                                                            text: "Ajouter",
                                                            onPressed: () {
                                                              newActivity.addParagraphInACategory(
                                                                cate.keys.first,
                                                                {
                                                                  newActivity
                                                                      .titleController
                                                                      .text: newActivity
                                                                      .paragraphController
                                                                      .text,
                                                                },
                                                              );
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              CustomButton(
                                                text: "Modifier un paragraphe",
                                                onPressed: () async {
                                                  await showDialog(
                                                    context: context,
                                                    builder: (context) {
                                                      return AlertDialog(
                                                        title: Text(
                                                          "Selectionez le paragraphe à modifier",
                                                        ),
                                                        content: SingleChildScrollView(
                                                          child: Column(
                                                            spacing: 16,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              for (var para
                                                                  in cate
                                                                      .values) ...{
                                                                for (var p
                                                                    in para) ...{
                                                                  ListTile(
                                                                    title: Text(
                                                                      p
                                                                          .keys
                                                                          .first,
                                                                    ),
                                                                    onTap: () async {
                                                                      await showDialog(
                                                                        context:
                                                                            context,
                                                                        builder:
                                                                            (
                                                                              context,
                                                                            ) {
                                                                              return AlertDialog(
                                                                                title: Text(
                                                                                  "Modifier le paragraphe \"${p.keys.first}\"",
                                                                                ),
                                                                                content: SingleChildScrollView(
                                                                                  child: Column(
                                                                                    spacing: 16,
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      TextFieldWithTitle(
                                                                                        title: "Titre",
                                                                                        hintText: "Titre du paragraphe",
                                                                                        textController: newActivity.titleController,
                                                                                      ),
                                                                                      TextFieldWithTitle(
                                                                                        title: "Contenu",
                                                                                        hintText: "Contenu du paragraphe",
                                                                                        textController: newActivity.paragraphController,
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                actions: [
                                                                                  CustomButton(
                                                                                    text: "Modifier",
                                                                                    onPressed: () {
                                                                                      newActivity.updateParagraphInACategory(
                                                                                        p.keys.first,
                                                                                        {
                                                                                          newActivity.titleController.text: newActivity.paragraphController.text,
                                                                                        },
                                                                                      );
                                                                                      Navigator.of(
                                                                                        context,
                                                                                      ).pop();
                                                                                    },
                                                                                  ),
                                                                                ],
                                                                              );
                                                                            },
                                                                      );
                                                                      if (mounted) {
                                                                        Navigator.of(
                                                                          //ignore: use_build_context_synchronously
                                                                          context,
                                                                        ).pop();
                                                                      }
                                                                    },
                                                                  ),
                                                                },
                                                              },
                                                            ],
                                                          ),
                                                        ),
                                                        actions: [
                                                          CustomButton(
                                                            text: "Ajouter",
                                                            onPressed: () {
                                                              newActivity.addParagraphInACategory(
                                                                newActivity
                                                                    .categoryController
                                                                    .text,
                                                                {
                                                                  newActivity
                                                                      .titleController
                                                                      .text: newActivity
                                                                      .paragraphController
                                                                      .text,
                                                                },
                                                              );
                                                              Navigator.of(
                                                                context,
                                                              ).pop();
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 16),
                                              CustomButton(
                                                text: "Sauvegarder",
                                                onPressed: () {
                                                  newActivity
                                                      .updateCategoryTitle(
                                                        cate.keys.first,
                                                        newActivity
                                                            .categoryController
                                                            .text,
                                                      );
                                                  setState(() {
                                                    currentActivity = ref.read(
                                                      newActivityProvider,
                                                    );
                                                  });
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    },
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
