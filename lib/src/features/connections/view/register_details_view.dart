// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/custom_text_field.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';

class RegisterDetailsView extends ConsumerStatefulWidget {
  const RegisterDetailsView({super.key});

  @override
  ConsumerState<RegisterDetailsView> createState() =>
      _RegisterDetailsViewState();
}

class _RegisterDetailsViewState extends ConsumerState<RegisterDetailsView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();

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
                "Créez votre profil.",
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nom*",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    textController: lastNameController,
                    hintText: "Ex. Doe",
                    obscureText: false,
                  ),
                ],
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Prénom*",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  CustomTextField(
                    textController: nameController,
                    hintText: "Ex. John",
                    obscureText: false,
                  ),
                ],
              ),
              Column(
                spacing: 3,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Photo de profil*",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(8),
                    elevation: 3,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(8),
                      onTap: () async {
                        // _profilePicture = await showModalBottomSheet<File>(
                        //   context: context,
                        //   builder: (_) {
                        //     return SizedBox(
                        //       child: Padding(
                        //         padding: const EdgeInsets.all(24.0),
                        //         child: Column(
                        //           mainAxisSize: MainAxisSize.min,
                        //           spacing: 16,
                        //           children: [
                        //             CustomButton(
                        //               onPressed: () {
                        //                 final ImagePicker picker =
                        //                     ImagePicker();
                        //                 picker
                        //                     .pickImage(
                        //                       source: ImageSource.gallery,
                        //                     )
                        //                     .then((pickedFile) {
                        //                       if (pickedFile != null) {
                        //                         Navigator.pop(
                        //                           // ignore: use_build_context_synchronously
                        //                           context,
                        //                           File(pickedFile.path),
                        //                         );
                        //                       }
                        //                     });
                        //               },
                        //               text: "Depuis la galerie",
                        //             ),
                        //             CustomButton(
                        //               onPressed: () async {
                        //                 final ImagePicker picker =
                        //                     ImagePicker();
                        //                 final XFile? pickedFile = await picker
                        //                     .pickImage(
                        //                       source: ImageSource.camera,
                        //                     );
                        //                 if (pickedFile != null) {
                        //                   WidgetsBinding.instance
                        //                       .addPostFrameCallback((_) {
                        //                         if (!mounted) return;
                        //                         Navigator.pop(
                        //                           context,
                        //                           File(pickedFile.path),
                        //                         );
                        //                       });
                        //                 }
                        //               },
                        //               text: "Prendre une photo",
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     );
                        //   },
                        // );
                        setState(() {});
                      },
                      child: //_profilePicture?.path != null
                          //     ? ClipRRect(
                          //         borderRadius: BorderRadius.circular(8),
                          //         child: Image.file(
                          //           File(_profilePicture!.path),
                          //           height: 108,
                          //           width: double.infinity,
                          //           fit: BoxFit.fitHeight,
                          //         ),
                          //       )
                          //     :
                          SizedBox(
                            height: 108,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cloud_upload_outlined,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(alpha: 0.7),
                                  ),
                                  Text(
                                    "Appuyez pour choisir une photo",
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
              CustomButton(
                onPressed: () async {
                  if (nameController.text.isNotEmpty &&
                      lastNameController
                          .text
                          .isNotEmpty //&&
                  //_profilePicture != null
                  ) {
                    await user.updateUserDetails(
                      firstName: nameController.text,
                      lastName: lastNameController.text,
                      // profilePicture: _profilePicture!.path,
                    );
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/home',
                        ModalRoute.withName('/'),
                      );
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Veuillez remplir tous les champs obligatoires.",
                        ),
                      ),
                    );
                  }
                },
                text: "Terminer l’inscription",
              ),
              Text(
                "* Les champs marqués sont obligatoires",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
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
