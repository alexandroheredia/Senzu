import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:home_widget/home_widget.dart';

/// App Group shared with the iOS home-screen widget. The widget reads the
/// same suite the app writes to, so this must match the App Group you enable
/// in Xcode for both targets (see the implementation plan §22 recipe).
const String kWidgetAppGroupId = 'group.com.koombastudios.senzuApp';

/// Keys written into the shared UserDefaults suite.
const String kWidgetCaloriesKey = 'senzu_calories_consumed';
const String kWidgetGoalKey = 'senzu_calorie_goal';
const String kWidgetUpdatedAtKey = 'senzu_updated_at';

/// Writes today's calorie snapshot to the home-screen widget's shared
/// storage and asks iOS to reload the widget.
///
/// Every call is defensive: if the App Group isn't configured yet (or the
/// widget extension target hasn't been added in Xcode), these calls fail
/// silently instead of breaking the app.
class WidgetDataService {
  /// Enables the app group for this session (iOS only). Safe to call
  /// repeatedly.
  Future<void> setAppGroup() async {
    try {
      await HomeWidget.setAppGroupId(kWidgetAppGroupId);
    } on Object {
      // App Group not configured yet — the widget is a no-op.
    }
  }

  /// Pushes the current calorie snapshot to the widget.
  Future<void> pushCalories({
    required int consumed,
    required int goal,
  }) async {
    try {
      await setAppGroup();
      await HomeWidget.saveWidgetData<int>(kWidgetCaloriesKey, consumed);
      await HomeWidget.saveWidgetData<int>(kWidgetGoalKey, goal);
      await HomeWidget.saveWidgetData<int>(
        kWidgetUpdatedAtKey,
        DateTime.now().millisecondsSinceEpoch,
      );
      await HomeWidget.updateWidget(
        iOSName: 'SenzuWidget',
        androidName: 'SenzuWidgetProvider',
      );
    } on Object {
      // Widget not reachable (no extension target yet) — ignore.
    }
  }
}

/// Provider for the widget data service. Override in tests.
final widgetDataServiceProvider = Provider<WidgetDataService>(
  (ref) => WidgetDataService(),
);
