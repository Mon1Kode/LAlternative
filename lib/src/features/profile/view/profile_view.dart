import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/markdown_text.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Informations personnelles",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(user.email, style: TextStyle(fontSize: 18)),
                        ImageButton(
                          imagePath: "edit.png",
                          size: 32,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                var newEmailController =
                                    TextEditingController();
                                return AlertDialog(
                                  title: Text(
                                    "Modifier l'adresse e-mail",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  content: CustomTextField(
                                    textController: newEmailController,
                                    hintText: "Nouvelle adresse e-mail",
                                    obscureText: false,
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
                                          ).colorScheme.secondary,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(userProvider.notifier)
                                            .changeEmail(
                                              newEmailController.text,
                                              context,
                                            );
                                        if (context.mounted) {
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Text(
                                        "Modifier",
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
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    CustomButton(
                      text: "Modifier le mot de passe",
                      onPressed: () {
                        Navigator.pushNamed(context, "/change-password");
                      },
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
                            fontSize: 18,
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
                        fontSize: 18,
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
                            Text("GCGU", style: TextStyle(fontSize: 18)),
                            ImageButton(
                              imagePath: "file-signature.png",
                              size: 32,
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) {
                                    return StatefulBuilder(
                                      builder:
                                          (
                                            BuildContext context,
                                            StateSetter setModalState,
                                          ) {
                                            return SizedBox(
                                              height:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.height *
                                                  0.8,
                                              child: Container(
                                                padding: EdgeInsets.all(24),
                                                width: double.infinity,
                                                child: Stack(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  children: [
                                                    SingleChildScrollView(
                                                      child: Column(
                                                        spacing: 16,
                                                        children: [
                                                          Text(
                                                            "CGVU et politique de confidentalité",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                              fontSize: 19,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color:
                                                                  Theme.of(
                                                                        context,
                                                                      )
                                                                      .colorScheme
                                                                      .tertiary,
                                                            ),
                                                          ),
                                                          MarkdownText(
                                                            textColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .secondary,
                                                            paragraphs: [
                                                              "**Dernière mise à jour :** 31 décembre 2025",
                                                              "## Introduction",
                                                              "L'Alternative s'engage à protéger votre vie privée. Cette Politique de Confidentialité explique comment nous collectons, utilisons, divulguons et protégeons vos informations lorsque vous utilisez notre application mobile.",
                                                              "## Informations que nous collectons",
                                                              "### Informations personnelles que vous fournissez",
                                                              "- **Données d'humeur :** Entrées et évaluations d'humeur quotidiennes\n- **Données de fatigue :** Entrées de niveau d'énergie\n- **Informations de compte :** Adresse e-mail (si vous choisissez de créer un compte)",
                                                              "### Informations collectées automatiquement",
                                                              "- **Informations sur l'appareil :** Type d'appareil, système d'exploitation, version de l'application\n- **Données d'utilisation :** Fonctionnalités utilisées, durée de session, interactions avec l'application\n- **Jetons de notification push :** Jetons FCM pour l'envoi de notifications\n- **Données analytiques :** Statistiques d'utilisation anonymes via Firebase Analytics",
                                                              "## Comment nous utilisons vos informations",
                                                              "Nous utilisons les informations collectées pour :",
                                                              "- Fournir et maintenir les fonctionnalités de l'application\n- Suivre votre historique d'humeur et générer des aperçus\n- Vous envoyer des notifications push (évaluations des activités, rappels)\n- Améliorer et personnaliser votre expérience\n- Analyser l'utilisation de l'application pour améliorer les fonctionnalités\n- Répondre à vos demandes et fournir un support client",
                                                              "## Stockage et sécurité des données",
                                                              "- Toutes les données sont stockées de manière sécurisée en utilisant les services Firebase (Google Cloud Platform)\n- Les données d'humeur sont stockées en local sur votre appareil\n- L'authentification des utilisateurs est gérée par Firebase Authentication\n- Nous mettons en œuvre des mesures de sécurité conformes aux normes de l'industrie pour protéger vos données\n- La transmission des données est cryptée via HTTPS/TLS",
                                                              "## Services tiers",
                                                              "Nous utilisons les services tiers suivants qui peuvent collecter des informations :",
                                                              "- **Firebase (Google) :** Authentification, base de données, analytiques, messagerie\n  - [Politique de confidentialité Firebase](https://firebase.google.com/support/privacy)\n- **Cloud Firestore :** Stockage de données\n- **Firebase Cloud Messaging :** Notifications push",
                                                              "## Vos droits et choix",
                                                              "Vous avez le droit de :",
                                                              "- **Accès :** Demander une copie de vos données\n- **Suppression :** Demander la suppression de votre compte et de toutes les données associées\n- **Modification :** Mettre à jour vos informations de profil à tout moment\n- **Désactivation :** Désactiver les notifications push dans les paramètres de l'application\n- **Export :** Demander l'exportation de vos données d'humeur",
                                                              "### Comment exercer vos droits",
                                                              "Pour exercer l'un de ces droits, contactez-nous à : victor.delamonica@icloud.com",
                                                              "### Suppression de compte",
                                                              "Vous pouvez supprimer votre compte et toutes les données associées via :\n1. Paramètres de l'application → Profil → Supprimer le compte\n2. Ou en nous contactant à : victor.delamonica@icloud.com",
                                                              "Après suppression, toutes vos données seront définitivement supprimées dans les 30 jours.",
                                                              "## Conservation des données",
                                                              "- **Comptes actifs :** Données conservées pendant que le compte est actif\n- **Comptes supprimés :** Données définitivement supprimées dans les 30 jours\n- **Données analytiques :** Les données anonymisées peuvent être conservées jusqu'à 14 mois",
                                                              "## Confidentialité des enfants",
                                                              "L'Alternative n'est pas destinée aux enfants de moins de 13 ans. Nous ne collectons pas sciemment d'informations auprès d'enfants de moins de 13 ans. Si vous pensez que nous avons collecté des informations auprès d'un enfant de moins de 13 ans, veuillez nous contacter immédiatement.",
                                                              "## Notifications push",
                                                              "Nous utilisons Firebase Cloud Messaging pour envoyer :\n- Évaluations des activités\n- Mises à jour de fonctionnalités",
                                                              "Vous pouvez désactiver les notifications à tout moment dans les paramètres de votre appareil ou de l'application.",
                                                              "## Modifications de cette Politique de Confidentialité",
                                                              "Nous pouvons mettre à jour cette Politique de Confidentialité de temps en temps. Nous vous informerons de tout changement en :\n- Publiant la nouvelle Politique de Confidentialité dans l'application\n- Mettant à jour la date « Dernière mise à jour »\n- (Pour les changements significatifs) Vous envoyant une notification push",
                                                              "## Nous contacter",
                                                              "Si vous avez des questions concernant cette Politique de Confidentialité ou nos pratiques, contactez-nous :",
                                                              "- **Email :** clarisse.hikoum@gmail.com ou victor.delamonica@icloud.com\n- **Site web :** inclusens.org",
                                                              "## Conformité légale",
                                                              "Cette application est conforme à :\n- Règlement Général sur la Protection des Données (RGPD) - UE\n- California Consumer Privacy Act (CCPA) - USA\n- Exigences de sécurité des données du Google Play Store\n- Exigences de confidentialité de l'Apple App Store",
                                                              "## Base juridique du traitement des données (RGPD)",
                                                              "Nous traitons vos données sur la base de :\n- **Consentement :** Pour les fonctionnalités optionnelles comme les notifications push\n- **Contrat :** Pour fournir le service de suivi d'humeur\n- **Intérêt légitime :** Pour améliorer l'application et prévenir les abus",
                                                            ],
                                                          ),

                                                          const SizedBox(
                                                            height: 60,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    CustomButton(
                                                      text: "Fermer",
                                                      onPressed: () {
                                                        Navigator.of(
                                                          context,
                                                        ).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                    );
                                  },
                                );
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
                        fontSize: 18,
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
                          "Supprimer mon compte",
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
              Center(child: Text("©1825 IncluSens. Tous droits réservés ")),

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
              //             fontSize: 18,
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
                          fontSize: 18,
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
