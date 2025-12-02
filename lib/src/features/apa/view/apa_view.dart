// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ApaView extends ConsumerStatefulWidget {
  const ApaView({super.key});

  @override
  ConsumerState<ApaView> createState() => _ApaViewState();
}

class _ApaViewState extends ConsumerState<ApaView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFBAE6FD),
        foregroundColor: Colors.black,
        title: Text(
          "Continuer à bouger",
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
                    "Faire quelque exercices pour rester actif",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => BreathingDetails(),
                        //   ),
                        // );
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
  final String? url;

  const SupportRoundedContainer({
    super.key,
    required this.imagePath,
    required this.text,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (url != null) {
          launchUrlString(url!);
        }
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
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
      ),
    );
  }
}
