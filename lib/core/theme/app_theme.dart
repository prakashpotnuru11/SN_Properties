import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const primary = Color(0xFF4B1D73);
  static const deepViolet = Color(0xFF35104F);
  static const accent = Color(0xFFD4AF37);
  static const ink = Color(0xFF17151C);
  static const mutedInk = Color(0xFF625D68);
  static const surface = Color(0xFFFFFFFF);
  static const canvas = Color(0xFFF8F7FA);

  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: primary,
      onPrimary: Colors.white,
      primaryContainer: const Color(0xFFEDE5F3),
      onPrimaryContainer: deepViolet,
      secondary: accent,
      onSecondary: deepViolet,
      surface: surface,
      onSurface: ink,
      onSurfaceVariant: mutedInk,
      outline: const Color(0xFF817B87),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: canvas,
      fontFamily: 'sans',
      appBarTheme: const AppBarTheme(
        backgroundColor: canvas,
        foregroundColor: primary,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: mutedInk),
        floatingLabelStyle: const TextStyle(color: primary),
        hintStyle: const TextStyle(color: mutedInk),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: primary.withValues(alpha: 0.12),
          disabledForegroundColor: mutedInk,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: primary,
          overlayColor: primary.withValues(alpha: 0.08),
        ),
      ),
      focusColor: primary.withValues(alpha: 0.12),
      hoverColor: primary.withValues(alpha: 0.06),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.12),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData?>(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected) ? primary : mutedInk,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>(
          (states) => TextStyle(
            color: states.contains(WidgetState.selected) ? primary : mutedInk,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
