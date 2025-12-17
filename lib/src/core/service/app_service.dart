// Shared services for the app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  static const _themeKey = 'theme_mode';

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, mode.name);
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_themeKey);
    if (modeStr == ThemeMode.dark.name) return ThemeMode.dark;
    if (modeStr == ThemeMode.light.name) return ThemeMode.light;
    if (modeStr == ThemeMode.system.name) return ThemeMode.system;
    return ThemeMode.system;
  }
}

class StatService {
  Future<List<Map<String, dynamic>>> getConnectionsStats() async {
    //Get all logs from firebase firestore with the logs collection "logs" and filter by event type "user.login"
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('logs')
          .where('event', isEqualTo: 'user.daily_login')
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      // Handle errors appropriately
      throw Exception('Failed to fetch connection stats: $e');
    }
  }

  Future<Map<String, int>> getLoginStatsPerDay() async {
    try {
      final logs = await getConnectionsStats();
      final Map<String, int> statsPerDay = {};

      for (var log in logs) {
        // Assuming the log has a timestamp field
        if (log.containsKey('timestamp')) {
          DateTime date;

          // Handle different timestamp formats
          if (log['timestamp'] is Timestamp) {
            date = (log['timestamp'] as Timestamp).toDate();
          } else if (log['timestamp'] is DateTime) {
            date = log['timestamp'] as DateTime;
          } else if (log['timestamp'] is String) {
            date = DateTime.parse(log['timestamp']);
          } else {
            continue; // Skip if timestamp format is not recognized
          }

          // Format date as YYYY-MM-DD for grouping
          final dateKey =
              '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

          statsPerDay[dateKey] = (statsPerDay[dateKey] ?? 0) + 1;
        }
      }

      return statsPerDay;
    } catch (e) {
      throw Exception('Failed to calculate login stats per day: $e');
    }
  }
}
