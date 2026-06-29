import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Provider to hold the SharedPreferences instance
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('sharedPreferencesProvider is not initialized');
});

// Setting Keys
const String _themeKey = 'settings_theme_mode';
const String _coachStrictnessKey = 'settings_coach_strictness';

// Theme Mode Notifier
class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final themeIndex = prefs.getInt(_themeKey) ?? ThemeMode.system.index;
    return ThemeMode.values[themeIndex];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setInt(_themeKey, mode.index);
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

// AI Coach Strictness Notifier
class CoachStrictnessNotifier extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(_coachStrictnessKey) ?? false; // false = Gentle, true = Strict
  }

  Future<void> setStrictness(bool isStrict) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_coachStrictnessKey, isStrict);
    state = isStrict;
  }
}

final coachStrictnessProvider = NotifierProvider<CoachStrictnessNotifier, bool>(CoachStrictnessNotifier.new);
