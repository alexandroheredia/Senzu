import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/meal.dart';

/// Data access for the `users/{uid}/meals` collection and its nested
/// `foodItems` subcollection.
///
/// Bound to a single authenticated user's [uid] at construction, so it can
/// never be called with a missing uid. Obtain instances from
/// `UserRepositories.meals` (only available below the auth gate).
class MealRepository {
  MealRepository({required this.uid, FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance {
    if (uid.isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'must be a non-empty string');
    }
  }

  /// The uid of the user this repository reads and writes.
  final String uid;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _meals =>
      _db.collection('users').doc(uid).collection('meals');

  CollectionReference<Map<String, dynamic>> _foodItems(String mealId) =>
      _meals.doc(mealId).collection('foodItems');

  CollectionReference<Map<String, dynamic>> get _entries =>
      _db.collection('users').doc(uid).collection('foodEntries');

  /// Live list of the user's meals sorted by name.
  Stream<List<Meal>> get mealsStream => _meals
      .orderBy('mealName')
      .snapshots()
      .map(
        (s) => s.docs.map((doc) => Meal.fromMap(doc.id, doc.data())).toList(),
      );

  /// Creates (or overwrites) a meal document.
  Future<void> createMeal(String mealId, String mealName) {
    return _meals.doc(mealId).set({'mealName': mealName, 'mealId': mealId});
  }

  /// Live list of food items inside a meal sorted by name.
  Stream<List<MealFoodItem>> foodItemsStream(String mealId) {
    return _foodItems(mealId)
        .orderBy('foodName')
        .snapshots()
        .map(
          (s) => s.docs
              .map((doc) => MealFoodItem.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Adds a food item to a meal.
  Future<void> addFoodItem(String mealId, Map<String, dynamic> data) {
    return _foodItems(mealId).add(data);
  }

  /// Removes a food item from a meal.
  Future<void> deleteFoodItem(String mealId, String itemId) {
    return _foodItems(mealId).doc(itemId).delete();
  }

  /// Updates a food item (e.g. portion size changed).
  Future<void> updateFoodItem(
    String mealId,
    String itemId,
    Map<String, dynamic> data,
  ) {
    return _foodItems(mealId).doc(itemId).update(data);
  }

  /// Copies every food item of a meal into the user's food log.
  Future<void> copyMealToFoodEntries(String mealId) async {
    final snapshot = await _foodItems(mealId).get();
    for (final doc in snapshot.docs) {
      await _entries.add(doc.data());
    }
  }

  /// Updates matching food items so they can be read by the food-log
  /// `where()` filters (meal type, week, month, year, date).
  Future<void> updateFoodItemsForDate(
    String mealId,
    Map<String, dynamic> update,
  ) async {
    final snapshot = await _foodItems(mealId)
        .where(
          'mealId',
          isEqualTo: mealId,
        )
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.update(update);
    }
  }
}
