// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:monikode_event_store/monikode_event_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isEditMode = false;

  String _selectedMood = "love.png";

  final Widget _streak = Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Image.asset("assets/images/streak.png", width: 150, height: 150),
      ),
      RoundedContainer(
        width: 150,
        height: 150,
        borderWidth: 1,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "3 jours",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    ],
  );

  final Widget _calendar = Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Image.asset(
          "assets/images/calendar.png",
          width: 150,
          height: 150,
        ),
      ),
      RoundedContainer(
        width: 150,
        height: 150,
        borderWidth: 1,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Calendrier",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    ],
  );

  final Widget _nextActivity = Stack(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(24.0),
        child: Image.asset(
          "assets/images/calendar.png",
          width: 300,
          height: 150,
        ),
      ),
      RoundedContainer(
        width: 300,
        height: 150,
        borderWidth: 1,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              "Activité",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    ],
  );

  // Map to define tool widths (in grid units)
  final Map<Widget, int> _toolWidths = {};
  var _toolsChildren = <Widget>[];
  late SharedPreferences prefs;

  Future<void> getUserConfig() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMood = prefs.getString("mood") ?? "love.png";
      _toolsChildren =
          prefs
              .getStringList("tools")
              ?.map((tool) {
                if (tool == "streak") return _streak;
                if (tool == "calendar") return _calendar;
                if (tool == "nextActivity") return _nextActivity;
                return null;
              })
              .whereType<Widget>()
              .toList() ??
          _toolsChildren;
    });
    EventStore.getInstance().localEventStore
        .log("user_config_loaded", EventLevel.debug, {
          "mood": _selectedMood,
          "tools": _toolsChildren.map((e) {
            if (e == _streak) return "streak";
            if (e == _calendar) return "calendar";
            if (e == _nextActivity) return "nextActivity";
            return "";
          }).toList(),
        });
  }

  Future<void> updateMoodHistoryList(String mood) async {
    // Add the new mood to the history list by date
    List<String> moodHistory =
        prefs.getStringList("mood_history") ?? <String>[];
    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";
    moodHistory.removeWhere((entry) => entry.startsWith(todayString));
    moodHistory.add("$todayString:$mood");
    await prefs.setStringList("mood_history", moodHistory);
    EventStore.getInstance().localEventStore.log(
      "mood_history_updated",
      EventLevel.debug,
      {"mood_history": moodHistory},
    );
  }

  Future<void> selectMood() async {
    await prefs.setString("mood", _selectedMood);
    EventStore.getInstance().localEventStore.log(
      "mood_selected",
      EventLevel.debug,
      {"mood": _selectedMood},
    );
    updateMoodHistoryList(_selectedMood);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _toolWidths[_streak] = 1;
    _toolWidths[_calendar] = 1;
    _toolWidths[_nextActivity] = 2;
    getUserConfig();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).colorScheme.primary, Color(0xFFFFEAE4)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: SingleChildScrollView(
              child: Column(
                spacing: 24,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Bon retour,", style: TextStyle(fontSize: 24)),
                          Text(
                            "MoniK",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(99.0),
                          onTap: () {
                            Navigator.pushNamed(context, '/profile');
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset(
                              "assets/images/avatar.png",
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Outils",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              if (_isEditMode)
                                ImageButton(
                                  imagePath: "plus-circle.png",
                                  size: 24,
                                  onPressed: () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (context) {
                                        return Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.tertiary,
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(24.0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.all(16.0),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              spacing: 16,
                                              children: [
                                                HomeToolsAddCard(
                                                  tool: _streak,
                                                  toolsChildren: _toolsChildren,
                                                  imagePath: "streak.png",
                                                  text: "Streak",
                                                  onPressed: () {
                                                    setState(() {
                                                      _toolsChildren.add(
                                                        _streak,
                                                      );
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                HomeToolsAddCard(
                                                  tool: _calendar,
                                                  toolsChildren: _toolsChildren,
                                                  imagePath: "calendar.png",
                                                  text: "Calendrier",
                                                  onPressed: () {
                                                    setState(() {
                                                      _toolsChildren.add(
                                                        _calendar,
                                                      );
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                                HomeToolsAddCard(
                                                  tool: _nextActivity,
                                                  toolsChildren: _toolsChildren,
                                                  imagePath: "calendar.png",
                                                  text: "Activité",
                                                  onPressed: () {
                                                    setState(() {
                                                      _toolsChildren.add(
                                                        _nextActivity,
                                                      );
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ImageButton(
                                imagePath: _isEditMode
                                    ? "save.png"
                                    : "edit.png",
                                size: 24,
                                onPressed: () async {
                                  if (_isEditMode) {
                                    await prefs.setStringList(
                                      "tools",
                                      _toolsChildren.map((e) {
                                        if (e == _streak) return "streak";
                                        if (e == _calendar) return "calendar";
                                        if (e == _nextActivity) {
                                          return "nextActivity";
                                        }
                                        return "";
                                      }).toList(),
                                    );
                                  }
                                  setState(() {
                                    _isEditMode = !_isEditMode;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: StaggeredGrid.count(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          children: [
                            for (var child in _toolsChildren)
                              StaggeredGridTile.count(
                                crossAxisCellCount: _toolWidths[child] ?? 1,
                                mainAxisCellCount: 1,
                                child: ShakeWidget(
                                  animate: _isEditMode,
                                  child: Stack(
                                    children: [
                                      child,
                                      if (_isEditMode)
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _toolsChildren.remove(child);
                                              });
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                shape: BoxShape.circle,
                                              ),
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 20,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Humeur actuelle",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              ImageButton(
                                imagePath: "chart.png",
                                size: 24,
                                onPressed: () {
                                  Navigator.pushNamed(context, '/moodHistory');
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleMoods(
                            mood: "love.png",
                            selectedMood: _selectedMood,
                            onPressed: () {
                              setState(() {
                                _selectedMood = "love.png";
                              });
                              selectMood();
                            },
                          ),
                          CircleMoods(
                            mood: "happy.png",
                            selectedMood: _selectedMood,
                            onPressed: () {
                              setState(() {
                                _selectedMood = "happy.png";
                              });
                              selectMood();
                            },
                          ),
                          CircleMoods(
                            mood: "neutral.png",
                            selectedMood: _selectedMood,
                            onPressed: () {
                              setState(() {
                                _selectedMood = "neutral.png";
                              });
                              selectMood();
                            },
                          ),
                          CircleMoods(
                            mood: "frowning.png",
                            selectedMood: _selectedMood,
                            onPressed: () {
                              setState(() {
                                _selectedMood = "frowning.png";
                              });
                              selectMood();
                            },
                          ),
                          CircleMoods(
                            mood: "sad.png",
                            selectedMood: _selectedMood,
                            onPressed: () {
                              setState(() {
                                _selectedMood = "sad.png";
                              });
                              selectMood();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ShakeWidget extends StatefulWidget {
  final Widget child;
  final bool animate;
  final Duration duration;

  const ShakeWidget({
    super.key,
    required this.child,
    required this.animate,
    this.duration = const Duration(milliseconds: 200),
  });

  @override
  State<ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant ShakeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.animate && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double angle = widget.animate
            ? math.sin(_controller.value * 2 * math.pi) * (1.33 * math.pi / 180)
            : 0;
        return Transform.translate(
          offset: Offset(0, 0),
          child: Transform.rotate(
            angle: angle,
            alignment: Alignment.center,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}

class HomeToolsAddCard extends StatefulWidget {
  final Widget tool;
  final List<Widget> toolsChildren;
  final String imagePath;
  final String text;
  final VoidCallback onPressed;

  const HomeToolsAddCard({
    super.key,
    required this.tool,
    required this.toolsChildren,
    required this.imagePath,
    required this.text,
    required this.onPressed,
  });

  @override
  State<HomeToolsAddCard> createState() => _HomeToolsAddCardState();
}

class _HomeToolsAddCardState extends State<HomeToolsAddCard> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ImageButton(
          imagePath: widget.imagePath,
          text: widget.text,
          size: 100,
          fontSize: 14,
          borderRadius: 24.0,
          alignment: Alignment.bottomCenter,
          isColored: false,
          onPressed: () {
            if (widget.toolsChildren.contains(widget.tool)) {
              return;
            }
            widget.onPressed();
          },
        ),
        if (widget.toolsChildren.contains(widget.tool))
          RoundedContainer(
            width: 100,
            height: 100,
            hasBorder: false,
            color: Colors.black.withValues(alpha: 0.5),
            child: Icon(Icons.check, color: Colors.green.shade300, size: 48),
          ),
      ],
    );
  }
}

class CircleMoods extends StatelessWidget {
  final String mood;
  final String selectedMood;
  final VoidCallback onPressed;
  const CircleMoods({
    super.key,
    required this.mood,
    required this.selectedMood,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return RoundedContainer(
      borderRadius: 999,
      borderWidth: 1,
      borderColor: Theme.of(context).colorScheme.tertiary,
      width: size.width * 0.15,
      height: size.width * 0.15,
      child: CircleAvatar(
        backgroundColor: selectedMood == mood
            ? Theme.of(context).colorScheme.tertiary
            : Colors.transparent,
        radius: 999,
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: ImageButton(
            imagePath: "moods/$mood",
            onPressed: onPressed,
            size: size.width * 0.1,
            isColored: false,
            // borderRadius: 999,
          ),
        ),
      ),
    );
  }
}
