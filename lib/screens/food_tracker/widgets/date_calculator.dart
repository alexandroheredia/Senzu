import 'package:intl/intl.dart';

String cleanMonthFormat(String date) {
  final displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final serverFormater = DateFormat('MM');
  final displayDate = displayFormater.parse(date);
  final formatted = serverFormater.format(displayDate);
  return formatted;
}

String cleanYearFormat(String date) {
  final displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final serverFormater = DateFormat('yyyy');
  final displayDate = displayFormater.parse(date);
  final formatted = serverFormater.format(displayDate);
  return formatted;
}

DateTime cleanDateFormat() {
  final convertedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  final parsedDate = DateTime.parse(convertedDate);
  return parsedDate;
}

int getWeekNumber(DateTime date) {
  final year = date.year;
  final stateDate = DateTime(year);
  final weekday = stateDate.weekday;
  final days = date.difference(stateDate).inDays;
  final week = ((weekday + days) / 7).ceil();
  return week;
}

/// Normalizes [date] to midnight (start of day).
DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

/// Today's date normalized to midnight.
DateTime todayMidnight() => startOfDay(DateTime.now());

/// [days] days before [date].
DateTime daysBefore(DateTime date, int days) =>
    date.subtract(Duration(days: days));
