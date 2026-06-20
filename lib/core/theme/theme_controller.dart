import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  ThemeController.new,
);

class ThemeController extends Notifier<ThemeMode> {
  static const String _themeModeKey = 'themeMode';
  static const String _themeBoxName = 'theme_settings';

  @override
  ThemeMode build() {
    try {
      final box = Hive.box<String>(_themeBoxName);
      final savedMode = box.get(_themeModeKey) ?? 'system';
      return _stringToThemeMode(savedMode);
    } catch (e) {
      return ThemeMode.system;
    }
  }

  void toggleTheme() {
    final newMode = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveThemeMode(newMode);
    state = newMode;
  }

  void setThemeMode(ThemeMode mode) {
    _saveThemeMode(mode);
    state = mode;
  }

  void _saveThemeMode(ThemeMode mode) {
    try {
      final box = Hive.box<String>(_themeBoxName);
      box.put(_themeModeKey, _themeModeToString(mode));
    } catch (e) {
      debugPrint('Failed to save theme mode: $e');
    }
  }

  static ThemeMode _stringToThemeMode(String value) {
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
  }

  static String _themeModeToString(ThemeMode mode) {
    return switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
  }
}
