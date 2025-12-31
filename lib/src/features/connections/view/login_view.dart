// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/core/components/popup_modal.dart';
import 'package:l_alternative/src/core/service/error_service.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';
import 'package:l_alternative/src/features/connections/service/connection_service.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  ConnectionService connectionService = ConnectionService();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider.notifier);
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.primary),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: SingleChildScrollView(
            child: Column(
              spacing: 24,
              children: [
                Text(
                  "Connectez-vous ou\ncréez un compte.",
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
                Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Adresse e-mail",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomTextField(
                      textController: emailController,
                      hintText: "john.doe@gmail.com",
                      textInputType: TextInputType.emailAddress,
                      onChanged: (value) {
                        emailController.text = value;
                        if (_errorMessage != null) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                      },
                    ),
                  ],
                ),
                Column(
                  spacing: 3,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Mot de passe",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    CustomTextField(
                      textController: passwordController,
                      hintText: "Mot de passe",
                      obscureText: true,
                      onChanged: (value) {
                        passwordController.text = value;
                        if (_errorMessage != null) {
                          setState(() {
                            _errorMessage = null;
                          });
                        }
                      },
                    ),
                    if (_errorMessage != null)
                      Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Mot de passe oublié ?",
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onPrimary.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return Container(
                              padding: EdgeInsets.all(24),
                              width: double.infinity,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                spacing: 24,
                                children: [
                                  Text(
                                    "Réinitialiser mot de passe",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.tertiary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                  Text(
                                    "Entrez l’adresse email associée à votre compte. Nous vous enverrons un email de réinitialisation sur celle-ci.",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withValues(alpha: 0.7),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Column(
                                    spacing: 3,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Adresse e-mail",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      CustomTextField(
                                        textController: emailController,
                                        hintText: "john.doe@gmail.com",
                                      ),
                                    ],
                                  ),
                                  CustomButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return PopupModal(
                                            title: "Email envoyé",
                                            content:
                                                "Vous avez reçu un email afin de réinitialiser votre mot de passe.",
                                            ctaText: "Fermer",
                                          );
                                        },
                                      );
                                    },
                                    text: "Réinitialiser",
                                  ),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        "Réinitialiser",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          decoration: TextDecoration.underline,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  onPressed: () async {
                    try {
                      var userData = await connectionService
                          .singInViaFirebaseEmailPassword(
                            emailController.text,
                            passwordController.text,
                          );
                      await user.setUserFromCredentials(userData);
                      await user.loadUserData();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/home',
                          (route) => false,
                        );
                      }
                    } catch (e, stackTrace) {
                      final errorMessage = ErrorService.getErrorMessage(e);
                      ErrorService.logError(e, stackTrace);

                      setState(() {
                        _errorMessage = errorMessage;
                      });
                    }
                  },
                  text: "Connexion",
                ),
                const SizedBox(height: 1),
                Divider(
                  color: Theme.of(
                    context,
                  ).colorScheme.onPrimary.withValues(alpha: 0.7),
                  indent: 150,
                  endIndent: 150,
                  thickness: 2,
                ),
                if (kDebugMode)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pas de compte ?",
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary.withValues(alpha: 0.7),
                          fontSize: 13,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          "Créé maintenant",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            decoration: TextDecoration.underline,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
