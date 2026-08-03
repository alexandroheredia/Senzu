import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/recipe.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';

/// Builds the Firestore map for a [FoodEntry] from a shelf [food], scaled to
/// [portion] grams of the food's serving size.
///
/// Shared by the quick-add path and the food details screen so both write
/// identical documents (including the per-meal calorie fields the dashboard
/// summary relies on).
Map<String, dynamic> buildFoodEntry({
  required ShelfFood food,
  required DateTime date,
  required MealType? meal,
  required int portion,
}) {
  final ratio = food.servingSize == 0 ? 0 : portion / food.servingSize;
  int scaled(double value) => (value * ratio).round();

  final calories = scaled(food.calories);
  final normalizedDate = startOfDay(date);

  return <String, dynamic>{
    'foodId': food.foodId,
    'foodName': food.foodName,
    'brandName': food.brandName,
    'portionSize': portion,
    'servingSize': food.servingSize,
    'mealType': mealTypeToString(meal),
    'calories': calories,
    'totalFat': scaled(food.totalFat),
    'saturatedFat': scaled(food.saturatedFat),
    'transFat': scaled(food.transFat),
    'cholesterol': scaled(food.cholesterol),
    'sodium': scaled(food.sodium),
    'totalCarbohydrate': scaled(food.totalCarbohydrate),
    'dietaryFiber': scaled(food.dietaryFiber),
    'sugars': scaled(food.sugars),
    'protein': scaled(food.protein),
    'calcium': scaled(food.calcium),
    'iron': scaled(food.iron),
    'potassium': scaled(food.potassium),
    'vitaminA': scaled(food.vitaminA),
    'vitaminC': scaled(food.vitaminC),
    'vitaminD': scaled(food.vitaminD),
    'magnesium': scaled(food.magnesium),
    'zinc': scaled(food.zinc),
    'weekNo': getWeekNumber(normalizedDate),
    'month': cleanMonthFormat(normalizedDate.toString()),
    'year': cleanYearFormat(normalizedDate.toString()),
    'dateAdded': normalizedDate,
    'breakfastCalories': meal == MealType.breakfast ? calories : 0,
    'lunchCalories': meal == MealType.lunch ? calories : 0,
    'snacksCalories': meal == MealType.snacks ? calories : 0,
    'dinnerCalories': meal == MealType.dinner ? calories : 0,
  };
}

/// Builds the Firestore map for a [FoodEntry] from logging [servings]
/// servings of a [recipe].
///
/// Recipes carry macro-level nutrition only (no micronutrients), so the
/// entry includes calories + macros and leaves the rest at their defaults.
/// The recipe's own id is used as the entry's `foodId` and the brand is
/// "Recipe" so logged recipe servings read clearly in the day's log.
Map<String, dynamic> buildRecipeEntry({
  required Recipe recipe,
  required DateTime date,
  required MealType? meal,
  required int servings,
}) {
  final normalizedDate = startOfDay(date);
  final calories = recipe.caloriesPerServing * servings;
  return <String, dynamic>{
    'foodId': recipe.id,
    'foodName': recipe.name,
    'brandName': 'Recipe',
    'portionSize': servings,
    'servingSize': 1,
    'mealType': mealTypeToString(meal),
    'calories': calories,
    'protein': recipe.proteinPerServing * servings,
    'totalFat': recipe.fatPerServing * servings,
    'totalCarbohydrate': recipe.carbsPerServing * servings,
    'weekNo': getWeekNumber(normalizedDate),
    'month': cleanMonthFormat(normalizedDate.toString()),
    'year': cleanYearFormat(normalizedDate.toString()),
    'dateAdded': normalizedDate,
    'breakfastCalories': meal == MealType.breakfast ? calories : 0,
    'lunchCalories': meal == MealType.lunch ? calories : 0,
    'snacksCalories': meal == MealType.snacks ? calories : 0,
    'dinnerCalories': meal == MealType.dinner ? calories : 0,
  };
}

/// Builds the Firestore map for a meal-item document (a food inside a custom
/// meal), scaled to [portion] grams.
///
/// Shared by the quick-add path and the food details screen so both write
/// identical meal-item documents.
Map<String, dynamic> buildMealItem({
  required ShelfFood food,
  required String mealId,
  required int portion,
}) {
  final ratio = food.servingSize == 0 ? 0 : portion / food.servingSize;
  int scaled(double value) => (value * ratio).round();

  return <String, dynamic>{
    'foodId': food.foodId,
    'foodName': food.foodName,
    'brandName': food.brandName,
    'mealId': mealId,
    'portionSize': portion,
    'servingSize': food.servingSize,
    'calories': scaled(food.calories),
    'totalFat': scaled(food.totalFat),
    'saturatedFat': scaled(food.saturatedFat),
    'transFat': scaled(food.transFat),
    'cholesterol': scaled(food.cholesterol),
    'sodium': scaled(food.sodium),
    'totalCarbohydrate': scaled(food.totalCarbohydrate),
    'dietaryFiber': scaled(food.dietaryFiber),
    'sugars': scaled(food.sugars),
    'protein': scaled(food.protein),
    'calcium': scaled(food.calcium),
    'iron': scaled(food.iron),
    'potassium': scaled(food.potassium),
    'vitaminA': scaled(food.vitaminA),
    'vitaminC': scaled(food.vitaminC),
  };
}
