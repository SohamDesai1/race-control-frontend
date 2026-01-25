import 'package:flutter/material.dart';

class F1Theme {
  // F1 Brand Colors
  static const Color f1Red = Color(0xFFE10600);
  static const Color f1DarkRed = Color(0xFF8B0000);
  static const Color f1Black = Color(0xFF121212);
  static const Color f1DarkGray = Color(0xFF1E1E1E);
  static const Color f1MediumGray = Color(0xFF2D2D2D);
  static const Color f1LightGray = Color(0xFF3D3D3D);
  static const Color f1White = Color(0xFFFFFFFF);
  static const Color f1TextGray = Color(0xFFB0B0B0);

  // Team Colors
  static const Map<String, Color> teamColors = {
    'Mercedes': Color(0xFF00D2BE),
    'Red Bull': Color(0xFF0600EF),
    'Ferrari': Color(0xFFDC0000),
    'McLaren': Color(0xFFFF8700),
    'Alpine': Color(0xFF0090FF),
    'AlphaTauri': Color(0xFF2B4562),
    'Aston Martin': Color(0xFF006F62),
    'Williams': Color(0xFF005AFF),
    'Alfa Romeo': Color(0xFF900000),
    'Haas': Color(0xFFFFFFFF),
  };

  // Gradients
  static LinearGradient redGradient = LinearGradient(
    colors: [Color(0xFFE10600), Color(0xFF8B0000)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E1E), Color(0xFF2D2D2D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Theme Data
  static ThemeData get themeData => ThemeData(
    primaryColor: f1Red,
    scaffoldBackgroundColor: f1Black,
    cardColor: f1DarkGray,
    appBarTheme: AppBarTheme(
      backgroundColor: f1Black,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Formula1Bold',
        fontSize: 22,
        color: f1White,
        fontWeight: FontWeight.w700,
      ),
      iconTheme: IconThemeData(color: f1White),
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontFamily: 'Formula1Bold',
        fontSize: 32,
        color: f1White,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Formula1Bold',
        fontSize: 24,
        color: f1White,
        fontWeight: FontWeight.w600,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Formula1Bold',
        fontSize: 20,
        color: f1White,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Formula1Regular',
        fontSize: 18,
        color: f1White,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Formula1Regular',
        fontSize: 16,
        color: f1White,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Formula1Regular',
        fontSize: 16,
        color: f1White,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Formula1Regular',
        fontSize: 14,
        color: f1White,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Formula1Regular',
        fontSize: 12,
        color: f1TextGray,
      ),
      labelLarge: TextStyle(
        fontFamily: 'Formula1Bold',
        fontSize: 14,
        color: f1White,
        fontWeight: FontWeight.w600,
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: f1Red,
      secondary: f1DarkRed,
      surface: f1DarkGray,
      background: f1Black,
      error: Color(0xFFFF5252),
      onPrimary: f1White,
      onSecondary: f1White,
      onSurface: f1White,

      onError: f1Black,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: f1MediumGray,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: f1LightGray),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: f1Red, width: 2),
      ),
      labelStyle: TextStyle(color: f1TextGray),
      hintStyle: TextStyle(color: f1TextGray),
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: f1Red,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: f1Red,
        foregroundColor: f1White,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: TextStyle(
          fontFamily: 'Formula1Bold',
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: f1Red,
        side: BorderSide(color: f1Red, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        textStyle: TextStyle(
          fontFamily: 'Formula1Regular',
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    cardTheme: CardThemeData(
      color: f1DarkGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: EdgeInsets.zero,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: f1DarkGray,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      titleTextStyle: TextStyle(
        fontFamily: 'Formula1Bold',
        fontSize: 20,
        color: f1White,
      ),
      contentTextStyle: TextStyle(
        fontFamily: 'Formula1Regular',
        fontSize: 14,
        color: f1TextGray,
      ),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: f1Red,
      linearTrackColor: f1MediumGray,
      circularTrackColor: f1MediumGray,
    ),
    dividerTheme: DividerThemeData(color: f1LightGray, thickness: 1, space: 1),
  );

  // Animation durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Spacing
  static const double smallSpacing = 8;
  static const double mediumSpacing = 16;
  static const double largeSpacing = 24;
  static const double xLargeSpacing = 32;

  // Border radius
  static const BorderRadius smallBorderRadius = BorderRadius.all(
    Radius.circular(4),
  );
  static const BorderRadius mediumBorderRadius = BorderRadius.all(
    Radius.circular(8),
  );
  static const BorderRadius largeBorderRadius = BorderRadius.all(
    Radius.circular(12),
  );
  static const BorderRadius xLargeBorderRadius = BorderRadius.all(
    Radius.circular(16),
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 4,
      offset: Offset(0, 1),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 6,
      offset: Offset(0, 2),
    ),
  ];

  // Get team color by name
  static Color getTeamColor(String teamName) {
    for (final entry in teamColors.entries) {
      if (teamName.toLowerCase().contains(entry.key.toLowerCase())) {
        return entry.value;
      }
    }
    return f1White; // Default color
  }
}
