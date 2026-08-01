import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/shelf_food.dart';

/// Data access for the `users/{uid}/foodShelf` collection and the global
/// `foods` catalog.
class ShelfRepository {
  final FirebaseFirestore _db;

  ShelfRepository({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _shelf(String uid) =>
      _db.collection('users').doc(uid).collection('foodShelf');

  CollectionReference<Map<String, dynamic>> get _catalog =>
      _db.collection('foods');

  /// Live shelf sorted by food name.
  Stream<List<ShelfFood>> shelfStream(String uid) {
    return _shelf(uid).orderBy('foodName').snapshots().map(_toFoods);
  }

  /// Live shelf sorted by times added (most-used first).
  Stream<List<ShelfFood>> topFoodsStream(String uid) {
    return _shelf(
      uid,
    ).orderBy('timesAdded', descending: true).snapshots().map(_toFoods);
  }

  /// Persists a food to the user's shelf.
  Future<void> addFood(String uid, String foodId, Map<String, dynamic> data) {
    return _shelf(uid).doc(foodId).set(data);
  }

  /// Removes a food from the user's shelf.
  Future<void> deleteFood(String uid, String foodId) {
    return _shelf(uid).doc(foodId).delete();
  }

  /// Increments the `timesAdded` counter of a shelf food.
  Future<void> incrementTimesAdded(String uid, String foodId) {
    return _shelf(
      uid,
    ).doc(foodId).update({'timesAdded': FieldValue.increment(1)});
  }

  /// Persists a food to the global catalog (`foods` collection).
  Future<void> addToCatalog(String foodId, Map<String, dynamic> data) {
    return _catalog.doc(foodId).set(data);
  }

  List<ShelfFood> _toFoods(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => ShelfFood.fromMap(doc.id, doc.data()))
        .toList();
  }
}
