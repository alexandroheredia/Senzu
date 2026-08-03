/// Ingredient-based recipes with per-serving nutrition math.
///
/// An ingredient references a shelf food by id and records the amount used
/// (grams) plus that food's nutrition **per 100g** — the canonical density
/// that makes per-serving math exact regardless of the food's own serving
/// size. Recipe totals are the sum of ingredient totals; per-serving values
/// divide by the number of servings.
library;

/// One ingredient of a [Recipe].
class RecipeIngredient {
  final String foodId;

  /// Display name captured at add-time (so the recipe stays readable even
  /// if the shelf food is later deleted).
  final String name;

  /// Amount used in the recipe, grams.
  final double grams;

  // --- Nutrition per 100 g of this ingredient -----------------------------
  final double calories;
  final double protein;
  final double totalFat;
  final double totalCarbohydrate;

  const RecipeIngredient({
    required this.foodId,
    required this.name,
    required this.grams,
    this.calories = 0,
    this.protein = 0,
    this.totalFat = 0,
    this.totalCarbohydrate = 0,
  });

  /// Totals contributed by this ingredient at [grams].
  double get contributionCalories => calories * grams / 100;
  double get contributionProtein => protein * grams / 100;
  double get contributionFat => totalFat * grams / 100;
  double get contributionCarbs => totalCarbohydrate * grams / 100;

  factory RecipeIngredient.fromMap(Map<String, dynamic> map) {
    return RecipeIngredient(
      foodId: _string(map['foodId']),
      name: _string(map['name']),
      grams: _double(map['grams']),
      calories: _double(map['calories']),
      protein: _double(map['protein']),
      totalFat: _double(map['totalFat']),
      totalCarbohydrate: _double(map['totalCarbohydrate']),
    );
  }

  Map<String, dynamic> toMap() => {
    'foodId': foodId,
    'name': name,
    'grams': grams,
    'calories': calories,
    'protein': protein,
    'totalFat': totalFat,
    'totalCarbohydrate': totalCarbohydrate,
  };
}

/// A reusable recipe: name, number of servings, and ingredients.
class Recipe {
  final String id;

  /// The shelf food id used as the recipe's own id (so logging a serving
  /// writes a consistent `foodId`).
  final String name;
  final int servings;
  final List<RecipeIngredient> ingredients;

  const Recipe({
    required this.id,
    required this.name,
    this.servings = 1,
    this.ingredients = const [],
  });

  int get totalCalories =>
      ingredients.fold(0, (sum, i) => sum + i.contributionCalories.round());
  int get totalProtein =>
      ingredients.fold(0, (sum, i) => sum + i.contributionProtein.round());
  int get totalFat =>
      ingredients.fold(0, (sum, i) => sum + i.contributionFat.round());
  int get totalCarbs =>
      ingredients.fold(0, (sum, i) => sum + i.contributionCarbs.round());

  int get caloriesPerServing => servings <= 0 ? 0 : totalCalories ~/ servings;
  int get proteinPerServing => servings <= 0 ? 0 : totalProtein ~/ servings;
  int get fatPerServing => servings <= 0 ? 0 : totalFat ~/ servings;
  int get carbsPerServing => servings <= 0 ? 0 : totalCarbs ~/ servings;

  factory Recipe.fromMap(String id, Map<String, dynamic> map) {
    final raw = map['ingredients'];
    final ingredients = <RecipeIngredient>[];
    if (raw is List) {
      for (final item in raw) {
        if (item is Map<String, dynamic>) {
          ingredients.add(RecipeIngredient.fromMap(item));
        }
      }
    }
    return Recipe(
      id: id,
      name: _string(map['name']),
      servings: _int(map['servings'], fallback: 1),
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'servings': servings,
    'ingredients': ingredients.map((i) => i.toMap()).toList(),
  };
}

String _string(Object? value) => value is String ? value : '';

double _double(Object? value) {
  if (value is num) return value.toDouble();
  return 0;
}

int _int(Object? value, {required int fallback}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return fallback;
}
