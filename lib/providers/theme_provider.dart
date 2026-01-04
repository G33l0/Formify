import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

// Theme mode provider
final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, ThemeMode>((ref) {
  return ThemeModeNotifier();
});

class ThemeModeNotifier extends StateNotifier<ThemeMode> {
  ThemeModeNotifier() : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final _settingsBox = Hive.box('settings');

  Future<void> _loadThemeMode() async {
    final themeString = _settingsBox.get('themeMode', defaultValue: 'system');
    state = _themeModeFromString(themeString);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _settingsBox.put('themeMode', mode.toString().split('.').last);
  }

  ThemeMode _themeModeFromString(String value) {
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
