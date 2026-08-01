import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/food_entry.dart';

/// Data access for the `users/{uid}/foodEntries` collection.
///
/// Widgets should depend on this (or a service that wraps it) instead of
/// querying Firestore inline.
class FoodLogRepository {
  final FirebaseFirestore _db;

  FoodLogRepository({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _entries(String uid) =>
      _db.collection('users').doc(uid).collection('foodEntries');

  /// Live summary of all entries logged on [date] for [uid].
  Stream<FoodLogSummary> daySummary(String uid, DateTime date) {
    return _entries(
      uid,
    ).where('dateAdded', isEqualTo: date).snapshots().map(_toSummary);
  }

  /// Live list of entries logged on [date] for [uid].
  Stream<List<FoodEntry>> dayEntries(String uid, DateTime date) {
    return _entries(
      uid,
    ).where('dateAdded', isEqualTo: date).snapshots().map(_toEntries);
  }

  /// Live list of entries added after [since] for [uid].
  Stream<List<FoodEntry>> entriesSince(String uid, DateTime since) {
    return _entries(
      uid,
    ).where('dateAdded', isGreaterThan: since).snapshots().map(_toEntries);
  }

  /// Live list of entries for one meal on [date] for [uid].
  Stream<List<FoodEntry>> mealEntries(
    String uid,
    MealType meal,
    DateTime date,
  ) {
    return _entries(uid)
        .where('mealType', isEqualTo: mealTypeToString(meal))
        .where('dateAdded', isEqualTo: date)
        .snapshots()
        .map(_toEntries);
  }

  /// Persists a new food entry for [uid].
  Future<void> addEntry(String uid, Map<String, dynamic> data) {
    return _entries(uid).add(data);
  }

  /// Deletes a food entry by id.
  Future<void> deleteEntry(String uid, String entryId) {
    return _entries(uid).doc(entryId).delete();
  }

  List<FoodEntry> _toEntries(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return snapshot.docs
        .map((doc) => FoodEntry.fromMap(doc.id, doc.data()))
        .toList();
  }

  FoodLogSummary _toSummary(QuerySnapshot<Map<String, dynamic>> snapshot) {
    return FoodLogSummary.fromEntries(_toEntries(snapshot));
  }
}
