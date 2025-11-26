// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/block_picker.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/features/admin/provider/new_activity_provier.dart';

class AdminView extends ConsumerStatefulWidget {
  const AdminView({super.key});

  @override
  ConsumerState<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends ConsumerState<AdminView> {
  @override
  Widget build(BuildContext context) {
    var newActivity = ref.watch(newActivityProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: false,
      ),
      body: Center(child: Text("Admin View")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Ajouter une activité"),
                content: SingleChildScrollView(
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFieldWithTitle(
                        title: "Nom",
                        hintText: "Nom de l'activité",
                        onChanged: (value) {
                          newActivity.updateTitle(value);
                        },
                      ),
                      SizedBox(
                        height: 100,
                        width: 200,
                        child: BlockPicker(
                          pickerColor: ref.read(newActivityProvider).color,
                          onColorChanged: (color) {
                            newActivity.updateColor(color);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  CustomButton(
                    text: "Ajouter des catégories",
                    onPressed: () async {
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
                                                hintText: "Titre du paragraphe",
                                                textController:
                                                    newActivity.titleController,
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
                      //ignore: use_build_context_synchronously
                      if (mounted) Navigator.of(context).pop();
                      Navigator.pushNamed(
                        //ignore: use_build_context_synchronously
                        context,
                        "/admin/new_activity",
                        arguments: ref.read(newActivityProvider),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
