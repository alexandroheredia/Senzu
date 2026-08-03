import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/services/entry_builder.dart';

void main() {
  group('ShelfFood.fromFoodEntry', () {
    FoodEntry entry({double portion = 150, int calories = 300}) {
      return FoodEntry(
        id: 'entry-1',
        foodId: 'food-1',
        dateAdded: DateTime(2026, 8),
        mealType: MealType.lunch,
        foodName: 'Greek Yogurt',
        brandName: 'Fage',
        portionSize: portion,
        servingSize: 100,
        calories: calories,
        protein: 15,
        totalFat: 5,
        totalCarbohydrate: 10,
        sodium: 40,
      );
    }

    test('reverse-scales intake values back to per-serving amounts', () {
      // 150g portion, 100g serving: intake values are 1.5x the per-serving.
      final food = ShelfFood.fromFoodEntry(entry());
      expect(food.foodId, 'food-1');
      expect(food.foodName, 'Greek Yogurt');
      expect(food.brandName, 'Fage');
      expect(food.servingSize, 100);
      expect(food.calories, closeTo(200, 0.001)); // 300 / 1.5
      expect(food.protein, closeTo(10, 0.001)); // 15 / 1.5
      expect(food.totalFat, closeTo(5 / 1.5, 0.001));
      expect(food.totalCarbohydrate, closeTo(10 / 1.5, 0.001));
    });

    test('round-trips through buildFoodEntry at the same portion', () {
      final food = ShelfFood.fromFoodEntry(entry());
      final rebuilt = buildFoodEntry(
        food: food,
        date: DateTime(2026, 8),
        meal: MealType.lunch,
        portion: 150,
      );
      expect(rebuilt['calories'], 300);
      expect(rebuilt['protein'], 15);
      expect(rebuilt['totalFat'], 5);
      expect(rebuilt['totalCarbohydrate'], 10);
      expect(rebuilt['sodium'], 40);
      expect(rebuilt['foodName'], 'Greek Yogurt');
    });

    test('handles a zero portion without crashing', () {
      final food = ShelfFood.fromFoodEntry(entry(portion: 0));
      expect(food.calories, 0);
      expect(food.protein, 0);
    });
  });
}
