import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/meal.dart';

/// Data access for the `users/{uid}/meals` collection and its nested
/// `foodItems` subcollection.
class MealRepository {
  final FirebaseFirestore _db;

  MealRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _meals(String uid) =>
      _db.collection('users').doc(uid).collection('meals');

  CollectionReference<Map<String, dynamic>> _foodItems(String uid, String mealId) =>
      _meals(uid).doc(mealId).collection('foodItems');

  CollectionReference<Map<String, dynamic>> _entries(String uid) =>
      _db.collection('users').doc(uid).collection('foodEntries');

  /// Live list of the user's meals sorted by name.
  Stream<List<Meal>> mealsStream(String uid) {
    return _meals(uid).orderBy('mealName').snapshots().map(
          (s) => s.docs
              .map((doc) => Meal.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Creates (or overwrites) a meal document.
  Future<void> createMeal(String uid, String mealId, String mealName) {
    return _meals(uid).doc(mealId).set({'mealName': mealName, 'mealId': mealId});
  }

  /// Live list of food items inside a meal sorted by name.
  Stream<List<MealFoodItem>> foodItemsStream(String uid, String mealId) {
    return _foodItems(uid, mealId).orderBy('foodName').snapshots().map(
          (s) => s.docs
              .map((doc) => MealFoodItem.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Adds a food item to a meal.
  Future<void> addFoodItem(String uid, String mealId, Map<String, dynamic> data) {
    return _foodItems(uid, mealId).add(data);
  }

  /// Removes a food item from a meal.
  Future<void> deleteFoodItem(String uid, String mealId, String itemId) {
    return _foodItems(uid, mealId).doc(itemId).delete();
  }

  /// Copies every food item of a meal into the user's food log.
  Future<void> copyMealToFoodEntries(String uid, String mealId) async {
    final snapshot = await _foodItems(uid, mealId).get();
    for (final doc in snapshot.docs) {
      await _entries(uid).add(doc.data());
    }
  }

  /// Updates matching food items so they can be read by the food-log
  /// `where()` filters (meal type, week, month, year, date).
  Future<void> updateFoodItemsForDate(
    String uid,
    String mealId,
    Map<String, dynamic> update,
  ) async {
    final snapshot = await _foodItems(uid, mealId)
        .where('mealId', isEqualTo: mealId)
        .get();
    for (final doc in snapshot.docs) {
      await doc.reference.update(update);
    }
  }
}
