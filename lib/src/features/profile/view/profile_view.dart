import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/core/provider/app_providers.dart';
import 'package:l_alternative/src/core/utils/app_utils.dart';
import 'package:l_alternative/src/features/profile/provider/evaluation_provider.dart';
import 'package:l_alternative/src/features/profile/provider/user_provider.dart';

class ProfileView extends ConsumerStatefulWidget {
  const ProfileView({super.key});

  @override
  ConsumerState<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool _isEditMode = false;

  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _nameController.text = ref.read(userProvider).name;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final user = ref.watch(userProvider);

    final sortedEvaluations = ref.watch(evaluationsProvider).evaluations
      ..sort((a, b) => (b.date).compareTo(a.date));

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        actions: [
          ImageButton(
            imagePath: themeMode == ThemeMode.dark
                ? "sunny.png"
                : "nightlight.png",
            onPressed: () async {
              final isDark = Theme.of(context).brightness == Brightness.dark;
              final newTheme = isDark ? ThemeMode.light : ThemeMode.dark;
              await ref.read(themeModeProvider.notifier).setTheme(newTheme);
            },
            size: 32,
            borderRadius: 16,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 24,
          children: [
            RoundedContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.1),
              child: Column(
                spacing: 16,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Informations personnelles",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ImageButton(
                        imagePath: _isEditMode ? "save.png" : "edit.png",
                        size: 32,
                        onPressed: () async {
                          if (_isEditMode) {
                            await ref
                                .read(userProvider.notifier)
                                .changeName(_nameController.text.trim());
                          }
                          setState(() {
                            _isEditMode = !_isEditMode;
                          });
                        },
                      ),
                    ],
                  ),
                  Row(
                    spacing: 16,
                    children: [
                      Image.asset("assets/images/avatar.png", width: 48),
                      _isEditMode
                          ? SizedBox(
                              width: 200,
                              child: TextField(
                                controller: _nameController,
                                autofocus: true,
                                style: TextStyle(fontSize: 18),
                                cursorColor: Theme.of(
                                  context,
                                ).colorScheme.tertiary,
                                decoration: InputDecoration(
                                  hintText: "Enter your name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      width: 1,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      width: 1,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: BorderSide(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                      width: 1,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Text(user.name, style: TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
            RoundedContainer(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 8,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Eveluations",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ImageButton(
                        imagePath: "plus-circle.png",
                        size: 32,
                        onPressed: () {
                          ref
                              .read(evaluationsProvider.notifier)
                              .addEvaluation();
                        },
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        if (sortedEvaluations.isEmpty)
                          Text("Aucune évaluation pour le moment."),
                        ...[
                          for (
                            int i = 0;
                            i < sortedEvaluations.length;
                            i++
                          ) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Utils.formatDate(sortedEvaluations[i].date),
                                  style: TextStyle(fontSize: 18),
                                ),
                                ImageButton(
                                  imagePath: "file-symlink.png",
                                  size: 32,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.secondary,
                                ),
                              ],
                            ),
                            if (i < sortedEvaluations.length - 1) Divider(),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            RoundedContainer(
              padding: const EdgeInsets.all(16.0),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Zone sensible",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Supprimer mes données",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      ImageButton(
                        imagePath: "trash.png",
                        color: Colors.red,
                        size: 32,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text(
                                  "Confirmer la suppression",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                content: Text(
                                  "Êtes-vous sûr de vouloir supprimer toutes vos données ? Cette action est irréversible.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Annuler",
                                      style: TextStyle(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.tertiary,
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      ref
                                          .read(userProvider.notifier)
                                          .deleteUserData();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text(
                                      "Supprimer",
                                      style: TextStyle(color: Colors.red),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
