// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:l_alternative/src/core/components/bar_chart.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/core/utils/app_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  final List<String> _moodImages = [
    "love.png",
    "happy.png",
    "neutral.png",
    "frowning.png",
    "sad.png",
  ];

  final Map<String, int> _moodCounts = {
    "love": 0,
    "happy": 0,
    "neutral": 0,
    "frowning": 0,
    "sad": 0,
  };

  final Map<DateTime, String> _moodHistory = {};

  int totalMoods = 0;

  Future<void> getAllMoods() async {
    var prefs = await SharedPreferences.getInstance();
    List<String> moodHistory =
        prefs.getStringList("mood_history") ?? <String>[];

    for (var moodEntry in moodHistory) {
      var parts = moodEntry.split(':');
      if (parts.length == 2) {
        DateFormat dateFormat = DateFormat('yyyy-MM-dd');
        DateTime? date = dateFormat.tryParse(parts[0]);
        if (date == null) continue;
        String mood = parts[1];
        _moodHistory[date] = mood;
      }
    }

    totalMoods = moodHistory.length;
    _moodCounts.updateAll((key, value) => 0);

    for (var mood in moodHistory) {
      var moodKey = mood.split(':').last.split('.').first;
      if (_moodCounts.containsKey(moodKey)) {
        _moodCounts[moodKey] = _moodCounts[moodKey]! + 1;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    getAllMoods();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          "Historique",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 24,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RoundedContainer(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Statistiques",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Total: $totalMoods"),
                            SizedBox(
                              width: size.width * 0.6,
                              height: 150,
                              child: BarChartSample4(
                                values: _moodCounts.values
                                    .map((e) => e.toDouble())
                                    .toList(),
                                maxY: totalMoods.toDouble() + 5,
                                xLabels: _moodImages
                                    .map(
                                      (e) => Image.asset(
                                        "assets/images/moods/$e",
                                        width: 100,
                                        height: 100,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        RoundedContainer(
                          width: 1,
                          height: 150,
                          color: Theme.of(context).colorScheme.secondary,
                          hasBorder: false,
                        ),
                        SizedBox(
                          height: 150,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            spacing: 6,
                            children: [
                              for (var mood in _moodCounts.entries)
                                Row(
                                  children: [
                                    Image.asset(
                                      "assets/images/moods/${mood.key}.png",
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text(
                                      _moodCounts[mood.key] != null
                                          ? " ${_moodCounts[mood.key]} (${totalMoods == 0 ? 0 : ((_moodCounts[mood.key]! / totalMoods) * 100).toInt()}%)"
                                          : " 0 (0%)",
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              RoundedContainer(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 8,
                  children: [
                    Text(
                      "Détails de l'historique",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    for (var entry
                        in _moodHistory.entries.toList()
                          ..sort((a, b) => b.key.compareTo(a.key)))
                      Column(
                        spacing: 4,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(Utils.formatDate(entry.key)),
                              Image.asset(
                                "assets/images/moods/${entry.value}",
                                width: 24,
                                height: 24,
                              ),
                            ],
                          ),
                          if (entry.key !=
                              _moodHistory.entries
                                  .toList()
                                  .reduce(
                                    (a, b) => a.key.isBefore(b.key) ? a : b,
                                  )
                                  .key)
                            Divider(),
                        ],
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
