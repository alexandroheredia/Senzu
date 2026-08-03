import 'package:senzu_app/models/food_entry.dart';

/// Typed representation of a document in `users/{uid}/foodShelf`.
class ShelfFood {
  final String id;
  final String foodId;
  final String barcode;
  final String foodName;
  final String brandName;
  final double servingSize;
  final double calories;
  final double totalFat;
  final double saturatedFat;
  final double transFat;
  final double cholesterol;
  final double sodium;
  final double totalCarbohydrate;
  final double dietaryFiber;
  final double sugars;
  final double addedSugars;
  final double protein;
  final double vitaminD;
  final double calcium;
  final double iron;
  final double potassium;
  final double vitaminA;
  final double vitaminC;
  final double vitaminB6;
  final double folate;
  final double thiamin;
  final double magnesium;
  final double zinc;
  final double phosphorus;
  final double riboflavin;
  final double niacin;
  final double pantothenicAcid;
  final double vitaminE;
  final int timesAdded;

  const ShelfFood({
    required this.id,
    this.foodId = '',
    this.barcode = '',
    this.foodName = '',
    this.brandName = '',
    this.servingSize = 0,
    this.calories = 0,
    this.totalFat = 0,
    this.saturatedFat = 0,
    this.transFat = 0,
    this.cholesterol = 0,
    this.sodium = 0,
    this.totalCarbohydrate = 0,
    this.dietaryFiber = 0,
    this.sugars = 0,
    this.addedSugars = 0,
    this.protein = 0,
    this.vitaminD = 0,
    this.calcium = 0,
    this.iron = 0,
    this.potassium = 0,
    this.vitaminA = 0,
    this.vitaminC = 0,
    this.vitaminB6 = 0,
    this.folate = 0,
    this.thiamin = 0,
    this.magnesium = 0,
    this.zinc = 0,
    this.phosphorus = 0,
    this.riboflavin = 0,
    this.niacin = 0,
    this.pantothenicAcid = 0,
    this.vitaminE = 0,
    this.timesAdded = 0,
  });

  factory ShelfFood.fromMap(String id, Map<String, dynamic> map) {
    return ShelfFood(
      id: id,
      foodId: _string(map['foodId']),
      barcode: _string(map['barcode']),
      foodName: _string(map['foodName']),
      brandName: _string(map['brandName']),
      servingSize: _double(map['servingSize']),
      calories: _double(map['calories']),
      totalFat: _double(map['totalFat']),
      saturatedFat: _double(map['saturatedFat']),
      transFat: _double(map['transFat']),
      cholesterol: _double(map['cholesterol']),
      sodium: _double(map['sodium']),
      totalCarbohydrate: _double(map['totalCarbohydrate']),
      dietaryFiber: _double(map['dietaryFiber']),
      sugars: _double(map['sugars']),
      addedSugars: _double(map['addedSugars']),
      protein: _double(map['protein']),
      vitaminD: _double(map['vitaminD']),
      calcium: _double(map['calcium']),
      iron: _double(map['iron']),
      potassium: _double(map['potassium']),
      vitaminA: _double(map['vitaminA']),
      vitaminC: _double(map['vitaminC']),
      vitaminB6: _double(map['vitaminB6']),
      folate: _double(map['folate']),
      thiamin: _double(map['thiamin']),
      magnesium: _double(map['magnesium']),
      zinc: _double(map['zinc']),
      phosphorus: _double(map['phosphorus']),
      riboflavin: _double(map['riboflavin']),
      niacin: _double(map['niacin']),
      pantothenicAcid: _double(map['pantothenicAcid']),
      vitaminE: _double(map['vitaminE']),
      timesAdded: _int(map['timesAdded']),
    );
  }

  /// Builds a display shelf-food from a logged [FoodEntry], reverse-scaling
  /// the entry's intake values back to per-serving amounts.
  ///
  /// Used by the entry-edit screen so the macros/facts panels can render the
  /// entry's data with the same widgets as a shelf food. Only the nutrients
  /// the entry carries are populated; the rest default to zero.
  factory ShelfFood.fromFoodEntry(FoodEntry entry) {
    final ratio = entry.portionSize == 0
        ? 0
        : entry.servingSize / entry.portionSize;
    double perServing(double value) => value * ratio;
    return ShelfFood(
      id: entry.foodId.isEmpty ? entry.id : entry.foodId,
      foodId: entry.foodId,
      foodName: entry.foodName,
      brandName: entry.brandName,
      servingSize: entry.servingSize,
      calories: perServing(entry.calories.toDouble()),
      totalFat: perServing(entry.totalFat.toDouble()),
      saturatedFat: perServing(entry.saturatedFat.toDouble()),
      sodium: perServing(entry.sodium.toDouble()),
      totalCarbohydrate: perServing(entry.totalCarbohydrate.toDouble()),
      dietaryFiber: perServing(entry.dietaryFiber.toDouble()),
      protein: perServing(entry.protein.toDouble()),
      vitaminD: perServing(entry.vitaminD.toDouble()),
      calcium: perServing(entry.calcium.toDouble()),
      iron: perServing(entry.iron.toDouble()),
      potassium: perServing(entry.potassium.toDouble()),
      vitaminA: perServing(entry.vitaminA.toDouble()),
      vitaminC: perServing(entry.vitaminC.toDouble()),
      magnesium: perServing(entry.magnesium.toDouble()),
      zinc: perServing(entry.zinc.toDouble()),
    );
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
