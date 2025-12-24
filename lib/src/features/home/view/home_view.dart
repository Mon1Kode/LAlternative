// Copyright (c) 2025 Monikode. All rights reserved.
// Unauthorized copying of this file, via any medium, is strictly prohibited.
// Created by MoniK.

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:l_alternative/src/core/components/activity_card.dart';
import 'package:l_alternative/src/core/components/circle_image_button.dart';
import 'package:l_alternative/src/core/components/custom_button.dart';
import 'package:l_alternative/src/core/components/image_button.dart';
import 'package:l_alternative/src/core/components/rounded_container.dart';
import 'package:l_alternative/src/core/provider/app_providers.dart';
import 'package:l_alternative/src/core/utils/app_utils.dart';
import 'package:l_alternative/src/features/admin/provider/activities_provider.dart';
import 'package:l_alternative/src/features/connections/provider/user_provider.dart';
import 'package:l_alternative/src/features/notifications/provider/notifications_provider.dart';
import 'package:l_alternative/src/features/relaxation/view/activity_template.dart';
import 'package:l_alternative/src/features/relaxation/view/relaxation_view.dart';
import 'package:l_alternative/src/features/widgets/views/wd_streak.dart';
import 'package:monikode_event_store/monikode_event_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late PageController _pageController;
  late AnimationController _textAnimationController;
  late Animation<Offset> _slideAnimation;
  bool _isEditMode = false;
  bool _hasShownNotificationsDialog = false;

  String _selectedMood = "love.png";
  String _selectedFatigue = "cool.png";
  int _currentMoodPage = 0;

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

  // loader
  Widget _nextActivity = RoundedContainer(
    width: 300,
    height: 150,
    borderWidth: 1,
    padding: const EdgeInsets.all(8.0),
    child: Center(child: CircularProgressIndicator()),
  );

  // Map to define tool widths (in grid units)
  final Map<Widget, int> _toolWidths = {};
  var _toolsChildren = <Widget>[];
  late SharedPreferences prefs;

  Future<void> getUserConfig() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      _selectedMood = prefs.getString("mood") ?? "love.png";
      _selectedFatigue = prefs.getString("fatigue") ?? "cool.png";
      _toolsChildren =
          prefs
              .getStringList("tools")
              ?.map((tool) {
                if (tool.toString() == "WdStreak") return WdStreak();
                if (tool == "calendar") return _calendar;
                if (tool == "nextActivity") return _nextActivity;
                return null;
              })
              .whereType<Widget>()
              .toList() ??
          _toolsChildren;
    });
    await EventStore.getInstance().eventLogger.log(
      "user.config.loaded",
      EventLevel.debug,
      {
        "parameters": {
          "mood": _selectedMood,
          "tools": _toolsChildren.map((e) {
            if (e == WdStreak()) return "streak";
            if (e == _calendar) return "calendar";
            if (e == _nextActivity) return "nextActivity";
            return "";
          }).toList(),
        },
      },
    );
    getNextActivity();
  }

  Future<void> updateMoodHistoryList(String mood) async {
    List<String> moodHistory =
        prefs.getStringList("mood_history") ?? <String>[];
    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";
    moodHistory.removeWhere((entry) => entry.startsWith(todayString));
    moodHistory.add("$todayString:$mood");
    await prefs.setStringList("mood_history", moodHistory);
    await EventStore.getInstance().eventLogger.log(
      "mood.history.updated",
      EventLevel.info,
      {
        "parameters": {"mood_history": moodHistory},
      },
    );
  }

  Future<void> updateFatigueHistoryList(String fatigue) async {
    List<String> fatigueHistory =
        prefs.getStringList("fatigue_history") ?? <String>[];
    final today = DateTime.now();
    final todayString = "${today.year}-${today.month}-${today.day}";
    fatigueHistory.removeWhere((entry) => entry.startsWith(todayString));
    fatigueHistory.add("$todayString:$fatigue");
    await prefs.setStringList("fatigue_history", fatigueHistory);
    await EventStore.getInstance().eventLogger.log(
      "fatigue.history.updated",
      EventLevel.info,
      {
        "parameters": {"fatigue_history": fatigueHistory},
      },
    );
  }

  Future<void> selectMood() async {
    await prefs.setString("mood", _selectedMood);
    await EventStore.getInstance().eventLogger.log(
      "mood.selected",
      EventLevel.debug,
      {
        "parameters": {"mood": _selectedMood},
      },
    );
    updateMoodHistoryList(_selectedMood);
  }

  Future<void> selectFatigue() async {
    await prefs.setString("fatigue", _selectedFatigue);
    await EventStore.getInstance().eventLogger.log(
      "fatigue.selected",
      EventLevel.debug,
      {
        "parameters": {"fatigue": _selectedFatigue},
      },
    );
    updateFatigueHistoryList(_selectedFatigue);
  }

  Future<void> getNextActivity() async {
    var storedActivity = prefs.getStringList("next_activity");
    String title = storedActivity != null && storedActivity.isNotEmpty
        ? storedActivity[0]
        : "Pratiquer la relaxation";
    String description = storedActivity != null && storedActivity.length > 1
        ? storedActivity[1]
        : "Prend un moment pour te détendre";
    String imagePath = storedActivity != null && storedActivity.length > 2
        ? storedActivity[2]
        : "assets/images/relaxation.png";
    Color color = storedActivity != null && storedActivity.length > 3
        ? Color(int.parse(storedActivity[3]))
        : Color(0xFFF7E879);
    Widget actionView = RelaxationView();
    List<String> storedTools = prefs.getStringList("tools") ?? [];
    setState(() {
      _nextActivity = Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24.0),
            child: ActivityCard(
              title: title,
              description: description,
              imagePath: imagePath,
              actionView: actionView,
              color: color,
              hasImage: false,
              padding: EdgeInsets.all(4),
            ),
          ),
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(24.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => actionView),
                );
              },
              child: RoundedContainer(
                width: 300,
                height: 150,
                borderWidth: 1,
                padding: const EdgeInsets.all(8.0),
                color: Colors.black.withValues(alpha: 0.7),
                child: Center(
                  child: Text(
                    Utils.formatShortDate(DateTime.now()),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
      _toolWidths[_nextActivity] = 2;
      if (!storedTools.contains("nextActivity")) {
        _toolsChildren.add(_nextActivity);
      } else {
        int index = storedTools.indexWhere((tool) => tool == "nextActivity");
        if (index != -1) {
          _toolsChildren[index] = _nextActivity;
        }
      }
    });
    await prefs.setStringList("next_activity", [title, description, imagePath]);
    await prefs.setStringList(
      "tools",
      _toolsChildren.map((e) {
        if (e == WdStreak()) return "streak";
        if (e == _calendar) return "calendar";
        if (e == _nextActivity) return "nextActivity";
        return "";
      }).toList(),
    );
    await EventStore.getInstance().eventLogger.log(
      "next_activity.loaded",
      EventLevel.debug,
      {
        "parameters": {"activity": "Prochaine activité"},
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _pageController = PageController();
    _textAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(begin: Offset.zero, end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _textAnimationController,
            curve: Curves.easeInOut,
          ),
        );
    _toolWidths[WdStreak()] = 1;
    _toolWidths[_calendar] = 1;
    _toolWidths[_nextActivity] = 2;
    getUserConfig();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    _textAnimationController.dispose();
    super.dispose();
  }

  void _animateTextTransition(int newPage) {
    if (newPage != _currentMoodPage) {
      _slideAnimation =
          Tween<Offset>(
            begin: Offset.zero,
            end: newPage > _currentMoodPage
                ? Offset(-1.0, 0.0)
                : Offset(1.0, 0.0),
          ).animate(
            CurvedAnimation(
              parent: _textAnimationController,
              curve: Curves.easeInOut,
            ),
          );

      _textAnimationController.forward().then((_) {
        setState(() {
          _currentMoodPage = newPage;
        });
        _textAnimationController.reset();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var user = ref.watch(userProvider);
    final themeMode = ref.watch(themeModeProvider);
    var notifProvider = ref.watch(notificationsProvider);
    var activities = ref.watch(activitiesProvider);
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              themeMode == ThemeMode.dark
                  ? Theme.of(context).colorScheme.onPrimary
                  : Color(0xFFFFEAE4),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SingleChildScrollView(
                  child: Column(
                    spacing: 16,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ImageButton(
                            imagePath:
                                notifProvider.notifications
                                    .where(
                                      (e) => e.date.isBefore(DateTime.now()),
                                    )
                                    .isNotEmpty
                                ? "bell-dot.png"
                                : "bell.png",
                            size: 32,
                            onPressed: () {
                              Navigator.pushNamed(context, '/notifications');
                            },
                          ),
                          Text(
                            user.displayName,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          ImageButton(
                            imagePath: "user.png",
                            size: 32,
                            onPressed: () {
                              Navigator.pushNamed(context, '/profile');
                            },
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
                                                borderRadius:
                                                    BorderRadius.vertical(
                                                      top: Radius.circular(
                                                        24.0,
                                                      ),
                                                    ),
                                              ),
                                              padding: const EdgeInsets.all(
                                                16.0,
                                              ),
                                              child: SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  spacing: 16,
                                                  children: [
                                                    HomeToolsAddCard(
                                                      tool: WdStreak(),
                                                      toolsChildren:
                                                          _toolsChildren,
                                                      imagePath:
                                                          "plants/${user.streakIcon.toString().split(".").last}/${user.streakCount > 15 ? "15" : user.streakCount}.png",
                                                      text: "Streak",
                                                      onPressed: () {
                                                        setState(() {
                                                          _toolsChildren.add(
                                                            WdStreak(),
                                                          );
                                                        });
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    HomeToolsAddCard(
                                                      tool: _calendar,
                                                      toolsChildren:
                                                          _toolsChildren,
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
                                                      toolsChildren:
                                                          _toolsChildren,
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
                                            if (e.toString() == "WdStreak") {
                                              return "streak";
                                            }
                                            if (e == _calendar) {
                                              return "calendar";
                                            }
                                            if (e == _nextActivity) {
                                              return "nextActivity";
                                            }
                                            return "";
                                          }).toList(),
                                        );
                                        EventStore.getInstance().eventLogger
                                            .log(
                                              "user.tools.update",
                                              EventLevel.debug,
                                              {
                                                "parameters": {
                                                  "tools": _toolsChildren.map((
                                                    e,
                                                  ) {
                                                    if (e.toString() ==
                                                        "WdStreak") {
                                                      return "streak";
                                                    }
                                                    if (e == _calendar) {
                                                      return "calendar";
                                                    }
                                                    if (e == _nextActivity) {
                                                      return "nextActivity";
                                                    }
                                                    return "";
                                                  }).toList(),
                                                },
                                              },
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
                                                    _toolsChildren.remove(
                                                      child,
                                                    );
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
                          CustomButton(
                            text: "Plus",
                            onPressed: () {
                              ref
                                  .watch(userProvider.notifier)
                                  .incrementStreak();
                            },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 0,
                        children: [
                          SizedBox(
                            height: 30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ClipRect(
                                    child: AnimatedBuilder(
                                      animation: _textAnimationController,
                                      builder: (context, child) {
                                        return Stack(
                                          children: [
                                            SlideTransition(
                                              position: _slideAnimation,
                                              child: Text(
                                                _currentMoodPage == 0
                                                    ? "Humeur actuelle"
                                                    : "Fatigue actuelle",
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            if (_textAnimationController
                                                .isAnimating)
                                              SlideTransition(
                                                position:
                                                    Tween<Offset>(
                                                      begin:
                                                          _slideAnimation
                                                                  .value
                                                                  .dx <
                                                              0
                                                          ? Offset(1.0, 0.0)
                                                          : Offset(-1.0, 0.0),
                                                      end: Offset.zero,
                                                    ).animate(
                                                      _textAnimationController,
                                                    ),
                                                child: Text(
                                                  _currentMoodPage == 0
                                                      ? "Fatigue actuelle"
                                                      : "Humeur actuelle",
                                                  style: TextStyle(
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ImageButton(
                                      imagePath: "arrow-left.png",
                                      size: 24,
                                      onPressed: () {
                                        if (_currentMoodPage > 0) {
                                          _pageController.animateToPage(
                                            _currentMoodPage - 1,
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      color: _currentMoodPage == 0
                                          ? Colors.grey
                                          : null,
                                    ),
                                    SizedBox(width: 8),
                                    ImageButton(
                                      imagePath: "arrow-right.png",
                                      size: 24,
                                      onPressed: () {
                                        if (_currentMoodPage < 1) {
                                          _pageController.animateToPage(
                                            _currentMoodPage + 1,
                                            duration: Duration(
                                              milliseconds: 300,
                                            ),
                                            curve: Curves.easeInOut,
                                          );
                                        }
                                      },
                                      color: _currentMoodPage == 1
                                          ? Colors.grey
                                          : null,
                                    ),
                                    SizedBox(width: 8),
                                    ImageButton(
                                      imagePath: "chart.png",
                                      size: 24,
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/moodHistory',
                                          arguments: {
                                            "category": _currentMoodPage == 0
                                                ? "mood_history"
                                                : "fatigue_history",
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 70,
                            child: PageView(
                              controller: _pageController,
                              onPageChanged: (index) {
                                _animateTextTransition(index);
                              },
                              children: [
                                GestureDetector(
                                  onPanUpdate: (details) {
                                    // Swipe detection on mood row
                                    if (details.delta.dx > 10) {
                                      // Swipe right - go to previous page
                                      if (_currentMoodPage > 0) {
                                        _pageController.animateToPage(
                                          _currentMoodPage - 1,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    } else if (details.delta.dx < -10) {
                                      // Swipe left - go to next page
                                      if (_currentMoodPage < 1) {
                                        _pageController.animateToPage(
                                          _currentMoodPage + 1,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleImageButton(
                                        imagePath: "moods/love.png",
                                        isSelected: _selectedMood == "love.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedMood = "love.png";
                                          });
                                          selectMood();
                                        },
                                      ),
                                      CircleImageButton(
                                        imagePath: "moods/happy.png",
                                        isSelected:
                                            _selectedMood == "happy.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedMood = "happy.png";
                                          });
                                          selectMood();
                                        },
                                      ),
                                      CircleImageButton(
                                        imagePath: "moods/neutral.png",
                                        isSelected:
                                            _selectedMood == "neutral.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedMood = "neutral.png";
                                          });
                                          selectMood();
                                        },
                                      ),
                                      CircleImageButton(
                                        imagePath: "moods/frowning.png",
                                        isSelected:
                                            _selectedMood == "frowning.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedMood = "frowning.png";
                                          });
                                          selectMood();
                                        },
                                      ),
                                      CircleImageButton(
                                        imagePath: "moods/sad.png",
                                        isSelected: _selectedMood == "sad.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedMood = "sad.png";
                                          });
                                          selectMood();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onPanUpdate: (details) {
                                    if (details.delta.dx > 10) {
                                      if (_currentMoodPage > 0) {
                                        _pageController.animateToPage(
                                          _currentMoodPage - 1,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    } else if (details.delta.dx < -10) {
                                      if (_currentMoodPage < 1) {
                                        _pageController.animateToPage(
                                          _currentMoodPage + 1,
                                          duration: Duration(milliseconds: 300),
                                          curve: Curves.easeInOut,
                                        );
                                      }
                                    }
                                  },
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CircleImageButton(
                                        imagePath: "moods/cool.png",
                                        isSelected:
                                            _selectedFatigue == "cool.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedFatigue = "cool.png";
                                          });
                                          selectFatigue();
                                        },
                                      ),
                                      CircleImageButton(
                                        imagePath: "moods/okay.png",
                                        isSelected:
                                            _selectedFatigue == "okay.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedFatigue = "okay.png";
                                          });
                                          selectFatigue();
                                        },
                                      ),
                                      CircleImageButton(
                                        imagePath: "moods/empty.png",
                                        isSelected:
                                            _selectedFatigue == "empty.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedFatigue = "empty.png";
                                          });
                                          selectFatigue();
                                        },
                                      ),
                                      CircleImageButton(
                                        imagePath: "moods/tired.png",
                                        isSelected:
                                            _selectedFatigue == "tired.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedFatigue = "tired.png";
                                          });
                                          selectFatigue();
                                        },
                                      ),
                                      CircleImageButton(
                                        imagePath: "moods/sleep.png",
                                        isSelected:
                                            _selectedFatigue == "sleep.png",
                                        onPressed: () {
                                          setState(() {
                                            _selectedFatigue = "sleep.png";
                                          });
                                          selectFatigue();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        spacing: 8,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Activités",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              ImageButton(
                                imagePath: "arrow-right-circle.png",
                                size: 24,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          for (var activity in activities.activities) ...[
                            ActivityCard(
                              title: activity.title,
                              description: activity.subTitle,
                              imagePath: "assets/images/relaxation.png",
                              actionView: ActivityTemplate(model: activity),
                              color: activity.color,
                              isLast: activity == activities.activities.last,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (notifProvider.notifications
                      .where((e) => e.date.isBefore(DateTime.now()))
                      .isNotEmpty &&
                  !_hasShownNotificationsDialog)
                Builder(
                  builder: (context) {
                    _hasShownNotificationsDialog = true;
                    Future.microtask(() {
                      if (context.mounted) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Nouvelles notifications"),
                            content: Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (var notif
                                      in notifProvider.notifications.where(
                                        (e) => e.date.isBefore(DateTime.now()),
                                      ))
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(notif.body),
                                        if (notif.bodyBold.isNotEmpty)
                                          Text(
                                            notif.bodyBold,
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        if (notif.actionDetails.isNotEmpty)
                                          Text(notif.actionDetails),
                                        SizedBox(height: 16),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  "Fermer",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.secondary,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(
                                    context,
                                    "/notifications",
                                  );
                                },
                                child: Text(
                                  "Voir",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.tertiary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    });
                    return SizedBox.shrink();
                  },
                ),
            ],
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
