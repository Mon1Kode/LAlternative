// Shared services for the app
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
