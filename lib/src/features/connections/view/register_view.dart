// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/core/components/markdown_text.dart';
import 'package:l_alternative/src/core/components/popup_modal.dart';
import 'package:l_alternative/src/core/service/error_service.dart';
import 'package:l_alternative/src/core/utils/app_utils.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';
import 'package:l_alternative/src/features/connections/service/connection_service.dart';
import 'package:monikode_event_store/monikode_event_store.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? _errorText;

  bool gcvu = false;

  ConnectionService connectionService = ConnectionService();

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider.notifier);
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            spacing: 24,
            children: [
              Text(
                "Créez un compte.",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Adresse e-mail",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    textController: emailController,
                    hintText: "john.doe@gmail.com",
                    obscureText: false,
                  ),
                ],
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Mot de passe",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    textController: passwordController,
                    hintText: "Mot de passe",
                    obscureText: true,
                  ),
                ],
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirmation mot de passe",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    textController: confirmPasswordController,
                    hintText: "Confirmation mot de passe",
                    obscureText: true,
                  ),
                ],
              ),
              if (_errorText != null)
                Text(_errorText!, style: TextStyle(color: Colors.red)),
              CustomButton(
                onPressed: () {
                  if (!connectionService.validateEmail(emailController.text)) {
                    _errorText = "Adresse e-mail invalide.";
                    setState(() {});
                    return;
                  }
                  if (!connectionService.validatePassword(
                    passwordController.text,
                  )) {
                    _errorText =
                        "Le mot de passe doit contenir au moins 6 caractères";
                    setState(() {});
                    return;
                  }
                  if (passwordController.text !=
                      confirmPasswordController.text) {
                    _errorText = "Les mots de passe ne correspondent pas.";
                    setState(() {});
                    return;
                  }
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (_) {
                      return StatefulBuilder(
                        builder: (BuildContext context, StateSetter setModalState) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.8,
                            child: Container(
                              padding: EdgeInsets.all(24),
                              width: double.infinity,
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  SingleChildScrollView(
                                    child: Column(
                                      spacing: 16,
                                      children: [
                                        Text(
                                          "CGVU et politique de confidentalité",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                          ),
                                        ),
                                        MarkdownText(
                                          paragraphs: [
                                            "# Politique de Confidentialité de L'Alternative",
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
                                        SizedBox(height: 1),
                                        Row(
                                          spacing: 2,
                                          children: [
                                            Checkbox(
                                              value: gcvu,
                                              onChanged: (value) {
                                                setModalState(() {
                                                  gcvu = value ?? false;
                                                });
                                              },
                                            ),
                                            Expanded(
                                              child: Text(
                                                "J’accepte la politique de confidentialité et les conditions générales de ventes et d’utilisation.",
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 60),
                                      ],
                                    ),
                                  ),
                                  CustomButton(
                                    text: "Continuer",
                                    onPressed: gcvu
                                        ? () async {
                                            try {
                                              EventStore.getInstance()
                                                  .localEventStore
                                                  .log(
                                                    "firebase.auth.connecting",
                                                    EventLevel.debug,
                                                    {
                                                      "email": emailController
                                                          .text
                                                          .trim(),
                                                    },
                                                  );
                                              var cred = await connectionService
                                                  .signUpViaFirebaseEmailPassword(
                                                    emailController.text,
                                                    passwordController.text,
                                                  );
                                              await user.setUserFromCredentials(
                                                cred,
                                              );

                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                                showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return PopupModal(
                                                      title:
                                                          "Vérifiez votre boîte mail",
                                                      content:
                                                          "Un email de vérification vous a été envoyé à l’adresse ${Utils.anonymousEmail(emailController.text)}",
                                                      ctaText: "Fermer",
                                                      onPressed: (newContext) {
                                                        Navigator.pop(
                                                          newContext,
                                                        );
                                                        Navigator.pushNamedAndRemoveUntil(
                                                          newContext,
                                                          '/home',
                                                          (route) => false,
                                                        );
                                                      },
                                                    );
                                                  },
                                                );
                                              }
                                            } catch (e, stackTrace) {
                                              if (context.mounted) {
                                                Navigator.of(context).pop();
                                              }

                                              // Use ErrorService to get user-friendly error message
                                              final errorMessage =
                                                  ErrorService.getErrorMessage(
                                                    e,
                                                  );
                                              ErrorService.logError(
                                                e,
                                                stackTrace,
                                              );

                                              _errorText = errorMessage;
                                              setState(() {});
                                              return;
                                            }
                                          }
                                        : null,
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
                text: "Créer le compte",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
