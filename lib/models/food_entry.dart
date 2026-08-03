import 'package:cloud_firestore/cloud_firestore.dart';

/// The meal a food entry belongs to.
enum MealType { breakfast, lunch, snacks, dinner }

/// Per-meal presentation details.
extension MealTypePresentation on MealType {
  /// 'Breakfast' / 'Lunch' / 'Snacks' / 'Dinner'
  String get label => name[0].toUpperCase() + name.substring(1);

  /// 'Log Your Breakfast' / 'Log Your Lunch' / ...
  String get title => 'Log Your $label';

  /// Asset key of the meal icon.
  String get assetPath => 'assets/meal_icons/${name}_medium.png';
}

MealType? mealTypeFromString(Object? value) {
  switch (value) {
    case 'breakfast':
      return MealType.breakfast;
    case 'lunch':
      return MealType.lunch;
    case 'snacks':
      return MealType.snacks;
    case 'dinner':
      return MealType.dinner;
    default:
      return null;
  }
}

String? mealTypeToString(MealType? meal) {
  switch (meal) {
    case MealType.breakfast:
      return 'breakfast';
    case MealType.lunch:
      return 'lunch';
    case MealType.snacks:
      return 'snacks';
    case MealType.dinner:
      return 'dinner';
    case null:
      return null;
  }
}

/// Typed representation of a single document in `users/{uid}/foodEntries`.
class FoodEntry {
  final String id;

  /// The shelf/catalog food this entry was logged from (empty for legacy
  /// entries that predate the field).
  final String foodId;

  final DateTime dateAdded;
  final MealType? mealType;
  final String foodName;
  final String brandName;
  final double portionSize;
  final double servingSize;
  final int calories;
  final int breakfastCalories;
  final int lunchCalories;
  final int snacksCalories;
  final int dinnerCalories;
  final int totalCarbohydrate;
  final int totalFat;
  final int protein;
  final int dietaryFiber;
  final int potassium;
  final int vitaminA;
  final int vitaminC;
  final int vitaminD;
  final int calcium;
  final int iron;
  final int saturatedFat;
  final int sodium;
  final int magnesium;
  final int zinc;

  const FoodEntry({
    required this.id,
    required this.dateAdded,
    this.foodId = '',
    this.mealType,
    this.foodName = '',
    this.brandName = '',
    this.portionSize = 0,
    this.servingSize = 0,
    this.calories = 0,
    this.breakfastCalories = 0,
    this.lunchCalories = 0,
    this.snacksCalories = 0,
    this.dinnerCalories = 0,
    this.totalCarbohydrate = 0,
    this.totalFat = 0,
    this.protein = 0,
    this.dietaryFiber = 0,
    this.potassium = 0,
    this.vitaminA = 0,
    this.vitaminC = 0,
    this.vitaminD = 0,
    this.calcium = 0,
    this.iron = 0,
    this.saturatedFat = 0,
    this.sodium = 0,
    this.magnesium = 0,
    this.zinc = 0,
  });

  factory FoodEntry.fromMap(String id, Map<String, dynamic> map) {
    return FoodEntry(
      id: id,
      dateAdded: _date(map['dateAdded']),
      foodId: _string(map['foodId']),
      mealType: mealTypeFromString(map['mealType']),
      foodName: _string(map['foodName']),
      brandName: _string(map['brandName']),
      portionSize: _double(map['portionSize']),
      servingSize: _double(map['servingSize']),
      calories: _int(map['calories']),
      breakfastCalories: _int(map['breakfastCalories']),
      lunchCalories: _int(map['lunchCalories']),
      snacksCalories: _int(map['snacksCalories']),
      dinnerCalories: _int(map['dinnerCalories']),
      totalCarbohydrate: _int(map['totalCarbohydrate']),
      totalFat: _int(map['totalFat']),
      protein: _int(map['protein']),
      dietaryFiber: _int(map['dietaryFiber']),
      potassium: _int(map['potassium']),
      vitaminA: _int(map['vitaminA']),
      vitaminC: _int(map['vitaminC']),
      vitaminD: _int(map['vitaminD']),
      calcium: _int(map['calcium']),
      iron: _int(map['iron']),
      saturatedFat: _int(map['saturatedFat']),
      sodium: _int(map['sodium']),
      magnesium: _int(map['magnesium']),
      zinc: _int(map['zinc']),
    );
  }
}

/// Aggregated nutrient totals for a set of [FoodEntry]s (e.g. one day).
class FoodLogSummary {
  final int totalCalories;
  final int breakfastCalories;
  final int lunchCalories;
  final int snacksCalories;
  final int dinnerCalories;
  final int totalCarbohydrate;
  final int totalFat;
  final int protein;
  final int dietaryFiber;
  final int potassium;
  final int vitaminA;
  final int vitaminC;
  final int vitaminD;
  final int calcium;
  final int iron;
  final int saturatedFat;
  final int sodium;
  final int magnesium;
  final int zinc;

  const FoodLogSummary({
    this.totalCalories = 0,
    this.breakfastCalories = 0,
    this.lunchCalories = 0,
    this.snacksCalories = 0,
    this.dinnerCalories = 0,
    this.totalCarbohydrate = 0,
    this.totalFat = 0,
    this.protein = 0,
    this.dietaryFiber = 0,
    this.potassium = 0,
    this.vitaminA = 0,
    this.vitaminC = 0,
    this.vitaminD = 0,
    this.calcium = 0,
    this.iron = 0,
    this.saturatedFat = 0,
    this.sodium = 0,
    this.magnesium = 0,
    this.zinc = 0,
  });

  factory FoodLogSummary.fromEntries(Iterable<FoodEntry> entries) {
    var summary = const FoodLogSummary();
    for (final e in entries) {
      summary = FoodLogSummary(
        totalCalories: summary.totalCalories + e.calories,
        breakfastCalories: summary.breakfastCalories + e.breakfastCalories,
        lunchCalories: summary.lunchCalories + e.lunchCalories,
        snacksCalories: summary.snacksCalories + e.snacksCalories,
        dinnerCalories: summary.dinnerCalories + e.dinnerCalories,
        totalCarbohydrate: summary.totalCarbohydrate + e.totalCarbohydrate,
        totalFat: summary.totalFat + e.totalFat,
        protein: summary.protein + e.protein,
        dietaryFiber: summary.dietaryFiber + e.dietaryFiber,
        potassium: summary.potassium + e.potassium,
        vitaminA: summary.vitaminA + e.vitaminA,
        vitaminC: summary.vitaminC + e.vitaminC,
        vitaminD: summary.vitaminD + e.vitaminD,
        calcium: summary.calcium + e.calcium,
        iron: summary.iron + e.iron,
        saturatedFat: summary.saturatedFat + e.saturatedFat,
        sodium: summary.sodium + e.sodium,
        magnesium: summary.magnesium + e.magnesium,
        zinc: summary.zinc + e.zinc,
      );
    }
    return summary;
  }
}

String _string(Object? value) => value is String ? value : '';

double _double(Object? value) {
  if (value is num) return value.toDouble();
  return 0;
}

int _int(Object? value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return 0;
}

DateTime _date(Object? value) {
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  return DateTime.now();
}
