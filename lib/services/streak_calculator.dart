/// Streak helpers: days in a row with at least one logged entry.
///
/// Pure functions over the day timestamps of logged entries, unit-testable
/// without Firestore.
library;

/// Counts consecutive days (ending today or yesterday) that have at least
/// one entry. A streak is broken when neither today nor yesterday is logged;
/// if today has no entry yet but yesterday does, the streak is still "alive"
/// and counts from yesterday.
int currentStreak(Set<DateTime> loggedDays) {
  final days = loggedDays.map(_normalize).toSet();
  final today = _normalize(DateTime.now());

  var cursor = days.contains(today) ? today : today.subtract(const Duration(days: 1));
  var streak = 0;
  while (days.contains(cursor)) {
    streak++;
    cursor = cursor.subtract(const Duration(days: 1));
  }
  return streak;
}

/// Total number of distinct days with at least one entry.
int totalDaysLogged(Set<DateTime> loggedDays) =>
    loggedDays.map(_normalize).toSet().length;

DateTime _normalize(DateTime date) => DateTime(date.year, date.month, date.day);
