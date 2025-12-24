import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/core/provider/app_providers.dart';
import 'package:l_alternative/src/core/utils/app_utils.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';
import 'package:l_alternative/src/features/notifications/model/notifications_model.dart';
import 'package:l_alternative/src/features/notifications/provider/notifications_provider.dart';
import 'package:l_alternative/src/features/notifications/services/cloud_functions_service.dart';
import 'package:l_alternative/src/features/profile/provider/evaluation_provider.dart';

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
    _nameController.text = ref.read(userProvider).displayName;
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
            imagePath: "settings.png",
            onPressed: () {
              Navigator.pushNamed(context, "/admin");
            },
            size: 32,
            borderRadius: 16,
          ),
          const SizedBox(width: 4),
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
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                                  .updateUserDetails(
                                    displayName: _nameController.text.trim(),
                                  );
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
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    "Photo de profil",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  // grid with the avatars file in the assets/images/avatars folder
                                  content: SingleChildScrollView(
                                    child: Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: [
                                        for (var i = 1; i <= 4; i++)
                                          GestureDetector(
                                            onTap: () async {
                                              await ref
                                                  .read(userProvider.notifier)
                                                  .updateUserDetails(
                                                    profilePicture: "$i.png",
                                                  );
                                              setState(() {});
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(4.0),
                                              child: Image.asset(
                                                "assets/images/avatars/$i.png",
                                                width: 64,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "Fermer",
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24.0),
                            child: Image.asset(
                              "assets/images/avatars/${user.profilePicture}",
                              width: 48,
                            ),
                          ),
                        ),
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
                            : Text(
                                user.displayName,
                                style: TextStyle(fontSize: 18),
                              ),
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
                          "Evaluations",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ImageButton(
                          imagePath: "plus-circle.png",
                          size: 32,
                          onPressed: () {
                            Navigator.pushNamed(context, "/evaluations");
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    Utils.formatDate(sortedEvaluations[i].date),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  ImageButton(
                                    imagePath: "eye.png",
                                    size: 32,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                    onPressed: () {
                                      Navigator.pushNamed(
                                        context,
                                        "/evaluations",
                                        arguments: sortedEvaluations[i],
                                      );
                                    },
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    Text(
                      "Support & Informations",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      spacing: 4,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Foire aux questions",
                              style: TextStyle(fontSize: 18),
                            ),
                            ImageButton(
                              imagePath: "badge-info.png",
                              size: 32,
                              onPressed: () {
                                Navigator.pushNamed(context, "/faq");
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Appel d'urgence",
                              style: TextStyle(fontSize: 18),
                            ),
                            ImageButton(
                              imagePath: "phone-call.png",
                              size: 28,
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: Icon(Icons.phone),
                                            title: Text("Appeler le samu - 15"),
                                            onTap: () {
                                              Utils.launchPhoneDialer("15");
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.phone),
                                            title: Text(
                                              "Appeler les pompier - 18",
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Utils.launchPhoneDialer("18");
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.phone),
                                            title: Text(
                                              "Appeler les urgences - 112",
                                            ),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Utils.launchPhoneDialer("112");
                                            },
                                          ),
                                          ListTile(
                                            leading: Icon(Icons.phone),
                                            title: Text("Appeler les Test "),
                                            onTap: () {
                                              Navigator.of(context).pop();
                                              Utils.launchPhoneDialer(
                                                "+33652562104",
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              RoundedContainer(
                padding: const EdgeInsets.all(16.0),
                width: double.infinity,
                child: Column(
                  spacing: 16,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Zone sensible",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Se déconnecter",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        ImageButton(
                          imagePath: "logout.png",
                          size: 32,
                          onPressed: () {
                            ref.read(userProvider.notifier).logout(context);
                          },
                        ),
                      ],
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
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
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
                                            .removeUser();
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
              Center(
                child: Text("Créer par IncluSens. Tous droits réservés © 2025"),
              ),

              // if (kDebugMode)
              //   RoundedContainer(
              //     padding: const EdgeInsets.all(16.0),
              //     width: double.infinity,
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text(
              //           "DEBUG ZONE",
              //           style: TextStyle(
              //             fontSize: 20,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text(
              //               "Add Notifs",
              //               style: TextStyle(
              //                 color: Colors.red,
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //             ImageButton(
              //               imagePath: "bell.png",
              //               color: Theme.of(context).colorScheme.secondary,
              //               size: 32,
              //               onPressed: () {
              //                 ref
              //                     .read(notificationsProvider.notifier)
              //                     .addNotification(
              //                       NotificationModel(
              //                         title: "Fin de l'activité",
              //                         body: 'Vous venez de finir l’activité',
              //                         date: DateTime.now().add(
              //                           Duration(seconds: 5),
              //                         ),
              //                         bodyBold: "Practiquer la relaxation",
              //                         actionDetails:
              //                             "Merci d’évaluer cette activité",
              //                         ctaText: "Évaluer",
              //                       ),
              //                     );
              //               },
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
              if (kDebugMode)
                RoundedContainer(
                  padding: const EdgeInsets.all(16.0),
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DEBUG ZONE",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Add Notifs",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          ImageButton(
                            imagePath: "bell.png",
                            color: Theme.of(context).colorScheme.secondary,
                            size: 32,
                            onPressed: () async {
                              var notifModel = NotificationModel(
                                title: "Test Notification 🔔",
                                body:
                                    "This notification was scheduled 10 seconds ago! Kill the app test successful.",
                                date: DateTime.now().add(Duration(seconds: 10)),
                              );
                              final success =
                                  await CloudFunctionsService.scheduleDelayedNotification(
                                    userId: user.id,
                                    title: notifModel.title,
                                    body: notifModel.body,
                                    delaySeconds: notifModel.date
                                        .difference(DateTime.now())
                                        .inSeconds,
                                    data: {
                                      'type': 'test',
                                      'timestamp': DateTime.now()
                                          .toIso8601String(),
                                    },
                                  );

                              if (success) {
                                // Add notification to provider
                                ref
                                    .read(notificationsProvider.notifier)
                                    .addNotification(notifModel);

                                // Show snackbar to confirm
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Notification scheduled in 10 seconds! Kill the app now to test.",
                                      ),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              } else {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Failed to schedule notification. Check Cloud Functions deployment.",
                                      ),
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
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
      ),
    );
  }
}
