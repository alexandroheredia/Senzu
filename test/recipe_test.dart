import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/recipe.dart';
import 'package:senzu_app/services/entry_builder.dart';

void main() {
  const recipe = Recipe(
    id: 'recipe-1',
    name: 'Oatmeal Bowl',
    servings: 2,
    ingredients: [
      RecipeIngredient(
        foodId: 'oats',
        name: 'Oats',
        grams: 100,
        calories: 389, // per 100g
        protein: 16.9,
        totalFat: 6.9,
        totalCarbohydrate: 66.3,
      ),
      RecipeIngredient(
        foodId: 'banana',
        name: 'Banana',
        grams: 50,
        calories: 89, // per 100g
        protein: 1.1,
        totalFat: 0.3,
        totalCarbohydrate: 22.8,
      ),
    ],
  );

  group('RecipeIngredient', () {
    test('computes contribution from per-100g values', () {
      const oats = RecipeIngredient(
        foodId: 'oats',
        name: 'Oats',
        grams: 100,
        calories: 389,
        protein: 16.9,
        totalFat: 6.9,
        totalCarbohydrate: 66.3,
      );
      expect(oats.contributionCalories, closeTo(389, 0.001));
      expect(oats.contributionProtein, closeTo(16.9, 0.001));

      const halfBanana = RecipeIngredient(
        foodId: 'banana',
        name: 'Banana',
        grams: 50,
        calories: 89,
        protein: 1.1,
        totalFat: 0.3,
        totalCarbohydrate: 22.8,
      );
      expect(halfBanana.contributionCalories, closeTo(44.5, 0.001));
    });
  });

  group('Recipe totals & per-serving', () {
    test('sums ingredient totals', () {
      // 389 + 44.5 ≈ 433.5 → 434
      expect(recipe.totalCalories, closeTo(434, 1));
      expect(recipe.totalProtein, closeTo(17, 1));
    });

    test('divides totals by servings', () {
      expect(recipe.caloriesPerServing, closeTo(217, 1));
      expect(recipe.proteinPerServing, closeTo(8, 1));
    });

    test('handles zero servings safely', () {
      final zero = Recipe(
        id: 'x',
        name: 'X',
        servings: 0,
        ingredients: recipe.ingredients,
      );
      expect(zero.caloriesPerServing, 0);
    });

    test('serializes and round-trips through toMap/fromMap', () {
      final restored = Recipe.fromMap('recipe-1', recipe.toMap());
      expect(restored.name, 'Oatmeal Bowl');
      expect(restored.servings, 2);
      expect(restored.ingredients.length, 2);
      expect(restored.caloriesPerServing, recipe.caloriesPerServing);
    });
  });

  group('buildRecipeEntry', () {
    test('writes a macro-level entry for N servings', () {
      final entry = buildRecipeEntry(
        recipe: recipe,
        date: DateTime(2026, 8, 3),
        meal: MealType.lunch,
        servings: 2,
      );
      expect(entry['foodId'], 'recipe-1');
      expect(entry['foodName'], 'Oatmeal Bowl');
      expect(entry['brandName'], 'Recipe');
      expect(entry['portionSize'], 2);
      expect(entry['servingSize'], 1);
      expect(entry['calories'], recipe.caloriesPerServing * 2);
      expect(entry['mealType'], 'lunch');
      expect(entry['lunchCalories'], entry['calories']);
      expect(entry['breakfastCalories'], 0);
    });
  });
}
