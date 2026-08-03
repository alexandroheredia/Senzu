import 'dart:io' show Platform;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health/health.dart';

/// HealthKit (iOS) weight sync.
///
/// Reads body-weight samples from Apple HealthKit and merges them into the
/// user's `weightEntries` collection (one entry per day, deduplicated by the
/// repository's per-day document id).
///
/// Everything is defensive: until the HealthKit capability is enabled in
/// Xcode (see implementation plan §22) the plugin throws `MissingPlugin` /
/// `UnsupportedError`, which we swallow so the app keeps working.
class HealthKitService {
  HealthKitService({Health? health}) : _health = health ?? Health();

  final Health _health;

  /// Whether this platform supports HealthKit (iOS only).
  bool get isSupported => Platform.isIOS;

  /// Requests read access to body weight. Returns true when granted (or the
  /// permission sheet was shown without error on iOS).
  Future<bool> requestWeightPermission() async {
    if (!isSupported) return false;
    try {
      await _health.configure();
      return await _health.requestAuthorization(
        [HealthDataType.WEIGHT],
        permissions: [HealthDataAccess.READ],
      );
    } on Object {
      return false;
    }
  }

  /// Fetches weight samples in [since]..now as `(date, kg)` pairs, newest
  /// first. Defensive: returns an empty list when HealthKit is unavailable.
  Future<List<({DateTime date, double kg})>> fetchWeights({
    DateTime? since,
  }) async {
    if (!isSupported) return const [];
    try {
      final end = DateTime.now();
      final start = since ?? end.subtract(const Duration(days: 365));
      final points = await _health.getHealthDataFromTypes(
        types: [HealthDataType.WEIGHT],
        startTime: start,
        endTime: end,
      );
      final results = <({DateTime date, double kg})>[];
      for (final point in points) {
        final value = point.value;
        if (value is! NumericHealthValue) continue;
        results.add((
          date: point.dateFrom,
          kg: value.numericValue.toDouble(),
        ));
      }
      results.sort((a, b) => b.date.compareTo(a.date));
      return results;
    } on Object {
      return const [];
    }
  }
}

/// Provider for the HealthKit service. Override in tests.
final healthKitServiceProvider = Provider<HealthKitService>(
  (ref) => HealthKitService(),
);
