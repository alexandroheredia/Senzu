import 'package:senzu_app/models/shelf_food.dart';

/// A food that is being created or edited, before it is persisted.
///
/// This is the canonical, single source of truth for the food document
/// schema used by every input path:
///
///  1. the manual `AddFood` form,
///  2. barcode lookup (Open Food Facts + the global `foods` catalog),
///  3. AI image extraction of a nutrition facts panel.
///
/// Serialization goes through [toFoodMap] (global catalog) and [toShelfMap]
/// (user shelf), so all three paths write the exact same shape to Firestore.
class FoodDraft {
  const FoodDraft({
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

  final String foodId;

  /// UPC/EAN barcode, empty when unknown. Persisted in the global catalog so
  /// later scans match this food.
  final String barcode;

  final String foodName;
  final String brandName;

  /// Serving size in the food's own unit (grams, millilitres, …).
  final double servingSize;

  // --- Nutrients (amounts per one serving) --------------------------------
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

  /// Number of times the food has been added to the log (shelf only).
  final int timesAdded;

  /// True when there is nothing meaningful to save yet.
  bool get isEmpty => foodName.trim().isEmpty && calories == 0;

  /// The food document shared by the global `foods` catalog and the user's
  /// shelf. Mirrors the shape `AddFood` used to build inline.
  Map<String, dynamic> toFoodMap() {
    return {
      'foodId': foodId,
      'foodName': foodName,
      'brandName': brandName,
      'servingSize': servingSize,
      if (barcode.isNotEmpty) 'barcode': barcode,
      'calories': calories,
      'totalFat': totalFat,
      'saturatedFat': saturatedFat,
      'transFat': transFat,
      'cholesterol': cholesterol,
      'sodium': sodium,
      'totalCarbohydrate': totalCarbohydrate,
      'dietaryFiber': dietaryFiber,
      'sugars': sugars,
      'addedSugars': addedSugars,
      'protein': protein,
      'vitaminD': vitaminD,
      'calcium': calcium,
      'iron': iron,
      'potassium': potassium,
      'vitaminA': vitaminA,
      'vitaminC': vitaminC,
      'vitaminB6': vitaminB6,
      'folate': folate,
      'thiamin': thiamin,
      'magnesium': magnesium,
      'zinc': zinc,
      'phosphorus': phosphorus,
      'riboflavin': riboflavin,
      'niacin': niacin,
      'pantothenicAcid': pantothenicAcid,
      'vitaminE': vitaminE,
    };
  }

  /// The shelf document: catalog shape plus the usage counter.
  Map<String, dynamic> toShelfMap() {
    return {...toFoodMap(), 'timesAdded': timesAdded};
  }

  /// Builds a draft from an existing shelf/catalog document.
  factory FoodDraft.fromShelfFood(ShelfFood food) {
    return FoodDraft(
      foodId: food.foodId,
      barcode: food.barcode,
      foodName: food.foodName,
      brandName: food.brandName,
      servingSize: food.servingSize,
      calories: food.calories,
      totalFat: food.totalFat,
      saturatedFat: food.saturatedFat,
      transFat: food.transFat,
      cholesterol: food.cholesterol,
      sodium: food.sodium,
      totalCarbohydrate: food.totalCarbohydrate,
      dietaryFiber: food.dietaryFiber,
      sugars: food.sugars,
      addedSugars: food.addedSugars,
      protein: food.protein,
      vitaminD: food.vitaminD,
      calcium: food.calcium,
      iron: food.iron,
      potassium: food.potassium,
      vitaminA: food.vitaminA,
      vitaminC: food.vitaminC,
      vitaminB6: food.vitaminB6,
      folate: food.folate,
      thiamin: food.thiamin,
      magnesium: food.magnesium,
      zinc: food.zinc,
      phosphorus: food.phosphorus,
      riboflavin: food.riboflavin,
      niacin: food.niacin,
      pantothenicAcid: food.pantothenicAcid,
      vitaminE: food.vitaminE,
      timesAdded: food.timesAdded,
    );
  }

  /// A new draft with [foodId] assigned, keeping every other field.
  FoodDraft withFoodId(String id) {
    return FoodDraft(
      foodId: id,
      barcode: barcode,
      foodName: foodName,
      brandName: brandName,
      servingSize: servingSize,
      calories: calories,
      totalFat: totalFat,
      saturatedFat: saturatedFat,
      transFat: transFat,
      cholesterol: cholesterol,
      sodium: sodium,
      totalCarbohydrate: totalCarbohydrate,
      dietaryFiber: dietaryFiber,
      sugars: sugars,
      addedSugars: addedSugars,
      protein: protein,
      vitaminD: vitaminD,
      calcium: calcium,
      iron: iron,
      potassium: potassium,
      vitaminA: vitaminA,
      vitaminC: vitaminC,
      vitaminB6: vitaminB6,
      folate: folate,
      thiamin: thiamin,
      magnesium: magnesium,
      zinc: zinc,
      phosphorus: phosphorus,
      riboflavin: riboflavin,
      niacin: niacin,
      pantothenicAcid: pantothenicAcid,
      vitaminE: vitaminE,
      timesAdded: timesAdded,
    );
  }
}
