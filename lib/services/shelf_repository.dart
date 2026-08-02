import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/shelf_food.dart';

/// Data access for the `users/{uid}/foodShelf` collection and the global
/// `foods` catalog.
///
/// Bound to a single authenticated user's [uid] at construction, so it can
/// never be called with a missing uid. Obtain instances from
/// `UserRepositories.shelf` (only available below the auth gate).
class ShelfRepository {
  ShelfRepository({required this.uid, FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance {
    if (uid.isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'must be a non-empty string');
    }
  }

  /// The uid of the user this repository reads and writes.
  final String uid;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _shelf =>
      _db.collection('users').doc(uid).collection('foodShelf');

  /// Live shelf sorted by food name.
  Stream<List<ShelfFood>> get shelfStream =>
      _shelf.orderBy('foodName').snapshots().map(_toFoods);

  /// Live shelf sorted by times added (most-used first).
  Stream<List<ShelfFood>> get topFoodsStream =>
      _shelf.orderBy('timesAdded', descending: true).snapshots().map(_toFoods);

  /// Persists a food to the user's shelf.
  Future<void> addFood(String foodId, Map<String, dynamic> data) {
    return _shelf.doc(foodId).set(data);
  }

  /// Removes a food from the user's shelf.
  Future<void> deleteFood(String foodId) {
    return _shelf.doc(foodId).delete();
  }

  /// Increments the `timesAdded` counter of a shelf food.
  Future<void> incrementTimesAdded(String foodId) {
    return _shelf.doc(foodId).update({'timesAdded': FieldValue.increment(1)});
  }

  List<ShelfFood> _toFoods(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => ShelfFood.fromMap(doc.id, doc.data()))
        .toList();
  }
}
