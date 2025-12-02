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
                title: "Qu’est-ce que l’application L’Alternative ?",
                content:
                    "L’Alternative est l’application réservée aux patients engagés dans le programme thérapeutique du CHAL et de l’association IncluSens. Elle permet de retrouver les ressources vues en atelier : textes explicatifs, vidéos guidées et témoignages de patients partenaires.",
              ),
              ResourceRow(
                title: "Qui peut utiliser l’application ?",
                content:
                    "Seules les personnes officiellement inscrites dans le programme L’Alternative peuvent accéder à l’application.",
              ),
              ResourceRow(
                title:
                    "Comment les ateliers sont-ils débloqués dans l’application ?",
                content:
                    "Les contenus ne s’ouvrent qu’après votre participation en présentiel à l’atelier correspondant.\nSi vous ne participez pas à une séance physique, le module associé ne sera pas visible ou accessible dans l’application.",
              ),
              ResourceRow(
                title:
                    "Pourquoi les ateliers ne sont-ils accessibles qu’après la séance ?",
                content:
                    "L’application est un support complémentaire. Elle sert à renforcer ce qui a été vu, expliqué et pratiqué avec les professionnels et les patients partenaires. Cela garantit la sécurité, la compréhension et l’accompagnement nécessaire.",
              ),
              ResourceRow(
                title:
                    "Je viens d’assister à un atelier mais le contenu n’est toujours pas débloqué. Que faire ?",
                content:
                    "Il peut y avoir un léger délai technique d’activation. Si le contenu ne s’affiche pas sous 24 h, contactez l’équipe du programme.",
              ),
              // ResourceRow(
              //   title: "Comment me connecter pour la première fois ?",
              //   content:
              //       "Après votre inscription au programme, vous ",
              // ),
              ResourceRow(
                title:
                    "Je ne trouve pas un atelier dans la liste, est-ce normal ?",
                content:
                    "Oui. L’application affiche uniquement les ateliers auxquels vous avez participé. Les autres apparaîtront lorsqu’ils seront débloqués après votre séance en présentiel.",
              ),
              ResourceRow(
                title: "Les vidéos ne se lancent pas, que puis-je faire ?",
                content:
                    "Vérifiez d’abord votre connexion internet puis relancez l’app. Si le problème persiste, contactez Victor (mettre ton mail inclusens).",
              ),
              ResourceRow(
                title: "À quoi servent les témoignages ?",
                content:
                    "Ils permettent de mieux comprendre la réalité de la douleur chronique à travers l’expérience de personnes qui vivent la même situation. Ils vous offrent des pistes concrètes, des conseils et un soutien moral.",
              ),
              ResourceRow(
                title: "Les exercices sont-ils sécurisés ?",
                content:
                    "Oui. Tous les exercices intégrés sont validés par les professionnels du CHAL et par les patients partenaires formés. Vous pouvez les réaliser à votre rythme.",
              ),
              ResourceRow(
                title: "Dois-je faire tous les exercices ?",
                content:
                    "Non. L’objectif est d’apprendre à écouter votre corps et de choisir ce qui vous convient le mieux selon votre niveau de fatigue ou de douleur.",
              ),
              ResourceRow(
                title:
                    "L’application remplace-t-elle les consultations médicales ?",
                content:
                    "Non. C’est un outil d’accompagnement complémentaire mais elle ne se substitue jamais à la prise en charge médicale ou psychologique.",
              ),
              ResourceRow(
                title: "Les professionnels voient-ils mes données ?",
                content:
                    "En partie, oui. Les professionnels du CHAL ont accès à certaines données d’utilisation de l’application (ateliers complétés, temps passé sur l’application) afin de mieux vous accompagner. Cependant, vos informations personnelles et vos réponses aux exercices restent confidentielles et ne sont pas partagées sans votre consentement.",
              ),
              ResourceRow(
                title: "Comment fonctionne l’historique des humeurs ?",
                content:
                    "Il vous suffit de sélectionner l’icône correspondant à votre ressenti du jour. L’historique permet ensuite de visualiser l’évolution de votre moral et de vos sensations au fil du programme.",
              ),
              ResourceRow(
                title: "Puis-je partager mon accès à quelqu’un d’autre ?",
                content:
                    "Non. Chaque accès est strictement personnel afin de préserver votre confidentialité et la cohérence thérapeutique.",
              ),
              ResourceRow(
                title: "Que faire si je me sens dépassé(e) ?",
                content:
                    "En cas de difficulté émotionnelle ou d’aggravation de la douleur, contactez votre médecin ou l’équipe du programme. L’application ne remplace pas une aide en cas d’urgence.",
              ),
              ResourceRow(
                title: "Je ne comprends pas un contenu, qui peut m'aider ?",
                content:
                    "Vous pouvez poser vos questions lors du prochain atelier ou contacter directement l’équipe (mon mail).",
              ),
              ResourceRow(
                title:
                    "Qui contacter en cas de problème technique ou d’accès ?",
                content:
                    "Pour toute question sur l’app, difficulté ou dysfonctionnement : victor.delamonica@icloud.com",
              ),
              ResourceRow(
                title: "Qui contacter en cas de questions sur le programme ? ",
                content: "Pour toutes questions : clarisse.hikoum@gmail.com",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
