/// Calorie & macro estimation helpers.
///
/// All inputs are metric (kg, cm, years). Used by the onboarding wizard and
/// the goals screen to suggest a daily calorie goal from the user's body
/// metrics, and to derive macro targets from that goal.
library;

/// Activity-level multipliers used by the Mifflin-St Jeor TDEE estimate.
/// Values mirror the `activityLevel` enum stored on the user document.
double activityMultiplier(String level) {
  switch (level) {
    case 'sedentary':
      return 1.2;
    case 'slightly_active':
      return 1.375;
    case 'active':
      return 1.55;
    case 'very_active':
      return 1.725;
    default:
      return 1.2;
  }
}

/// Basal metabolic rate via the Mifflin-St Jeor equation.
///
/// Returns 0 when any metric is missing (guards against divide-by-zero and
/// garbage inputs on partial profiles).
double basalMetabolicRate({
  required String sex,
  required double weightKg,
  required double heightCm,
  required int ageYears,
}) {
  if (weightKg <= 0 || heightCm <= 0 || ageYears <= 0) return 0;
  final base = 10 * weightKg + 6.25 * heightCm - 5 * ageYears;
  return sex == 'female' ? base - 161 : base + 5;
}

/// Total daily energy expenditure: BMR × activity multiplier.
double totalDailyEnergyExpenditure({
  required String sex,
  required double weightKg,
  required double heightCm,
  required int ageYears,
  required String activityLevel,
}) {
  final bmr = basalMetabolicRate(
    sex: sex,
    weightKg: weightKg,
    heightCm: heightCm,
    ageYears: ageYears,
  );
  if (bmr <= 0) return 0;
  return bmr * activityMultiplier(activityLevel);
}

/// Rounds a TDEE to a sensible calorie goal (nearest 50 kcal).
int suggestedCalorieGoal({required double tdee}) {
  if (tdee <= 0) return 0;
  return (tdee / 50).round() * 50;
}

/// Suggested macro split for a calorie goal, using a standard 30/40/30
/// protein / carbs / fat split (4 / 4 / 9 kcal per gram).
({int protein, int carbs, int fat}) suggestedMacros(int calories) {
  if (calories <= 0) return (protein: 0, carbs: 0, fat: 0);
  return (
    protein: (calories * 0.30 / 4).round(),
    carbs: (calories * 0.40 / 4).round(),
    fat: (calories * 0.30 / 9).round(),
  );
}
