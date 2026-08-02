import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:senzu_app/shared/design/app_colors.dart';

/// Builds the app's [ThemeData] from the design tokens in [AppColors].
///
/// Two typefaces, two jobs:
///  * Space Grotesk — display. Hero numbers, screen titles, ring labels.
///  * Manrope — body/UI. Lists, buttons, captions.
abstract final class AppTheme {
  static ThemeData dark() {
    const colors = AppColors.base;

    final textTheme = TextTheme(
      // Hero number: 56/700 Space Grotesk.
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
      ),
      // H1: screen titles.
      headlineLarge: GoogleFonts.spaceGrotesk(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: colors.textPrimary,
      ),
      // H2: section headers.
      headlineMedium: GoogleFonts.manrope(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      // App bar titles.
      titleLarge: GoogleFonts.spaceGrotesk(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
      // Body.
      bodyLarge: GoogleFonts.manrope(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        color: colors.textPrimary,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: colors.textPrimary,
      ),
      // Caption: 12/500, uppercase, +0.5 tracking.
      labelSmall: GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: colors.textSecondary,
      ),
      labelLarge: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
    );

    final base = ThemeData(brightness: Brightness.dark, useMaterial3: true);

    return base.copyWith(
      scaffoldBackgroundColor: colors.bgBase,
      canvasColor: colors.bgBase,
      colorScheme: ColorScheme.dark(
        primary: colors.energyStart,
        onPrimary: colors.bgBase,
        secondary: colors.energyEnd,
        surface: colors.bgBase,
        onSurface: colors.textPrimary,
        error: colors.danger,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        foregroundColor: colors.textPrimary,
        titleTextStyle: textTheme.titleLarge,
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.energyStart,
        strokeWidth: 2.5,
      ),
      dividerTheme: DividerThemeData(
        color: colors.glassBorder,
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.bgBase.withValues(alpha: 0.9),
        contentTextStyle: textTheme.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: colors.glassBorder),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.bgBase,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: colors.glassBorder),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.glassFill,
        hintStyle: textTheme.bodyLarge?.copyWith(color: colors.textSecondary),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.glassBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.glassBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.energyStart, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: colors.danger),
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.energyEnd,
        selectionColor: colors.energyStart,
        selectionHandleColor: colors.energyEnd,
      ),
      extensions: [colors],
    );
  }
}
