import 'package:flutter_test/flutter_test.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';

void main() {
  group('startOfDay', () {
    test('normalizes a date to midnight', () {
      final date = DateTime(2026, 8, 1, 14, 30, 45);
      expect(startOfDay(date), DateTime(2026, 8));
    });

    test('keeps midnight dates unchanged', () {
      final date = DateTime(2026, 8);
      expect(startOfDay(date), date);
    });
  });

  group('daysBefore', () {
    test('subtracts the given number of days', () {
      expect(daysBefore(DateTime(2026, 8), 7), DateTime(2026, 7, 25));
      expect(daysBefore(DateTime(2026, 8), 30), DateTime(2026, 7, 2));
    });
  });

  group('getWeekNumber', () {
    test('returns week 1 for January 1st', () {
      expect(getWeekNumber(DateTime(2026)), 1);
    });

    test('returns a higher week later in the year', () {
      expect(getWeekNumber(DateTime(2026, 12, 31)), greaterThan(1));
    });
  });

  group('cleanMonthFormat', () {
    test('extracts the month number', () {
      expect(cleanMonthFormat('2026-08-01 10:00:00.000'), '08');
    });
  });

  group('cleanYearFormat', () {
    test('extracts the year', () {
      expect(cleanYearFormat('2026-08-01 10:00:00.000'), '2026');
    });
  });
}
