import 'package:flutter/material.dart';

/// Design tokens for the Senzu design system.
///
/// This is the single source of truth for every color in the app. Screens
/// should pull tokens through `context.appColors` instead of hardcoding hex
/// values. See DESIGN.md for the reasoning behind each token.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.bgBase,
    required this.glassFill,
    required this.glassBorder,
    required this.glassHighlight,
    required this.textPrimary,
    required this.textSecondary,
    required this.energyStart,
    required this.energyEnd,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.danger,
    required this.trackStroke,
    required this.statusLow,
    required this.statusGood,
    required this.statusHigh,
  });

  /// App background. Near-black with a faint violet undertone.
  final Color bgBase;

  /// Fill of elevated glass surfaces (cards, sheets, nav).
  final Color glassFill;

  /// 1px border of glass surfaces.
  final Color glassBorder;

  /// Top-edge highlight that sells the "catching light" look.
  final Color glassHighlight;

  /// Headlines, hero numbers, primary body text.
  final Color textPrimary;

  /// Captions, labels, placeholder text.
  final Color textSecondary;

  /// Calorie ring / primary buttons gradient start.
  final Color energyStart;

  /// Calorie ring / primary buttons gradient end.
  final Color energyEnd;

  /// Protein ring/label.
  final Color protein;

  /// Carb ring/label.
  final Color carbs;

  /// Fat ring/label.
  final Color fat;

  /// Destructive actions.
  final Color danger;

  /// Inactive ring track (white at low opacity).
  final Color trackStroke;

  /// Nutrient intake status: below target.
  final Color statusLow;

  /// Nutrient intake status: on target.
  final Color statusGood;

  /// Nutrient intake status: over target.
  final Color statusHigh;

  /// The canonical token set (dark-only app).
  static const AppColors base = AppColors(
    bgBase: Color(0xFF0B0A10),
    glassFill: Color(0x0FFFFFFF),
    glassBorder: Color(0x1AFFFFFF),
    glassHighlight: Color(0x1FFFFFFF),
    textPrimary: Color(0xFFF4F2F7),
    textSecondary: Color(0xFF96909F),
    energyStart: Color(0xFFFF8F5E),
    energyEnd: Color(0xFFFFD36E),
    protein: Color(0xFFFF6F91),
    carbs: Color(0xFFFFC24D),
    fat: Color(0xFF8C9EFF),
    danger: Color(0xFFFF5C5C),
    trackStroke: Color(0x14FFFFFF),
    statusLow: Color(0xFFFFD36E),
    statusGood: Color(0xFF4CDE97),
    statusHigh: Color(0xFFFF5C5C),
  );

  /// Gradient for anything meant to feel "charged": hero ring, primary
  /// buttons, active nav glow.
  LinearGradient get energyGradient =>
      LinearGradient(colors: [energyStart, energyEnd]);

  /// Glass surface decoration shared by cards, sheets and the nav pill.
  BoxDecoration glassDecoration({
    double radius = 28,
    Color? borderColor,
  }) {
    return BoxDecoration(
      color: glassFill,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: borderColor ?? glassBorder),
    );
  }

  /// A glow shadow in the energy palette (soft light behind surfaces).
  List<BoxShadow> energyGlow({double blur = 24, double opacity = 0.35}) => [
    BoxShadow(
      color: energyStart.withValues(alpha: opacity),
      blurRadius: blur,
      spreadRadius: 2,
    ),
  ];

  @override
  AppColors copyWith({
    Color? bgBase,
    Color? glassFill,
    Color? glassBorder,
    Color? glassHighlight,
    Color? textPrimary,
    Color? textSecondary,
    Color? energyStart,
    Color? energyEnd,
    Color? protein,
    Color? carbs,
    Color? fat,
    Color? danger,
    Color? trackStroke,
    Color? statusLow,
    Color? statusGood,
    Color? statusHigh,
  }) {
    return AppColors(
      bgBase: bgBase ?? this.bgBase,
      glassFill: glassFill ?? this.glassFill,
      glassBorder: glassBorder ?? this.glassBorder,
      glassHighlight: glassHighlight ?? this.glassHighlight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      energyStart: energyStart ?? this.energyStart,
      energyEnd: energyEnd ?? this.energyEnd,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      danger: danger ?? this.danger,
      trackStroke: trackStroke ?? this.trackStroke,
      statusLow: statusLow ?? this.statusLow,
      statusGood: statusGood ?? this.statusGood,
      statusHigh: statusHigh ?? this.statusHigh,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color lc(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      bgBase: lc(bgBase, other.bgBase),
      glassFill: lc(glassFill, other.glassFill),
      glassBorder: lc(glassBorder, other.glassBorder),
      glassHighlight: lc(glassHighlight, other.glassHighlight),
      textPrimary: lc(textPrimary, other.textPrimary),
      textSecondary: lc(textSecondary, other.textSecondary),
      energyStart: lc(energyStart, other.energyStart),
      energyEnd: lc(energyEnd, other.energyEnd),
      protein: lc(protein, other.protein),
      carbs: lc(carbs, other.carbs),
      fat: lc(fat, other.fat),
      danger: lc(danger, other.danger),
      trackStroke: lc(trackStroke, other.trackStroke),
      statusLow: lc(statusLow, other.statusLow),
      statusGood: lc(statusGood, other.statusGood),
      statusHigh: lc(statusHigh, other.statusHigh),
    );
  }
}

/// Convenience accessor: `context.appColors`.
extension AppColorsX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
