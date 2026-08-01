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
  });
}
