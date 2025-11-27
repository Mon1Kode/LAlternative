// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/resource_row.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FAQ",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 16,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResourceRow(
                title: "Comment fonctionne l'application ?",
                content:
                    "L'application propose des activités de relaxation basées sur la respiration, la méditation et la pleine conscience pour aider les utilisateurs à gérer le stress et améliorer leur bien-être mental.",
              ),
              ResourceRow(
                title:
                    "Quels sont les bienfaits de la respiration diaphragmatique ?",
                content:
                    "La respiration diaphragmatique peut aider à réduire le stress, améliorer la concentration, favoriser la relaxation et améliorer la qualité du sommeil.",
              ),
              ResourceRow(
                title: "L'application est-elle gratuite ?",
                content:
                    "Oui, l'application est gratuite à télécharger et à utiliser. Certaines fonctionnalités premium peuvent être disponibles via des achats intégrés.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
