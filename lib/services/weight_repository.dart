import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/weight_entry.dart';

/// Data access for the `users/{uid}/weightEntries` collection.
///
/// Bound to a single authenticated user's [uid] at construction; obtain from
/// `UserRepositories.weight`.
class WeightRepository {
  WeightRepository({required this.uid, FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance {
    if (uid.isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'must be a non-empty string');
    }
  }

  /// The uid of the user this repository reads and writes.
  final String uid;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _entries =>
      _db.collection('users').doc(uid).collection('weightEntries');

  /// Live list of weight entries, oldest first.
  Stream<List<WeightEntry>> weightStream() {
    return _entries
        .orderBy('date')
        .snapshots()
        .map(
          (s) => s.docs
              .map((doc) => WeightEntry.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  /// Logs a weight for [date] (midnight-normalized). Writing to a fixed
  /// document id per day means re-logging the same day replaces the value
  /// instead of stacking duplicates.
  Future<void> setWeight(DateTime date, double weightKg) {
    final day = DateTime(date.year, date.month, date.day);
    return _entries.doc(day.toIso8601String()).set({
      'date': day,
      'weightKg': weightKg,
    });
  }

  /// Removes a weight entry by id.
  Future<void> deleteWeight(String entryId) {
    return _entries.doc(entryId).delete();
  }
}
