import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/services/calorie_calculator.dart';

void main() {
  group('basalMetabolicRate (Mifflin-St Jeor)', () {
    test('male: 10w + 6.25h - 5a + 5', () {
      // 80kg, 180cm, 30y male → 800 + 1125 - 150 + 5 = 1780
      expect(
        basalMetabolicRate(
          sex: 'male',
          weightKg: 80,
          heightCm: 180,
          ageYears: 30,
        ),
        closeTo(1780, 0.001),
      );
    });

    test('female: 10w + 6.25h - 5a - 161', () {
      // 60kg, 165cm, 25y female → 600 + 1031.25 - 125 - 161 = 1345.25
      expect(
        basalMetabolicRate(
          sex: 'female',
          weightKg: 60,
          heightCm: 165,
          ageYears: 25,
        ),
        closeTo(1345.25, 0.001),
      );
    });

    test('returns 0 when metrics are missing', () {
      expect(
        basalMetabolicRate(
          sex: 'male',
          weightKg: 0,
          heightCm: 180,
          ageYears: 30,
        ),
        0,
      );
      expect(
        basalMetabolicRate(
          sex: 'male',
          weightKg: 80,
          heightCm: 0,
          ageYears: 30,
        ),
        0,
      );
    });
  });

  group('activityMultiplier', () {
    test('maps the stored activity levels', () {
      expect(activityMultiplier('sedentary'), 1.2);
      expect(activityMultiplier('slightly_active'), 1.375);
      expect(activityMultiplier('active'), 1.55);
      expect(activityMultiplier('very_active'), 1.725);
      expect(activityMultiplier('unknown'), 1.2); // fallback
    });
  });

  group('totalDailyEnergyExpenditure', () {
    test('multiplies BMR by the activity factor', () {
      // Male 80/180/30, active: 1780 * 1.55 = 2759
      expect(
        totalDailyEnergyExpenditure(
          sex: 'male',
          weightKg: 80,
          heightCm: 180,
          ageYears: 30,
          activityLevel: 'active',
        ),
        closeTo(2759, 0.001),
      );
    });
  });

  group('suggestedCalorieGoal', () {
    test('rounds to the nearest 50', () {
      expect(suggestedCalorieGoal(tdee: 2759), 2750);
      expect(suggestedCalorieGoal(tdee: 1780), 1800);
    });

    test('returns 0 for an invalid TDEE', () {
      expect(suggestedCalorieGoal(tdee: 0), 0);
    });
  });

  group('suggestedMacros', () {
    test('30/40/30 split', () {
      // 2000 kcal → protein 150g, carbs 200g, fat ~67g
      final macros = suggestedMacros(2000);
      expect(macros.protein, 150);
      expect(macros.carbs, 200);
      expect(macros.fat, closeTo(67, 1));
    });

    test('returns zeros for an invalid goal', () {
      final macros = suggestedMacros(0);
      expect(macros.protein, 0);
      expect(macros.carbs, 0);
      expect(macros.fat, 0);
    });
  });
}
