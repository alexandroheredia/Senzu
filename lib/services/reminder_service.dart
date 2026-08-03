import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Daily logging reminders via local notifications.
///
/// A single configurable time of day ("Remind me at 20:00 to log my day").
/// The schedule is stored locally (not per-user in Firestore) so it works
/// offline and needs no schema change; re-scheduling is idempotent.
class ReminderService {
  ReminderService({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  static const int _reminderId = 1;

  final FlutterLocalNotificationsPlugin _plugin;

  /// Current schedule in minutes since midnight, or null when disabled.
  int? _scheduleMinutes;

  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    tz.initializeTimeZones();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
    );
    await _plugin.initialize(settings);
    _initialized = true;
  }

  /// Enables the daily reminder at [time] (hour:minute).
  Future<void> scheduleDaily(TimeOfDay time) async {
    await _ensureInit();
    await cancel();
    _scheduleMinutes = time.hour * 60 + time.minute;

    final now = DateTime.now();
    final scheduled = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    await _plugin.zonedSchedule(
      _reminderId,
      'Senzu',
      "Don't forget to log today's meals.",
      tz.TZDateTime.from(
        scheduled.isAfter(now)
            ? scheduled
            : scheduled.add(const Duration(days: 1)),
        tz.local,
      ),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily reminder',
          channelDescription: 'Daily meal-logging reminder',
        ),
        iOS: DarwinNotificationDetails(),
      ),
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }

  /// Cancels the reminder (also used when disabling).
  Future<void> cancel() async {
    _scheduleMinutes = null;
    await _plugin.cancel(_reminderId);
  }

  /// The active schedule, or null when disabled.
  int? get scheduleMinutes => _scheduleMinutes;
}

/// The reminder service provider. Override in tests.
final reminderServiceProvider = Provider<ReminderService>(
  (ref) => ReminderService(),
);
