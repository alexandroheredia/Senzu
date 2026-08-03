import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/services/open_food_facts_api.dart';

void main() {
  group('openFoodFactsDraftFromJson', () {
    test('parses a search-result product into a draft', () {
      final draft = openFoodFactsDraftFromJson(
        {
          'product': {
            'code': '0123456789012',
            'product_name': 'Greek Yogurt',
            'brands': 'Fage',
            'serving_size': '150 g',
            'nutriments': {
              'energy-kcal_100g': 59,
              'proteins_100g': 10,
              'fat_100g': 0.4,
              'carbohydrates_100g': 3.6,
            },
          },
        },
        barcode: '0123456789012',
      );
      expect(draft.foodName, 'Greek Yogurt');
      expect(draft.brandName, 'Fage');
      expect(draft.barcode, '0123456789012');
      expect(draft.servingSize, 150);
      // Per-100g values scaled to the 150g serving.
      expect(draft.calories, closeTo(88.5, 0.001));
      expect(draft.protein, closeTo(15, 0.001));
      expect(draft.totalFat, closeTo(0.6, 0.001));
      expect(draft.totalCarbohydrate, closeTo(5.4, 0.001));
    });

    test('drops results with no product name', () {
      final draft = openFoodFactsDraftFromJson({
        'product': {'code': 'x', 'nutriments': const <String, dynamic>{}},
      });
      expect(draft.foodName, isEmpty);
      expect(draft.isEmpty, isTrue);
    });

    test('handles a missing product map', () {
      expect(openFoodFactsDraftFromJson(const {}).foodName, isEmpty);
    });
  });
}
