import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const _lightPrimary = Color(0xFF134074);
  static const _lightSecondary = Color(0xFF018ABE);
  static const _lightTertiary = Color(0xFF22C7F2);
  static const _lightBackground = Color(0xFFF8FAFC);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightSurfaceVariant = Color(0xFFEEF5F9);
  static const _lightOutline = Color(0xFFDCE7EF);
  static const _error = Color(0xFFEF4444);

  // Dark Theme Colors
  static const _darkBackground = Color(0xFF020817);
  static const _darkSurface = Color(0xFF0F172A);
  static const _darkSurfaceVariant = Color(0xFF1E293B);
  static const _darkPrimary = Color(0xFF22C7F2);
  static const _darkSecondary = Color(0xFF38BDF8);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: _lightPrimary,
        secondary: _lightSecondary,
        tertiary: _lightTertiary,
        background: _lightBackground,
        surface: _lightSurface,
        surfaceContainerHighest: _lightSurfaceVariant,
        outline: _lightOutline,
        error: _error,
      ),
      scaffoldBackgroundColor: _lightBackground,
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
        bodyColor: const Color(0xFF0F172A),
        displayColor: const Color(0xFF0F172A),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: _lightTertiary.withOpacity(0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _lightTertiary);
          }
          return const IconThemeData(color: Color(0xFF475569));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: _lightTertiary, fontWeight: FontWeight.bold);
          }
          return const TextStyle(color: Color(0xFF475569));
        }),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: _darkPrimary,
        secondary: _darkSecondary,
        tertiary: _lightTertiary,
        background: _darkBackground,
        surface: _darkSurface,
        surfaceContainerHighest: _darkSurfaceVariant,
        error: _error,
      ),
      scaffoldBackgroundColor: _darkBackground,
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
        bodyColor: const Color(0xFFF8FAFC),
        displayColor: const Color(0xFFF8FAFC),
      ),
      navigationBarTheme: NavigationBarThemeData(
        indicatorColor: _darkPrimary.withOpacity(0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _darkPrimary);
          }
          return const IconThemeData(color: Color(0xFF94A3B8));
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: _darkPrimary, fontWeight: FontWeight.bold);
          }
          return const TextStyle(color: Color(0xFF94A3B8));
        }),
      ),
    );
  }
}
