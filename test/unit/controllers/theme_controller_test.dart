import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() {
  setUpAll(() async {
    await Hive.initFlutter();
  });

  group('ThemeMode String Conversion', () {
    test('_themeModeToString converts ThemeMode.light correctly', () {
      expect(_themeModeToString(ThemeMode.light), 'light');
    });

    test('_themeModeToString converts ThemeMode.dark correctly', () {
      expect(_themeModeToString(ThemeMode.dark), 'dark');
    });

    test('_themeModeToString converts ThemeMode.system correctly', () {
      expect(_themeModeToString(ThemeMode.system), 'system');
    });

    test('_stringToThemeMode converts light correctly', () {
      expect(_stringToThemeMode('light'), ThemeMode.light);
    });

    test('_stringToThemeMode converts dark correctly', () {
      expect(_stringToThemeMode('dark'), ThemeMode.dark);
    });

    test('_stringToThemeMode converts system correctly', () {
      expect(_stringToThemeMode('system'), ThemeMode.system);
    });

    test('_stringToThemeMode returns system for unknown value', () {
      expect(_stringToThemeMode('unknown'), ThemeMode.system);
    });
  });
}

ThemeMode _stringToThemeMode(String value) {
  return switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };
}

String _themeModeToString(ThemeMode mode) {
  return switch (mode) {
    ThemeMode.light => 'light',
    ThemeMode.dark => 'dark',
    ThemeMode.system => 'system',
  };
}
