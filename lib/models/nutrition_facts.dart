import 'package:senzu_app/models/food_draft.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';

/// The unit a nutrient amount is expressed in on a nutrition facts panel.
enum NutrientUnit {
  grams('g'),
  milligrams('mg'),
  micrograms('mcg'),
  kilocalories('kcal'),
  percent('%');

  const NutrientUnit(this.symbol);

  /// Short symbol used on labels, e.g. `g`, `mg`, `%`.
  final String symbol;

  /// Parses a unit string as printed on a label ('g', 'mg', 'mcg', 'µg',
  /// 'kcal', '%', 'percent', …). Returns null when unrecognized.
  static NutrientUnit? tryParse(String raw) {
    switch (raw.trim().toLowerCase()) {
      case 'g':
      case 'gram':
      case 'grams':
        return NutrientUnit.grams;
      case 'mg':
      case 'milligram':
      case 'milligrams':
        return NutrientUnit.milligrams;
      case 'mcg':
      case 'µg':
      case 'ug':
      case 'microgram':
      case 'micrograms':
        return NutrientUnit.micrograms;
      case 'kcal':
      case 'calorie':
      case 'calories':
        return NutrientUnit.kilocalories;
      case '%':
      case 'percent':
      case 'dv':
      case 'daily value':
        return NutrientUnit.percent;
      default:
        return null;
    }
  }
}

/// A single nutrient amount plus its unit, as read from a label.
class NutrientValue {
  const NutrientValue({required this.amount, required this.unit});

  final double amount;
  final NutrientUnit unit;

  /// Converts to the app's absolute units. Percentages are converted using
  /// [percentDailyValue] (e.g. 10% DV of vitamin D → 1 mcg when the daily
  /// value is 10 mcg); amounts already in app units pass through.
  double toAmount({double? percentDailyValue}) {
    return switch (unit) {
      NutrientUnit.percent =>
        percentDailyValue == null ? 0 : amount / 100 * percentDailyValue,
      _ => amount,
    };
  }

  factory NutrientValue.fromJson(Object? json) {
    if (json is! Map<String, dynamic>) {
      return const NutrientValue(amount: 0, unit: NutrientUnit.grams);
    }
    final amount = (json['amount'] is num)
        ? (json['amount'] as num).toDouble()
        : 0.0;
    final unit = NutrientUnit.tryParse(json['unit']?.toString() ?? '');
    return NutrientValue(amount: amount, unit: unit ?? NutrientUnit.grams);
  }

  Map<String, dynamic> toJson() => {'amount': amount, 'unit': unit.symbol};
}

/// A nutrition facts panel as read from an image by the AI extractor (or
/// normalized from a barcode API), keyed by the app's canonical nutrient
/// names.
class NutritionFactsPanel {
  const NutritionFactsPanel({
    this.productName,
    this.brandName,
    this.servingSize,
    this.servingUnit,
    this.nutrients = const {},
  });

  final String? productName;
  final String? brandName;

  /// Amount per serving, in [servingUnit] (null when the panel is per 100 g).
  final double? servingSize;
  final NutrientUnit? servingUnit;

  /// Nutrient key → amount, using the same keys as [FoodDraft] (e.g.
  /// `totalFat`, `vitaminD`).
  final Map<String, NutrientValue> nutrients;

  /// The panel converted to a [FoodDraft]. [foodId] is applied verbatim
  /// (usually a freshly generated id), [barcode] preserved.
  FoodDraft toFoodDraft({String foodId = '', String barcode = ''}) {
    double value(String key) =>
        nutrients[key]?.toAmount(
          percentDailyValue: _dailyValueFor(key),
        ) ??
        0;

    return FoodDraft(
      foodId: foodId,
      barcode: barcode,
      foodName: productName ?? '',
      brandName: brandName ?? '',
      servingSize: servingSize ?? 0,
      calories: value('calories'),
      totalFat: value('totalFat'),
      saturatedFat: value('saturatedFat'),
      transFat: value('transFat'),
      cholesterol: value('cholesterol'),
      sodium: value('sodium'),
      totalCarbohydrate: value('totalCarbohydrate'),
      dietaryFiber: value('dietaryFiber'),
      sugars: value('sugars'),
      addedSugars: value('addedSugars'),
      protein: value('protein'),
      vitaminD: value('vitaminD'),
      calcium: value('calcium'),
      iron: value('iron'),
      potassium: value('potassium'),
      vitaminA: value('vitaminA'),
      vitaminC: value('vitaminC'),
      vitaminB6: value('vitaminB6'),
      folate: value('folate'),
      thiamin: value('thiamin'),
      magnesium: value('magnesium'),
      zinc: value('zinc'),
      phosphorus: value('phosphorus'),
      riboflavin: value('riboflavin'),
      niacin: value('niacin'),
      pantothenicAcid: value('pantothenicAcid'),
      vitaminE: value('vitaminE'),
    );
  }

  factory NutritionFactsPanel.fromJson(Map<String, dynamic> json) {
    final rawNutrients = json['nutrients'];
    final nutrients = <String, NutrientValue>{};
    if (rawNutrients is Map<String, dynamic>) {
      rawNutrients.forEach((key, value) {
        nutrients[key] = NutrientValue.fromJson(value);
      });
    }

    return NutritionFactsPanel(
      productName: json['productName']?.toString(),
      brandName: json['brandName']?.toString(),
      servingSize: json['servingSize'] is num
          ? (json['servingSize'] as num).toDouble()
          : null,
      servingUnit: NutrientUnit.tryParse(json['servingUnit']?.toString() ?? ''),
      nutrients: nutrients,
    );
  }
}

/// FDA daily values used to convert "% daily value" readings into absolute
/// amounts. Values mirror `daily_values_constants.dart`.
double _dailyValueFor(String nutrientKey) {
  final value = switch (nutrientKey) {
    'calories' || 'sugars' => null, // Never expressed as %DV.
    'totalFat' => totalFatDailyValue,
    'saturatedFat' => saturatedFatDailyValue,
    'cholesterol' => cholesterolDailyValue,
    'sodium' => sodiumDailyValue,
    'totalCarbohydrate' => totalCarbohydrateDailyValue,
    'dietaryFiber' => dietaryFiberDailyValue,
    'addedSugars' => addedSugarsDailyValue,
    'protein' => proteinDailyValue,
    'vitaminD' => vitaminDDailyValue,
    'calcium' => calciumDailyValue,
    'iron' => ironDailyValue,
    'potassium' => potassiumDailyValue,
    'vitaminA' => vitaminADailyValue,
    'vitaminC' => vitaminCDailyValue,
    'vitaminB6' => vitaminB6DailyValue,
    'folate' => folateDailyValue,
    'thiamin' => thiaminDailyValue,
    'magnesium' => magnesiumDailyValue,
    'zinc' => zincDailyValue,
    'phosphorus' => phosphorusDailyValue,
    'riboflavin' => riboflavinDailyValue,
    'niacin' => niacinDailyValue,
    'pantothenicAcid' => pantothenicAcidDailyValue,
    'vitaminE' => vitaminEDailyValue,
    _ => null,
  };
  return value?.toDouble() ?? 0;
}
