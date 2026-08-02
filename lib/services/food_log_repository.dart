import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/food_entry.dart';

/// Data access for the `users/{uid}/foodEntries` collection.
///
/// Bound to a single authenticated user's [uid] at construction, so it can
/// never be called with a missing uid. Obtain instances from
/// `UserRepositories.foodLog` (only available below the auth gate).
///
/// Widgets should depend on this (or a service that wraps it) instead of
/// querying Firestore inline.
class FoodLogRepository {
  FoodLogRepository({required this.uid, FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance {
    if (uid.isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'must be a non-empty string');
    }
  }

  /// The uid of the user this repository reads and writes.
  final String uid;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _entries =>
      _db.collection('users').doc(uid).collection('foodEntries');

  /// Live summary of all entries logged on [date].
  Stream<FoodLogSummary> daySummary(DateTime date) {
    return _entries
        .where('dateAdded', isEqualTo: date)
        .snapshots()
        .map(_toSummary);
  }

  /// Live list of entries logged on [date].
  Stream<List<FoodEntry>> dayEntries(DateTime date) {
    return _entries
        .where('dateAdded', isEqualTo: date)
        .snapshots()
        .map(_toEntries);
  }

  /// Live list of entries added after [since].
  Stream<List<FoodEntry>> entriesSince(DateTime since) {
    return _entries
        .where('dateAdded', isGreaterThan: since)
        .snapshots()
        .map(_toEntries);
  }

  /// Live list of entries for one meal on [date].
  Stream<List<FoodEntry>> mealEntries(MealType meal, DateTime date) {
    return _entries
        .where('mealType', isEqualTo: mealTypeToString(meal))
        .where('dateAdded', isEqualTo: date)
        .snapshots()
        .map(_toEntries);
  }

  /// Persists a new food entry.
  Future<void> addEntry(Map<String, dynamic> data) {
    return _entries.add(data);
  }

  /// Deletes a food entry by id.
  Future<void> deleteEntry(String entryId) {
    return _entries.doc(entryId).delete();
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
