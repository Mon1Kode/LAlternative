// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/resource_row.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/core/provider/app_providers.dart';
import 'package:l_alternative/src/features/admin/model/activity_model.dart';
import 'package:l_alternative/src/features/admin/provider/activities_provider.dart';
import 'package:l_alternative/src/features/admin/provider/new_activity_provier.dart';
import 'package:l_alternative/src/features/apa/view/apa_view.dart';

class ActivityTemplate extends ConsumerStatefulWidget {
  final ActivityModel model;

  const ActivityTemplate({super.key, required this.model});

  @override
  ConsumerState<ActivityTemplate> createState() => _ActivityTemplateState();
}

class _ActivityTemplateState extends ConsumerState<ActivityTemplate> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final newActivity = ref.watch(newActivityProvider);
    final newActivityNotifier = ref.read(newActivityProvider.notifier);
    final activitiesNotifier = ref.read(activitiesProvider.notifier);
    final themeMode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.model.color,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            ref.read(newActivityProvider.notifier).resetActivity();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.chevron_left),
        ),
        title: Text(
          widget.model.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (!widget.model.isCompleted)
            IconButton(
              onPressed: () async {
                await newActivityNotifier.completeActivity();
                newActivityNotifier.updateTitle(newActivity.title);
                newActivityNotifier.updateSubTitle(newActivity.subTitle);
                newActivityNotifier.updateDescription(newActivity.description);
                activitiesNotifier.addOrUpdateActivity(newActivity);
                if (mounted) {
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
              },
              icon: Icon(Icons.check),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 24,
            children: [
              RoundedContainer(
                padding: const EdgeInsets.all(8),
                borderColor: widget.model.color,
                child: Column(
                  spacing: 2,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    !newActivity.isCompleted
                        ? TextField(
                            controller: TextEditingController(
                              text: newActivity.title,
                            ),
                            showCursor: true,
                            cursorColor: Colors.black,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                            onSubmitted: (value) {
                              newActivityNotifier.updateTitle(value);
                            },
                          )
                        : Text(
                            widget.model.title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                    !newActivity.isCompleted
                        ? TextField(
                            controller: TextEditingController(
                              text: newActivity.subTitle,
                            ),
                            showCursor: true,
                            cursorColor: Colors.black,
                            style: TextStyle(fontSize: 14),
                            onSubmitted: (value) {
                              newActivityNotifier.updateSubTitle(value);
                            },
                          )
                        : Text(
                            widget.model.subTitle,
                            style: TextStyle(fontSize: 16),
                          ),
                    !newActivity.isCompleted
                        ? TextField(
                            controller: TextEditingController(
                              text: newActivity.description,
                            ),
                            showCursor: true,
                            cursorColor: Colors.black,
                            style: TextStyle(fontSize: 12),
                            onSubmitted: (value) {
                              newActivityNotifier.updateDescription(value);
                            },
                          )
                        : Text(
                            widget.model.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: themeMode == ThemeMode.dark
                                  ? Colors.grey
                                  : Color(0xFF6D6D6D),
                            ),
                            maxLines: 20,
                          ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ActivityDetailsTemplate(model: newActivity),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.tertiary,
                        ),
                        child: Text(
                          "En savoir plus",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              RoundedContainer(
                padding: const EdgeInsets.all(8),
                borderColor: widget.model.color,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Vidéo",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (!newActivity.isCompleted)
                          ImageButton(
                            imagePath: "plus-circle.png",
                            size: 32,
                            onPressed: () {
                              var titleController = TextEditingController();
                              var urlController = TextEditingController();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Ajouter une vidéo"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 8,
                                      children: [
                                        CustomTextField(
                                          textController: titleController,
                                          hintText: "Titre",
                                        ),
                                        CustomTextField(
                                          textController: urlController,
                                          hintText: "Url de la vidéo",
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          newActivityNotifier.addVideoResource(
                                            titleController.text,
                                            urlController.text,
                                          );
                                          setState(() {
                                            newActivity.copyWith(
                                              videos: ref
                                                  .read(newActivityProvider)
                                                  .videos,
                                            );
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Ajouter",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var video in newActivity.videos)
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SupportRoundedContainer(
                                imagePath: "assets/images/logo.png",
                                // replace with video thumbnail if available
                                text: video.values.first,
                                url: video.values.last,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RoundedContainer(
                padding: const EdgeInsets.all(8),
                borderColor: widget.model.color,
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Témoignages",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (!newActivity.isCompleted)
                          ImageButton(
                            imagePath: "plus-circle.png",
                            size: 32,
                            onPressed: () {
                              var titleController = TextEditingController();
                              var urlController = TextEditingController();
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Ajouter un témoignage"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      spacing: 8,
                                      children: [
                                        CustomTextField(
                                          textController: titleController,
                                          hintText: "Titre",
                                        ),
                                        CustomTextField(
                                          textController: urlController,
                                          hintText: "Url du témoignage",
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          newActivityNotifier
                                              .addTestimonialResource(
                                                titleController.text,
                                                urlController.text,
                                              );
                                          setState(() {
                                            newActivity.copyWith(
                                              testimonials: ref
                                                  .read(newActivityProvider)
                                                  .testimonials,
                                            );
                                          });
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Ajouter",
                                          style: TextStyle(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                      ],
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var testimonial in newActivity.testimonials)
                            Padding(
                              padding: const EdgeInsets.only(right: 16.0),
                              child: SupportRoundedContainer(
                                imagePath: "assets/images/logo.png",
                                // replace with testimonial thumbnail if available
                                text: testimonial.values.first,
                                url: testimonial.values.last,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityDetailsTemplate extends ConsumerStatefulWidget {
  final ActivityModel model;

  const ActivityDetailsTemplate({super.key, required this.model});

  @override
  ConsumerState<ActivityDetailsTemplate> createState() =>
      _ActivityDetailsTemplateState();
}

class _ActivityDetailsTemplateState
    extends ConsumerState<ActivityDetailsTemplate> {
  late ActivityModel currentActivity = widget.model;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final newActivityNotifier = ref.read(newActivityProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: currentActivity.color,
        foregroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            ref.read(newActivityProvider.notifier).resetActivity();
            Navigator.of(context).pop();
          },
          icon: Icon(Icons.chevron_left),
        ),
        title: Text(
          currentActivity.title,
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          if (!widget.model.isCompleted) ...{
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(Icons.check),
            ),
          },
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: widget.model.isCompleted
                ? [
                    for (var step in currentActivity.steps)
                      RoundedContainer(
                        borderColor: currentActivity.color,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 16,
                          children: [
                            Text(
                              step.keys.first,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            for (var texts in step.values) ...{
                              for (var text in texts)
                                ResourceRow(
                                  title: text.keys.first,
                                  content: text.values.first,
                                ),
                            },
                          ],
                        ),
                      ),
                  ]
                : [
                    for (var step in currentActivity.steps)
                      RoundedContainer(
                        borderColor: currentActivity.color,
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          spacing: 16,
                          children: [
                            TextField(
                              controller: TextEditingController(
                                text: step.keys.first,
                              ),
                              showCursor: true,
                              cursorColor: Colors.black,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                              onSubmitted: (value) {
                                newActivityNotifier.updateCategoryTitle(
                                  step.keys.first,
                                  value,
                                );
                              },
                            ),
                            for (var texts in step.values) ...{
                              for (var text in texts)
                                ResourceRow(
                                  title: text.keys.first,
                                  content: text.values.first,
                                  isEditable: true,
                                  onTitleSubmitted: (newTitle) {
                                    newActivityNotifier.updateParagraphTitle(
                                      step.keys.first,
                                      text.keys.first,
                                      newTitle,
                                    );
                                  },
                                  onContentSubmitted: (newContent) {
                                    newActivityNotifier.updateContent(
                                      step.keys.first,
                                      text.keys.first,
                                      newContent,
                                    );
                                  },
                                ),
                              if (!currentActivity.isCompleted) ...{
                                CustomButton.dotted(
                                  text: "Ajouter un paragraphe",
                                  onPressed: () async {
                                    newActivityNotifier.addParagraphInACategory(
                                      currentActivity.steps
                                          .where(
                                            (element) =>
                                                element.keys.first ==
                                                step.keys.first,
                                          )
                                          .first
                                          .keys
                                          .first,
                                      {
                                        "Titre du paragraphe":
                                            "Contenu du paragraphe",
                                      },
                                    );
                                  },
                                  predicate: true,
                                ),
                              },
                            },
                          ],
                        ),
                      ),
                    if (!currentActivity.isCompleted) ...{
                      CustomButton.dotted(
                        text: "Ajouter une partie",
                        onPressed: () async {
                          newActivityNotifier.addCategory(
                            "PARTIE ${currentActivity.steps.length + 1}",
                          );
                        },
                        predicate: true,
                      ),
                    },
                  ],
          ),
        ),
      ),
    );
  }
}
