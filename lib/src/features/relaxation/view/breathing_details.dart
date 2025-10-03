// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/resource_row.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';

class BreathingDetails extends StatefulWidget {
  const BreathingDetails({super.key});

  @override
  State<BreathingDetails> createState() => _BreathingDetailsState();
}

class _BreathingDetailsState extends State<BreathingDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7E879),
        foregroundColor: Colors.black,
        title: Text(
          "La respiration diaphragmatique",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 16,
            children: [
              RoundedContainer(
                borderColor: Color(0xFFF7E879),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(
                      "Bienfaits de la respiration diaphragmatique",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    ResourceRow(
                      title: "Physiques",
                      content:
                          "Amélioration de l'oxygénation : En permettant une respiration plus profonde, la respiration diaphragmatique augmente l'apport d'oxygène aux poumons et améliore l'élimination du dioxyde de carbone.﻿﻿﻿Réduction de la tension musculaire : La respiration diaphragmatique aide à détendre les muscles, en particulier ceux du cou et des épaules, souvent tendus par la respiration thoracique superficielle.﻿﻿﻿Amélioration de la fonction pulmonaire : En renforçant le diaphragme et en augmentant la capacité pulmonaire, cette technique peut améliorer la fonction respiratoire globale",
                    ),
                    ResourceRow(
                      title: "Mentaux",
                      content:
                          "Réduction du stress et de l'anxiété: La respiration diaphragmatique active le système nerveux parasympathique, induisant une réponse de relaxation qui réduit le stress et l'anxiété.﻿﻿﻿Amélioration de la concentration: En focalisant l'attention sur la respiration, cette technique peut améliorer la concentration et la pleine conscience.﻿﻿﻿Promotion du sommeil : En réduisant les niveaux de stress et en induisant une relaxation profonde, la respiration diaphragmatique peut améliorer la qualité du sommeil",
                    ),
                    ResourceRow(
                      title: "Émotionnels",
                      content:
                          "Gestion des émotions : La respiration diaphragmatique aide à réguler les émotions en apaisant le système nerveux et en favorisant un état de calme.﻿﻿﻿Amélioration de l'humeur : En réduisant le stress et l'anxiété, cette technique peut également améliorer l'humeur et le bien-être général",
                    ),
                  ],
                ),
              ),
              RoundedContainer(
                borderColor: Color(0xFFF7E879),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(
                      "Applications pratiques de la respiration diaphragmatique",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    ResourceRow(
                      title: "Gestion du stress",
                      content:
                          "La respiration diaphragmatique est couramment utilisée comme technique de gestion du stress. En activant le système nerveux parasympathique, elle aide à réduire les niveaux decortisol, une hormone du stress, et à induire une relaxation profonde.",
                    ),
                    ResourceRow(
                      title: "Performance sportive",
                      content:
                          "Les athlètes utilisent la respiration diaphragmatique pour améliorer leur performance en augmentant l'efficacité respiratoire et en aidant à gérer le stress de la compétition. Une meilleure oxygénation peut également améliorer l'endurance et la récupération.",
                    ),
                    ResourceRow(
                      title: "Réhabilitation et physiothérapie",
                      content:
                          "Les professionnels de la santé utilisent souvent la respiration diaphragmatique dans les programmes de réhabilitation et de physiothérapie pour améliorer la fonction pulmonaire chez les patients atteints de maladies respiratoires chroniques comme la BPCO ou l'asthme.",
                    ),
                    ResourceRow(
                      title: "Gestion de la douleur",
                      content:
                          "La respiration diaphragmatique peut également être utilisée comme technique de gestion de la douleur. En induisant une relaxation profonde et en réduisant les niveaux de stress, elle peut aider à atténuer la perception de la douleur. Lorsque nous respirons profondément, nous adoptons naturellement une meilleure posture. La respiration diaphragmatique encourage l'ouverture de la cage thoracique, redresse le dos et détend les épaules. Une bonne posture soulage les muscles et les articulations, réduisant ainsi les douleurs chroniques dans le dos, les épaules et le cou. En outre, une posture améliorée améliore la circulation sanguine et réduit les tensions. Cela contribue à une sensation de légèreté et d'aisance dans le corps, créant un cercle vertueux de bien-être physique.",
                    ),
                  ],
                ),
              ),
              RoundedContainer(
                borderColor: Color(0xFFF7E879),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(
                      "Comment intégrer la respiration diaphragmatique dans la vie quotidienne",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    ResourceRow(
                      title: "Pratique régulière",
                      content:
                          "Pour tirer le maximum de bénéfices de la respiration diaphragmatique, il est important de la pratiquer régulièrement. Essayez de consacrer quelques minutes chaque jour à cette technique, de préférence le matin ou avant de vous coucher.",
                    ),
                    ResourceRow(
                      title: "Intégration dans les activités quotidiennes",
                      content:
                          "Intégrez la respiration diaphragmatique dans vos activités quotidiennes. Par exemple, pratiquez-la pendant que vous travaillez, que vous lisez ou que vous regardez la télévision. Plus vous pratiquez, plus il devient facile de respirer de cette manière naturellement.",
                    ),
                    ResourceRow(
                      title: "Utilisation en cas de stress",
                      content:
                          "Utilisez la respiration diaphragmatique chaque fois que vous vous sentez stressé ou anxieux. Prenez quelques minutes pour vous concentrer sur votre respiration et vous calmer.",
                    ),
                  ],
                ),
              ),
              RoundedContainer(
                borderColor: Color(0xFFF7E879),
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(
                      "Techniques de respiration diaphragmatique",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    ResourceRow(
                      title: "Étapes de base",
                      content:
                          "Position initiale : Asseyez-vous ou allongez-vous confortablement avec les épaules détendues. Placez une main sur votre poitrine et l'autre sur votre abdomen. Inspiration : Inspirez lentement par le nez, en dirigeant l’air vers votre abdomen. Votre abdomen devrait se soulever, tandis que votre poitrine reste relativement immobile. Expiration : Expirez lentement par la bouche, en contractant légèrement les muscle abdominaux pour expulser l'air. Votre abdomen devrait se dégonfler. Répétition : Répétez ce processus pendant quelques minutes, en vous concentrant sur la montée et la descente de votre abdomen.",
                    ),
                    ResourceRow(
                      title: "Techniques avancées",
                      content:
                          "1. Respiration en 4-7-8 : ﻿﻿Inspirez par le nez pendant 4 secondes. ﻿﻿Retenez votre souffle pendant 7 secondes. ﻿﻿Expirez lentement par la bouche pendant 8 secondes. ﻿﻿Répétez cette séquence 4 à 8 fois.",
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
