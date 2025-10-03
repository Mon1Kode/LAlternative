// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/features/relaxation/view/breathing_details.dart';

class RelaxationView extends StatefulWidget {
  const RelaxationView({super.key});

  @override
  State<RelaxationView> createState() => _RelaxationViewState();
}

class _RelaxationViewState extends State<RelaxationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF7E879),
        foregroundColor: Colors.black,
        title: Text(
          "Pratiquer la relaxation",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 24,
          children: [
            RoundedContainer(
              padding: const EdgeInsets.all(8),
              borderColor: Color(0xFFF7E879),
              child: Column(
                spacing: 2,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "La respiration diaphragmatique",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Text(
                    "Techniques, Bienfaits et Applications",
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    "La respiration diaphragmatique, également connue sous le nom de respiration abdominale ou respiration profonde, est une technique de respiration qui utilise pleinement le diaphragme pour maximiser l'apport d'oxygène et améliorer l'efficacité respiratoire. Lorsque vous inspirez profondément, le diaphragme se contracte et descend, permettant aux poumons de se remplir d'air. À l'expiration, le diaphragme se détend et remonte, expulsant l'air des poumons.",
                    style: TextStyle(fontSize: 12, color: Color(0xFF6D6D6D)),
                    maxLines: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BreathingDetails(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.tertiary,
                      ),
                      child: Text(
                        "En savoir plus",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            RoundedContainer(
              padding: const EdgeInsets.all(8),
              borderColor: Color(0xFFF7E879),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Vidéo",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SupportRoundedContainer(
                          imagePath: "assets/images/relaxation_video.png",
                          text: "Respiration diaphragmatique",
                        ),
                        SizedBox(width: 16),
                        SupportRoundedContainer(
                          imagePath: "assets/images/relaxation_video.png",
                          text: "Méditation guidée",
                        ),
                        SizedBox(width: 16),
                        SupportRoundedContainer(
                          imagePath: "assets/images/relaxation_video.png",
                          text: "Relaxation musculaire",
                        ),
                        SizedBox(width: 16),
                        SupportRoundedContainer(
                          imagePath: "assets/images/relaxation_video.png",
                          text: "Visualisation positive",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            RoundedContainer(
              padding: const EdgeInsets.all(8),
              borderColor: Color(0xFFF7E879),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Témoignages",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        SupportRoundedContainer(
                          imagePath: "assets/images/marine_tem.png",
                          text: "Marine Chausson",
                        ),
                      ],
                    ),
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

class SupportRoundedContainer extends StatelessWidget {
  final String imagePath;
  final String text;

  const SupportRoundedContainer({
    super.key,
    required this.imagePath,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(
            context,
          ).colorScheme.secondary.withValues(alpha: 0.75),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 4,
          children: [
            Image.asset(
              "assets/images/play-circle.png",
              color: Theme.of(context).colorScheme.primary,
              width: 32,
            ),
            Text(
              text,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
