import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF510B0B); // Indigo
  static const Color textYellowColor = Color(0xFFE3B545); // Indigo
  static const Color secondaryColor = Color(0xFFFFFFFF); // White
  static const Color accentColor = Color(0xFFFF69B4); // Pink
  static const Color backgroundColor = Color(0xFFF9F9F9);
  static const Color buttonTextColor = Color(0xFFFFFFFF);
  static const Color borderGray = Color(0xFFDDDDDD);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color dangerColor = Color(0xFFF44336);
  static const Color wpColor = Color(0xFF158E3F);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: accentColor,
        background: backgroundColor,
        error: dangerColor,
        surface: secondaryColor,
      ),
      textTheme: GoogleFonts.poppinsTextTheme(
        const TextTheme(
          displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: primaryColor),
          displayMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: primaryColor),
          titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: primaryColor),
          bodyLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: primaryColor),
          bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: primaryColor),
        ),
      ),
      appBarTheme: const AppBarTheme(backgroundColor: primaryColor, foregroundColor: secondaryColor, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGray),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGray),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: primaryColor),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: dangerColor),
        ),
      ),
    );
  }
}
