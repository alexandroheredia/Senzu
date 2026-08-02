import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/models/food_draft.dart';
import 'package:senzu_app/models/shelf_food.dart';

void main() {
  group('FoodDraft.toFoodMap', () {
    test('serializes every field into the catalog schema', () {
      const draft = FoodDraft(
        foodId: 'abc123',
        barcode: '012345678905',
        foodName: 'Greek Yogurt',
        brandName: 'Brand X',
        servingSize: 170,
        calories: 100,
        protein: 10,
        vitaminD: 2,
      );

      final map = draft.toFoodMap();

      expect(map['foodId'], 'abc123');
      expect(map['barcode'], '012345678905');
      expect(map['foodName'], 'Greek Yogurt');
      expect(map['brandName'], 'Brand X');
      expect(map['servingSize'], 170);
      expect(map['calories'], 100);
      expect(map['totalFat'], 0);
      expect(map['protein'], 10);
      expect(map['vitaminD'], 2);
      expect(map.containsKey('timesAdded'), isFalse);
    });

    test('omits the barcode key when empty', () {
      final map = const FoodDraft(
        foodId: 'x',
        foodName: 'No Barcode',
      ).toFoodMap();
      expect(map.containsKey('barcode'), isFalse);
    });

    test('toShelfMap adds the timesAdded counter', () {
      final map = const FoodDraft(foodId: 'x', foodName: 'Y').toShelfMap();
      expect(map['timesAdded'], 0);
    });
  });

  group('FoodDraft.fromShelfFood', () {
    test('round-trips a shelf document back into a draft', () {
      const food = ShelfFood(
        id: 'doc1',
        foodId: 'abc123',
        barcode: '012345678905',
        foodName: 'Greek Yogurt',
        brandName: 'Brand X',
        servingSize: 170,
        calories: 100,
        protein: 10,
        timesAdded: 3,
      );

      final draft = FoodDraft.fromShelfFood(food);

      expect(draft.foodId, 'abc123');
      expect(draft.barcode, '012345678905');
      expect(draft.foodName, 'Greek Yogurt');
      expect(draft.servingSize, 170);
      expect(draft.calories, 100);
      expect(draft.protein, 10);
      expect(draft.timesAdded, 3);
    });
  });

  group('FoodDraft.withFoodId', () {
    test('reassigns the food id and keeps the rest', () {
      final draft = const FoodDraft(
        barcode: '123',
        foodName: 'Oats',
        calories: 150,
      ).withFoodId('new-id');

      expect(draft.foodId, 'new-id');
      expect(draft.barcode, '123');
      expect(draft.foodName, 'Oats');
      expect(draft.calories, 150);
    });
  });
}
