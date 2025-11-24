// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/core/components/popup_modal.dart';
import 'package:l_alternative/src/core/service/error_service.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';
import 'package:l_alternative/src/features/connections/service/connection_service.dart';

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
                                        Text(
                                          "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Etiam facilisis ex ex, nec pretium ante mollis id. Nullam lorem magna, malesuada sit amet nisi ut, congue lobortis turpis. Nulla pellentesque libero vitae mollis facilisis. Nulla auctor diam posuere aliquam scelerisque. Curabitur id sodales diam. Aliquam ut bibendum mi. Proin id ipsum sed nisl commodo dapibus. Aliquam eleifend mollis ipsum, vel rhoncus mauris. In a neque a urna vulputate elementum non sed quam. Ut in faucibus ante.\n\nPellentesque non dolor consectetur, mollis nunc id, tincidunt orci. Suspendisse accumsan odio nec nunc mattis maximus. Donec id varius orci, ut eleifend metus. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Suspendisse potenti. In non sagittis nunc. In lectus ipsum, suscipit vitae iaculis a, sagittis eu mauris. Nam at finibus eros. Sed congue efficitur quam, ultricies rutrum diam accumsan quis. Maecenas finibus ex eu efficitur maximus. Vivamus in erat laoreet, malesuada mi ut, suscipit tortor. Ut euismod iaculis velit, et euismod dolor semper ac. Aliquam bibendum, nulla ac semper volutpat, arcu urna sagittis nulla, non vehicula ante neque eu velit. Duis a pharetra felis. Donec sed luctus metus. Duis feugiat risus eu tortor tempus, id fermentum felis dictum.",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withValues(alpha: 0.7),
                                            fontWeight: FontWeight.w500,
                                          ),
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
                                              var cred = await connectionService
                                                  .signUpViaFirebaseEmailPassword(
                                                    emailController.text,
                                                    passwordController.text,
                                                  );
                                              await user.setUserFromCredentials(
                                                cred,
                                              );

                                              // ignore: use_build_context_synchronously
                                              Navigator.of(context).pop();
                                              showDialog(
                                                // ignore: use_build_context_synchronously
                                                context: context,
                                                builder: (_) {
                                                  return PopupModal(
                                                    title:
                                                        "Vérifiez votre boîte mail",
                                                    content:
                                                        "Un email de vérification vous a été envoyé à l’adresse ${anonymousEmail(emailController.text)}",
                                                    ctaText: "Fermer",
                                                    onPressed: (newContext) {
                                                      Navigator.pop(newContext);
                                                      Navigator.pushNamedAndRemoveUntil(
                                                        newContext,
                                                        '/home',
                                                        (route) => false,
                                                      );
                                                    },
                                                  );
                                                },
                                              );
                                            } catch (e, stackTrace) {
                                              if (mounted) {
                                                // ignore: use_build_context_synchronously
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

  anonymousEmail(String text) {
    var parts = text.split("@");
    if (parts.length != 2) return text;
    var name = parts[0];
    var domain = parts[1];
    if (name.length <= 2) {
      name = "${name[0]}*";
    } else {
      name = name[0] + "*" * (name.length - 2) + name[name.length - 1];
    }
    return "$name@$domain";
  }
}
