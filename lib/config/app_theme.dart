import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppTheme {
  // Modern Earthy Green Color Palette (update_design.md)
  static const Color primaryGreen = Color(0xFF4A7C59); // Moss Green
  static const Color darkGreen = Color(0xFF2F5233); // Olive Green
  static const Color lightGreen = Color(0xFF7FB069); // Light Moss
  static const Color backgroundColor = Color(0xFFFFFBF5); // Cream/Off-white
  static const Color surfaceColor = Color(0xFFF5F5F0); // Soft Gray
  static const Color accentOrange = Color(0xFFE07A5F); // Terracotta
  static const Color accentYellow = Color(0xFFF2CC8F); // Soft Gold
  static const Color textDark = Color(0xFF2D3142); // Charcoal
  static const Color textMedium = Color(0xFF4F5D75); // Blue Gray
  static const Color textLight = Color(0xFF9BA4B5); // Light Gray
  static const Color errorRed = Color(0xFFD64545); // Soft Red
  static const Color warningYellow = Color(0xFFF4A261); // Warm Yellow
  static const Color successGreen = Color(0xFF81B29A); // Sage Green
  static const Color white = Color(0xFFFFFFFF);


  // Modern Typography (Bold sans-serif for headers, clean for body)
  static const String fontFamily = 'Inter'; // You can use system default or add custom font
  
  static const TextStyle displayLarge = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: textDark,
    letterSpacing: -0.5,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textDark,
    letterSpacing: -0.3,
  );

  static const TextStyle titleLarge = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textDark,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textDark,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: textDark,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: textMedium,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: textMedium,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: textLight,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: white,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: textMedium,
  );

  // Rounded Corner Radius (16-24px as per design)
  static const double radiusSmall = 12.0;
  static const double radiusMedium = 16.0;
  static const double radiusLarge = 24.0;
  static const double radiusXLarge = 32.0;

  // Spacing
  static const double spacingXS = 4.0;
  static const double spacingS = 8.0;
  static const double spacingM = 16.0;
  static const double spacingL = 24.0;
  static const double spacingXL = 32.0;
  static const double spacingXXL = 48.0;

  // Elevation
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;


  // Modern Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(radiusMedium),
    boxShadow: [
      BoxShadow(
        color: primaryGreen.withValues(alpha: 0.08),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static BoxDecoration cardDecorationElevated = BoxDecoration(
    color: white,
    borderRadius: BorderRadius.circular(radiusLarge),
    boxShadow: [
      BoxShadow(
        color: primaryGreen.withValues(alpha: 0.12),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ],
  );

  // Updated ThemeData
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      
      // Color Scheme
      colorScheme: ColorScheme.light(
        primary: primaryGreen,
        primaryContainer: lightGreen,
        secondary: accentOrange,
        secondaryContainer: accentYellow,
        surface: backgroundColor,
        surfaceContainerHighest: surfaceColor,
        error: errorRed,
        onPrimary: white,
        onSecondary: white,
        onSurface: textDark,
        onError: white,
      ),
      
      scaffoldBackgroundColor: backgroundColor,
      
      // AppBar Theme
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        foregroundColor: textDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: textDark),
      ),

      // Card Theme (Rounded 16-24px)
      cardTheme: CardThemeData(
        color: white,
        elevation: elevationLow,
        shadowColor: primaryGreen.withValues(alpha: 0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS,
        ),
      ),

      // FloatingActionButton Theme (Prominent & Oversized)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryGreen,
        foregroundColor: white,
        elevation: elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
        ),
        extendedSizeConstraints: const BoxConstraints.tightFor(
          height: 64,
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        elevation: elevationMedium,
        selectedLabelStyle: labelMedium,
        unselectedLabelStyle: bodySmall,
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusLarge),
          ),
        ),
        elevation: elevationHigh,
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryGreen, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorRed, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingM,
        ),
        hintStyle: bodyMedium.copyWith(color: textLight),
      ),

      // SearchBar Theme
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(surfaceColor),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: spacingM),
        ),
        textStyle: WidgetStateProperty.all(bodyMedium),
        hintStyle: WidgetStateProperty.all(
          bodyMedium.copyWith(color: textLight),
        ),
      ),

      // Button Themes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: white,
          elevation: elevationLow,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: labelLarge,
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryGreen,
          side: const BorderSide(color: primaryGreen, width: 2),
          padding: const EdgeInsets.symmetric(
            horizontal: spacingL,
            vertical: spacingM,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: labelLarge.copyWith(color: primaryGreen),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryGreen,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingM,
            vertical: spacingS,
          ),
          textStyle: labelMedium,
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: primaryGreen,
        size: 24,
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: textLight.withValues(alpha: 0.2),
        thickness: 1,
        space: spacingM,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: lightGreen,
        labelStyle: labelMedium,
        padding: const EdgeInsets.symmetric(
          horizontal: spacingM,
          vertical: spacingS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
        ),
      ),
    );
  }

  // Helper method to get severity color
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'parah':
        return errorRed;
      case 'moderate':
      case 'sedang':
        return warningYellow;
      case 'mild':
      case 'ringan':
        return accentOrange;
      case 'healthy':
      case 'sehat':
        return successGreen;
      default:
        return textLight;
    }
  }

  // Helper method to get accuracy badge color
  static Color getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) {
      return successGreen;
    } else if (accuracy >= 0.6) {
      return warningYellow;
    } else {
      return errorRed;
    }
  }
}
