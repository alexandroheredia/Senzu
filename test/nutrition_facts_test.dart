import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/models/nutrition_facts.dart';
import 'package:senzu_app/services/open_food_facts_api.dart';

void main() {
  group('NutrientUnit.tryParse', () {
    test('parses printed label units', () {
      expect(NutrientUnit.tryParse('g'), NutrientUnit.grams);
      expect(NutrientUnit.tryParse('mg'), NutrientUnit.milligrams);
      expect(NutrientUnit.tryParse('mcg'), NutrientUnit.micrograms);
      expect(NutrientUnit.tryParse('µg'), NutrientUnit.micrograms);
      expect(NutrientUnit.tryParse('kcal'), NutrientUnit.kilocalories);
      expect(NutrientUnit.tryParse('%'), NutrientUnit.percent);
      expect(NutrientUnit.tryParse('Daily Value'), NutrientUnit.percent);
    });

    test('returns null for unknown units', () {
      expect(NutrientUnit.tryParse('oz'), isNull);
      expect(NutrientUnit.tryParse(''), isNull);
    });
  });

  group('NutrientValue.toAmount', () {
    test('passes through absolute amounts', () {
      const value = NutrientValue(amount: 5.5, unit: NutrientUnit.grams);
      expect(value.toAmount(), 5.5);
    });

    test('converts percentages using the daily value', () {
      const value = NutrientValue(amount: 10, unit: NutrientUnit.percent);
      expect(value.toAmount(percentDailyValue: 10), closeTo(1, 0.001));
    });
  });

  group('NutritionFactsPanel.toFoodDraft', () {
    test('converts a panel to a draft with %DV resolved', () {
      const panel = NutritionFactsPanel(
        productName: 'Cereal',
        brandName: 'Brand',
        servingSize: 30,
        servingUnit: NutrientUnit.grams,
        nutrients: {
          'calories': NutrientValue(
            amount: 120,
            unit: NutrientUnit.kilocalories,
          ),
          'protein': NutrientValue(amount: 3, unit: NutrientUnit.grams),
          'vitaminD': NutrientValue(amount: 10, unit: NutrientUnit.percent),
          'calcium': NutrientValue(amount: 20, unit: NutrientUnit.percent),
        },
      );

      final draft = panel.toFoodDraft(foodId: 'f1', barcode: '123');

      expect(draft.foodId, 'f1');
      expect(draft.barcode, '123');
      expect(draft.foodName, 'Cereal');
      expect(draft.brandName, 'Brand');
      expect(draft.servingSize, 30);
      expect(draft.calories, 120);
      expect(draft.protein, 3);
      // 10% DV of vitamin D (10 mcg) → 1 mcg.
      expect(draft.vitaminD, closeTo(1, 0.001));
      // 20% DV of calcium (800 mg) → 160 mg.
      expect(draft.calcium, closeTo(160, 0.001));
    });

    test('fromJson reads the AI response shape', () {
      final panel = NutritionFactsPanel.fromJson({
        'productName': 'Cola',
        'servingSize': 240,
        'servingUnit': 'ml',
        'nutrients': {
          'calories': {'amount': 90, 'unit': 'kcal'},
          'sodium': {'amount': 15, 'unit': 'mg'},
        },
      });

      expect(panel.productName, 'Cola');
      expect(panel.servingSize, 240);
      expect(panel.servingUnit, isNull); // 'ml' is not a nutrient unit.
      expect(panel.nutrients['calories']!.amount, 90);
      expect(panel.nutrients['sodium']!.amount, 15);
    });
  });

  group('openFoodFactsDraftFromJson', () {
    test('normalizes a per-serving product response', () {
      final draft = openFoodFactsDraftFromJson({
        'code': '3017624010701',
        'status': 1,
        'product': {
          'product_name': 'Nutella',
          'brands': 'Ferrero',
          'serving_size': '15 g',
          'nutriments': {
            'energy-kcal_serving': 81,
            'energy-kcal_100g': 539,
            'fat_serving': 4.6,
            'fat_100g': 30.9,
            'saturated-fat_serving': 1.6,
            'saturated-fat_100g': 10.6,
            'sodium_serving': 0.019,
            'sodium_100g': 0.127,
            'carbohydrates_serving': 8.6,
            'carbohydrates_100g': 57.5,
            'sugars_serving': 8.4,
            'sugars_100g': 56.3,
            'proteins_serving': 0.9,
            'proteins_100g': 6.3,
          },
        },
      }, barcode: '3017624010701');

      expect(draft.barcode, '3017624010701');
      expect(draft.foodName, 'Nutella');
      expect(draft.brandName, 'Ferrero');
      expect(draft.servingSize, 15);
      expect(draft.calories, 81);
      expect(draft.totalFat, 4.6);
      expect(draft.saturatedFat, 1.6);
      expect(draft.totalCarbohydrate, 8.6);
      expect(draft.sugars, 8.4);
      expect(draft.protein, 0.9);
    });

    test('scales per-100g values when no serving is declared', () {
      final draft = openFoodFactsDraftFromJson({
        'status': 1,
        'product': {
          'product_name': 'Pasta',
          'nutriments': {
            'energy-kcal_100g': 350,
            'carbohydrates_100g': 70,
            'proteins_100g': 12,
          },
        },
      });

      expect(draft.foodName, 'Pasta');
      expect(draft.servingSize, 100);
      expect(draft.calories, 350);
      expect(draft.totalCarbohydrate, 70);
      expect(draft.protein, 12);
    });

    test('returns an empty draft for a missing product', () {
      final draft = openFoodFactsDraftFromJson({'status': 0});
      expect(draft.isEmpty, isTrue);
    });
  });
}
