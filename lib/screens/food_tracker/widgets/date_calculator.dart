import 'package:intl/intl.dart';


String cleanMonthFormat(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('MM');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

String cleanYearFormat(String date) {
  final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
  final DateFormat serverFormater = DateFormat('yyyy');
  final DateTime displayDate = displayFormater.parse(date);
  final String formatted = serverFormater.format(displayDate);
  return formatted;
}

DateTime cleanDateFormat(){
  String convertedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());
  var parsedDate = DateTime.parse(convertedDate);
  return parsedDate;
}

int getWeekNumber(DateTime date){
  int year = date.year;
  DateTime stateDate = DateTime(year,1,1);
  int weekday = stateDate.weekday;
  int days = date.difference(stateDate).inDays; 
  int week = ((weekday+days)/7).ceil();
  return week;
}

/// Normalizes [date] to midnight (start of day).
DateTime startOfDay(DateTime date) => DateTime(date.year, date.month, date.day);

/// Today's date normalized to midnight.
DateTime todayMidnight() => startOfDay(DateTime.now());

/// [days] days before [date].
DateTime daysBefore(DateTime date, int days) => date.subtract(Duration(days: days));

