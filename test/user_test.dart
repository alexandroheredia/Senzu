import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/models/user.dart';

void main() {
  group('AppUser.fromMap', () {
    test('parses a full user map', () {
      final user = AppUser.fromMap(<String, dynamic>{
        'username': 'alex',
        'sex': 'male',
        'activityLevel': 'active',
        'dailyCaloriesGoal': 2400,
      }, uid: 'u1');
      expect(user.uid, 'u1');
      expect(user.username, 'alex');
      expect(user.sex, 'male');
      expect(user.activityLevel, 'active');
      expect(user.dailyCaloriesGoal, 2400);
    });

    test('defaults missing or wrongly-typed fields safely', () {
      final user = AppUser.fromMap(<String, dynamic>{
        'dailyCaloriesGoal': 'not-a-number',
      });
      expect(user.username, '');
      expect(user.sex, '');
      expect(user.activityLevel, '');
      expect(user.dailyCaloriesGoal, 0);
    });

    test('toMap round-trips', () {
      const user = AppUser(
        uid: 'u1',
        username: 'alex',
        sex: 'female',
        activityLevel: 'sedentary',
        dailyCaloriesGoal: 1800,
      );
      final map = user.toMap();
      final restored = AppUser.fromMap(map, uid: 'u1');
      expect(restored.username, 'alex');
      expect(restored.sex, 'female');
      expect(restored.activityLevel, 'sedentary');
      expect(restored.dailyCaloriesGoal, 1800);
    });

    test('parses personalization fields (metrics, macros, onboarding)', () {
      final user = AppUser.fromMap(<String, dynamic>{
        'heightCm': 175.5,
        'weightKg': 70.0,
        'ageYears': 32,
        'onboardingComplete': true,
        'proteinGoalG': 150,
        'carbGoalG': 200,
        'fatGoalG': 67,
      });
      expect(user.heightCm, 175.5);
      expect(user.weightKg, 70.0);
      expect(user.ageYears, 32);
      expect(user.onboardingComplete, isTrue);
      expect(user.proteinGoalG, 150);
      expect(user.carbGoalG, 200);
      expect(user.fatGoalG, 67);
    });

    test('defaults personalization fields safely', () {
      final user = AppUser.fromMap(const <String, dynamic>{});
      expect(user.heightCm, 0);
      expect(user.weightKg, 0);
      expect(user.ageYears, 0);
      expect(user.onboardingComplete, isFalse);
      expect(user.proteinGoalG, 0);
      expect(user.carbGoalG, 0);
      expect(user.fatGoalG, 0);
    });

    test('copyWith updates personalization fields', () {
      const user = AppUser();
      final updated = user.copyWith(
        heightCm: 180,
        weightKg: 80,
        ageYears: 30,
        onboardingComplete: true,
        proteinGoalG: 160,
        carbGoalG: 210,
        fatGoalG: 70,
      );
      expect(updated.heightCm, 180);
      expect(updated.weightKg, 80);
      expect(updated.ageYears, 30);
      expect(updated.onboardingComplete, isTrue);
      expect(updated.proteinGoalG, 160);
      expect(updated.carbGoalG, 210);
      expect(updated.fatGoalG, 70);
    });
  });
}
