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

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangeEmailState();
}

class _ChangeEmailState extends ConsumerState<ChangePassword> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController newPasswordConfirmController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        title: Text(
          "Modifier le mot de passe",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
          child: Column(
            spacing: 24,
            children: [
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Anciens mot de passe*",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    textController: currentPasswordController,
                    hintText: "Entrez votre ancien mot de passe",
                    obscureText: true,
                  ),
                ],
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nouveau mot de passe*",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    textController: newPasswordController,
                    hintText: "Entrez votre nouveau mot de passe",
                    obscureText: true,
                  ),
                ],
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Confirmer le nouveau mot de passe*",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    textController: newPasswordConfirmController,
                    hintText: "Confirmez votre nouveau mot de passe",
                    obscureText: true,
                  ),
                ],
              ),
              CustomButton(
                onPressed: () async {
                  if (currentPasswordController.text.isEmpty ||
                      newPasswordController.text.isEmpty ||
                      newPasswordConfirmController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Veuillez remplir tous les champs obligatoires.",
                        ),
                      ),
                    );
                    return;
                  }
                  if (newPasswordController.text !=
                      newPasswordConfirmController.text) {
                    ErrorService.showErrorSnackBar(
                      context,
                      "Les nouveaux mots de passe ne correspondent pas.",
                    );
                    return;
                  }
                  try {
                    await user.changePassword(
                      currentPasswordController.text,
                      newPasswordController.text,
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ErrorService.showErrorSnackBar(context, e);
                    return;
                  }
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    showDialog(
                      context: context,
                      builder: (context) => PopupModal(
                        title: "Succès",
                        content:
                            "Votre mot de passe a été modifié avec succès.",
                        ctaText: "Ok",
                      ),
                    );
                  }
                },
                text: "Changer le mot de passe",
              ),
              Text(
                "* Les champs marqués sont obligatoires",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
