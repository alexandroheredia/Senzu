import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/services/streak_calculator.dart';

void main() {
  final today = DateTime.now();

  DateTime day(int offset) => DateTime(
    today.year,
    today.month,
    today.day,
  ).subtract(Duration(days: offset));

  group('currentStreak', () {
    test('counts consecutive days ending today', () {
      final streak = currentStreak({day(0), day(1), day(2)});
      expect(streak, 3);
    });

    test('counts consecutive days ending yesterday when today is empty', () {
      // Today not logged yet, but yesterday + before were.
      final streak = currentStreak({day(1), day(2), day(3)});
      expect(streak, 3);
    });

    test('breaks when neither today nor yesterday is logged', () {
      final streak = currentStreak({day(2), day(3)});
      expect(streak, 0);
    });

    test('handles gaps', () {
      final streak = currentStreak({day(0), day(1), day(3), day(4)});
      expect(streak, 2); // only day 0 + day 1 count
    });

    test('empty set gives zero', () {
      expect(currentStreak(<DateTime>{}), 0);
    });
  });

  group('totalDaysLogged', () {
    test('counts distinct days only', () {
      final days = {
        day(0),
        day(0), // duplicate
        day(1),
        day(5),
      };
      expect(totalDaysLogged(days), 3);
    });
  });
}
