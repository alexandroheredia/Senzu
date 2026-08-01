import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/models/food_entry.dart';

void main() {
  group('FoodEntry.fromMap', () {
    test('parses typed fields from a raw map', () {
      final entry = FoodEntry.fromMap('abc', <String, dynamic>{
        'calories': 500.5,
        'protein': 30,
        'mealType': 'lunch',
        'dateAdded': DateTime(2026, 8, 1),
      });
      expect(entry.id, 'abc');
      expect(entry.calories, 500);
      expect(entry.protein, 30);
      expect(entry.totalFat, 0);
      expect(entry.mealType, MealType.lunch);
      expect(entry.dateAdded, DateTime(2026, 8, 1));
    });

    test('defaults missing fields to zero/empty values', () {
      final entry = FoodEntry.fromMap('x', const <String, dynamic>{});
      expect(entry.calories, 0);
      expect(entry.totalCarbohydrate, 0);
      expect(entry.mealType, isNull);
      expect(entry.dateAdded, isNotNull);
    });

    test('ignores non-numeric values without crashing', () {
      final entry = FoodEntry.fromMap('y', <String, dynamic>{
        'calories': 'not-a-number',
        'protein': null,
      });
      expect(entry.calories, 0);
      expect(entry.protein, 0);
    });
  });

  group('FoodLogSummary.fromEntries', () {
    test('sums nutrients across entries', () {
      final e1 = FoodEntry(
        id: '1',
        dateAdded: DateTime(2026, 8, 1),
        calories: 200,
        protein: 10,
        totalFat: 5,
        breakfastCalories: 200,
      );
      final e2 = FoodEntry(
        id: '2',
        dateAdded: DateTime(2026, 8, 1),
        calories: 300,
        protein: 20,
        totalFat: 15,
        lunchCalories: 300,
      );
      final summary = FoodLogSummary.fromEntries([e1, e2]);
      expect(summary.totalCalories, 500);
      expect(summary.protein, 30);
      expect(summary.totalFat, 20);
      expect(summary.breakfastCalories, 200);
      expect(summary.lunchCalories, 300);
    });

    test('empty list gives an all-zero summary', () {
      final summary = FoodLogSummary.fromEntries([]);
      expect(summary.totalCalories, 0);
      expect(summary.protein, 0);
      expect(summary.sodium, 0);
    });
  });
}
