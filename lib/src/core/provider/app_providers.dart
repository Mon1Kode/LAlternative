import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../service/app_service.dart';

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>(
  (ref) => ThemeModeNotifier(ref),
);

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  final Ref ref;
  ThemeModeNotifier(this.ref) : super(ThemeMode.light) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final service = ThemeService();
    state = await service.loadThemeMode();
  }

  Future<void> setTheme(ThemeMode mode) async {
    state = mode;
    await ThemeService().saveThemeMode(mode);
  }
}
