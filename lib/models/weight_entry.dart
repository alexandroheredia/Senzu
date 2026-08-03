import 'package:cloud_firestore/cloud_firestore.dart';

/// Typed representation of a document in `users/{uid}/weightEntries`.
class WeightEntry {
  final String id;

  /// The date this weight was measured (normalized to midnight).
  final DateTime date;

  /// Body weight in kilograms.
  final double weightKg;

  const WeightEntry({
    required this.id,
    required this.date,
    this.weightKg = 0,
  });

  factory WeightEntry.fromMap(String id, Map<String, dynamic> map) {
    return WeightEntry(
      id: id,
      date: _date(map['date']),
      weightKg: _double(map['weightKg']),
    );
  }

  Map<String, dynamic> toMap() => {
    'date': date,
    'weightKg': weightKg,
  };
}

DateTime _date(Object? value) {
  if (value is DateTime) return value;
  if (value is Timestamp) return value.toDate();
  return DateTime(2000);
}

double _double(Object? value) {
  if (value is num) return value.toDouble();
  return 0;
}
