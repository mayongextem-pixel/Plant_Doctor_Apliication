import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── "Green the Web" Design System ────────────────────────────────────────
  // Palet warna sesuai Design.md.md
  static const Color primaryColor        = Color(0xFF0B3D33); // Deep forest green
  static const Color secondaryColor      = Color(0xFF1F7A62); // Muted teal-green
  static const Color tertiaryColor       = Color(0xFFFCCC62); // Warm golden yellow (CTA)
  static const Color neutralColor        = Color(0xFFF5F5F2); // Soft off-white
  static const Color surfaceColor        = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceStrongColor  = Color(0xFF111111); // Dark
  static const Color onSurfaceColor      = Color(0xFF222222); // Main body text
  static const Color mutedColor          = Color(0xFFE5E7EB); // Light gray border
  static const Color subtleColor         = Color(0xFFD7DDD9); // Soft gray-green neutral
  static const Color accentColor         = Color(0xFF00B3A4); // Aqua accent
  static const Color errorColor          = Color(0xFFD64545); // Error red

  // Warna bantu lainnya (legacy compat & severity)
  static const Color white              = Color(0xFFFFFFFF);
  static const Color backgroundColor   = Color(0xFFF5F5F2); // = neutralColor
  static const Color primaryGreen      = Color(0xFF0B3D33); // alias
  static const Color lightGreen        = Color(0xFF1F7A62); // alias secondary
  static const Color darkGreen         = Color(0xFF082B23); // lebih gelap
  static const Color accentOrange      = Color(0xFFE07A5F); // terracotta (misc)
  static const Color accentYellow      = Color(0xFFFCCC62); // alias tertiary
  static const Color textDark          = Color(0xFF222222); // = onSurface
  static const Color textMedium        = Color(0xFF4F5D6E); // body teks sedang
  static const Color textLight         = Color(0xFF9BA4B5); // hint/muted
  static const Color errorRed          = Color(0xFFD64545); // alias error
  static const Color warningYellow     = Color(0xFFF4A261); // soft warning
  static const Color successGreen      = Color(0xFF1F7A62); // alias secondary

  // ── Typography ────────────────────────────────────────────────────────────
  // Menggunakan Poppins (Google Fonts) sebagai font utama — clean & modern
  static String? fontFamily = GoogleFonts.poppins().fontFamily;

  // headline-display: 38px / bold
  static const TextStyle displayLarge = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w700,
    color: onSurfaceColor,
    letterSpacing: 0,
    height: 1.3,
  );

  // headline-lg: 27px / bold
  static const TextStyle displayMedium = TextStyle(
    fontSize: 27,
    fontWeight: FontWeight.w700,
    color: onSurfaceColor,
    letterSpacing: 0,
    height: 1.3,
  );

  // headline-md: 21px / bold
  static const TextStyle titleLarge = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w700,
    color: onSurfaceColor,
    height: 1.4,
  );

  // headline-sm: 18px / semibold
  static const TextStyle titleMedium = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: onSurfaceColor,
    height: 1.22,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: onSurfaceColor,
  );

  // body-lg: 18px / regular
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: onSurfaceColor,
    height: 1.6,
  );

  // body-md: 16px / regular
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: onSurfaceColor,
    height: 1.6,
  );

  // body-sm: 14px / regular
  static const TextStyle bodySmall = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textMedium,
    height: 1.5,
  );

  // label-lg: 16px / regular
  static const TextStyle labelLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: onSurfaceColor,
    height: 1.2,
  );

  // label-md: 14px / regular
  static const TextStyle labelMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textMedium,
    height: 1.2,
  );

  // label-sm: 12px / regular
  static const TextStyle labelSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: textLight,
    height: 1.2,
  );

  // ── Border Radius ─────────────────────────────────────────────────────────
  // rounded.none=0, sm=4, md=5, lg=8, xl=12, full=9999
  static const double radiusNone   = 0.0;
  static const double radiusSmall  = 4.0;
  static const double radiusMedium = 5.0;
  static const double radiusLarge  = 8.0;
  static const double radiusXLarge = 12.0;
  static const double radiusFull   = 9999.0;

  // ── Spacing ───────────────────────────────────────────────────────────────
  // xs=6, sm=16, md=28, lg=48, xl=112
  static const double spacingXS  = 6.0;
  static const double spacingS   = 16.0;
  static const double spacingM   = 28.0;
  static const double spacingL   = 48.0;
  static const double spacingXL  = 112.0;

  // convenience aliases (compat dengan kode lama yang memakai spacingXXL)
  static const double spacingXXL = 48.0;

  // ── Elevation ─────────────────────────────────────────────────────────────
  static const double elevationLow    = 0.0; // flat — no shadow
  static const double elevationMedium = 1.0;
  static const double elevationHigh   = 2.0;

  // ── Card Decoration ───────────────────────────────────────────────────────
  // Cards: white bg, muted border, 8px radius — no heavy shadow
  static BoxDecoration cardDecoration = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(radiusLarge),
    border: Border.all(color: mutedColor, width: 1),
  );

  static BoxDecoration cardDecorationElevated = BoxDecoration(
    color: surfaceColor,
    borderRadius: BorderRadius.circular(radiusXLarge),
    border: Border.all(color: subtleColor, width: 1),
    boxShadow: [
      BoxShadow(
        color: onSurfaceColor.withValues(alpha: 0.06),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  // ── ThemeData ─────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: fontFamily,

      colorScheme: ColorScheme.light(
        primary: primaryColor,
        primaryContainer: secondaryColor,
        secondary: secondaryColor,
        secondaryContainer: tertiaryColor,
        tertiary: tertiaryColor,
        surface: neutralColor,
        surfaceContainerHighest: mutedColor,
        error: errorColor,
        onPrimary: white,
        onSecondary: white,
        onSurface: onSurfaceColor,
        onError: white,
      ),

      scaffoldBackgroundColor: neutralColor,

      // AppBar — flat, light background
      appBarTheme: AppBarTheme(
        backgroundColor: neutralColor,
        foregroundColor: onSurfaceColor,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: titleLarge.copyWith(fontFamily: fontFamily),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        iconTheme: const IconThemeData(color: onSurfaceColor),
      ),

      // Card — subtle border, no heavy shadow
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLarge),
          side: const BorderSide(color: mutedColor, width: 1),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: spacingS,
          vertical: spacingXS,
        ),
      ),

      // FAB — primary green (dark)
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusXLarge),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: textLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: labelMedium.copyWith(fontWeight: FontWeight.w600),
        unselectedLabelStyle: labelSmall,
      ),

      // Bottom Sheet
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(radiusXLarge),
          ),
        ),
        elevation: 2,
      ),

      // Input — white surface, 5px radius, no fill border
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: mutedColor, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: mutedColor, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          borderSide: const BorderSide(color: errorColor, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingS,
          vertical: 10,
        ),
        labelStyle: labelMedium,
        hintStyle: labelMedium.copyWith(color: textLight),
      ),

      // SearchBar
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStateProperty.all(surfaceColor),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
            side: const BorderSide(color: mutedColor),
          ),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: spacingS),
        ),
        textStyle: WidgetStateProperty.all(bodyMedium),
        hintStyle: WidgetStateProperty.all(
          bodyMedium.copyWith(color: textLight),
        ),
      ),

      // Elevated Button — button-secondary: dark green + white text
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 10,
          ),
          minimumSize: const Size(0, 38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: labelLarge.copyWith(fontFamily: fontFamily),
        ),
      ),

      // Outlined Button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          minimumSize: const Size(0, 38),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMedium),
          ),
          textStyle: labelLarge.copyWith(fontFamily: fontFamily),
        ),
      ),

      // Text Button — link style
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          padding: const EdgeInsets.symmetric(horizontal: spacingXS, vertical: 0),
          textStyle: labelLarge.copyWith(fontFamily: fontFamily),
        ),
      ),

      // Icon
      iconTheme: const IconThemeData(
        color: primaryColor,
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
        labelSmall: labelSmall,
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: mutedColor,
        thickness: 1,
        space: spacingS,
      ),

      // Chip — accent aqua, full rounding
      chipTheme: ChipThemeData(
        backgroundColor: accentColor,
        labelStyle: labelMedium.copyWith(color: white),
        padding: const EdgeInsets.symmetric(
          horizontal: spacingS,
          vertical: spacingXS,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
      ),
    );
  }

  // ── Helper methods ────────────────────────────────────────────────────────
  static Color getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'severe':
      case 'parah':
        return errorColor;
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

  static Color getAccuracyColor(double accuracy) {
    if (accuracy >= 0.8) {
      return successGreen;
    } else if (accuracy >= 0.6) {
      return warningYellow;
    } else {
      return errorColor;
    }
  }
}
