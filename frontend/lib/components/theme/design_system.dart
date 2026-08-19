import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color surface = Color(0xFF151312);
  static const Color surfaceDim = Color(0xFF151312);
  static const Color surfaceBright = Color(0xFF3C3837);
  static const Color surfaceContainerLowest = Color(0xFF100E0D);
  static const Color surfaceContainerLow = Color(0xFF1D1B1A);
  static const Color surfaceContainer = Color(0xFF221F1E);
  static const Color surfaceContainerHigh = Color(0xFF2C2928);
  static const Color surfaceContainerHighest = Color(0xFF373433);
  static const Color onSurface = Color(0xFFE8E1DF);
  static const Color onSurfaceVariant = Color(0xFFD8C3AD);
  static const Color inverseSurface = Color(0xFFE8E1DF);
  static const Color inverseOnSurface = Color(0xFF33302E);
  static const Color outline = Color(0xFFA08E7A);
  static const Color outlineVariant = Color(0xFF534434);
  static const Color surfaceTint = Color(0xFFFFB95F);
  
  static const Color primary = Color(0xFFFFC174); // Burnt Amber
  static const Color onPrimary = Color(0xFF472A00);
  static const Color primaryContainer = Color(0xFFF59E0B);
  static const Color onPrimaryContainer = Color(0xFF613B00);
  static const Color inversePrimary = Color(0xFF855300);
  
  static const Color secondary = Color(0xFFFFB693); // Deep Clay
  static const Color onSecondary = Color(0xFF561F00);
  static const Color secondaryContainer = Color(0xFF76330D);
  static const Color onSecondaryContainer = Color(0xFFFC9E6F);
  
  static const Color tertiary = Color(0xFFD3CAC9);
  static const Color onTertiary = Color(0xFF342F2E);
  static const Color tertiaryContainer = Color(0xFFB7AFAD);
  static const Color onTertiaryContainer = Color(0xFF474241);
  
  static const Color error = Color(0xFFFFB4AB);
  static const Color onError = Color(0xFF690005);
  static const Color errorContainer = Color(0xFF93000A);
  static const Color onErrorContainer = Color(0xFFFFDAD6);
  
  static const Color background = Color(0xFF151312);
  static const Color onBackground = Color(0xFFE8E1DF);
  static const Color surfaceVariant = Color(0xFF373433);

  // Elevation & Depth Level values
  static const Color level0 = Color(0xFF0C0A09); // Level 0 (Base)
  static const Color level1 = Color(0xFF1C1917); // Level 1 (Cards/Navigation)
  static const Color level2 = Color(0xFF292524); // Level 2 (Modals/Popovers)
}

class AppTypography {
  static TextStyle get headlineXl => GoogleFonts.sora(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        height: 56 / 48,
        letterSpacing: -48 * 0.02,
      );

  static TextStyle get headlineLg => GoogleFonts.sora(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        height: 40 / 32,
        letterSpacing: -32 * 0.01,
      );

  static TextStyle get headlineLgMobile => GoogleFonts.sora(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        height: 36 / 28,
      );

  static TextStyle get bodyMd => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 24 / 16,
      );

  static TextStyle get bodySm => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 20 / 14,
      );

  static TextStyle get labelMd => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        height: 16 / 12,
        letterSpacing: 12 * 0.05,
      );
}

class AppShapes {
  static const double sm = 4.0;
  static const double base = 8.0; // DEFAULT
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double full = 9999.0;

  static BorderRadius get radiusSm => BorderRadius.circular(sm);
  static BorderRadius get radiusDefault => BorderRadius.circular(base);
  static BorderRadius get radiusMd => BorderRadius.circular(md);
  static BorderRadius get radiusLg => BorderRadius.circular(lg);
  static BorderRadius get radiusXl => BorderRadius.circular(xl);
  static BorderRadius get radiusFull => BorderRadius.circular(full);
}

class AppSpacing {
  static const double base = 8.0;
  static const double gutter = 24.0;
  static const double margin = 32.0;
  static const double containerMax = 1280.0;
}

class AppTheme {
  static ThemeData get themeData {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: AppColors.onSecondaryContainer,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onTertiary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: AppColors.onErrorContainer,
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        surfaceContainerLowest: AppColors.surfaceContainerLowest,
        surfaceContainerLow: AppColors.surfaceContainerLow,
        surfaceContainer: AppColors.surfaceContainer,
        surfaceContainerHigh: AppColors.surfaceContainerHigh,
        surfaceContainerHighest: AppColors.surfaceContainerHighest,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.surfaceTint,
      ),
      scaffoldBackgroundColor: AppColors.level0, // Void-like dark background
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.level1, // Level 1 for navigation
        indicatorColor: AppColors.primary.withAlpha(50),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTypography.labelMd.copyWith(color: AppColors.primary);
          }
          return AppTypography.labelMd.copyWith(color: AppColors.onSurfaceVariant);
        }),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.onSurface),
      ),
      cardTheme: CardThemeData(
        color: AppColors.level1, // Level 1 for card background
        elevation: 0, // No shadows as per DESIGN.md
        shape: RoundedRectangleBorder(
          borderRadius: AppShapes.radiusLg,
          side: const BorderSide(
            color: Color(0xFF2C2928), // Subtle Level 2 border
            width: 1.0,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.level1,
        border: OutlineInputBorder(
          borderRadius: AppShapes.radiusDefault,
          borderSide: const BorderSide(color: AppColors.outlineVariant, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusDefault,
          borderSide: const BorderSide(color: AppColors.outlineVariant, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppShapes.radiusDefault,
          borderSide: const BorderSide(color: AppColors.primary, width: 2.0),
        ),
        labelStyle: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
        hintStyle: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant.withAlpha(120)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0, // Shadowless aesthetic
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.radiusDefault,
          ),
          textStyle: AppTypography.labelMd.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
