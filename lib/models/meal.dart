/// Typed representation of a document in `users/{uid}/meals`.
class Meal {
  final String id;
  final String mealName;
  final String mealId;

  const Meal({required this.id, this.mealName = '', this.mealId = ''});

  factory Meal.fromMap(String id, Map<String, dynamic> map) {
    return Meal(
      id: id,
      mealName: map['mealName'] is String ? map['mealName'] as String : '',
      mealId: map['mealId'] is String ? map['mealId'] as String : '',
    );
  }
}

/// Typed representation of a document in `users/{uid}/meals/{mealId}/foodItems`.
class MealFoodItem {
  final String id;
  final String foodName;
  final double calories;
  final double portionSize;

  const MealFoodItem({
    required this.id,
    this.foodName = '',
    this.calories = 0,
    this.portionSize = 0,
  });

  factory MealFoodItem.fromMap(String id, Map<String, dynamic> map) {
    return MealFoodItem(
      id: id,
      foodName: map['foodName'] is String ? map['foodName'] as String : '',
      calories: _double(map['calories']),
      portionSize: _double(map['portionSize']),
    );
  }
}

double _double(Object? value) {
  if (value is num) return value.toDouble();
  return 0;
}
