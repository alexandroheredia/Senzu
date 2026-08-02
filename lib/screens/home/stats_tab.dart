import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_segmented.dart';

enum _StatRange { week, month }

/// Progress tab: glass segmented control for the time range, a weekly
/// calorie bar chart in a glass card, and per-nutrient averages.
class StatsTab extends ConsumerStatefulWidget {
  const StatsTab({super.key});

  @override
  ConsumerState<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends ConsumerState<StatsTab> {
  _StatRange _range = _StatRange.week;

  int get _days => _range == _StatRange.week ? 7 : 30;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      children: [
        Text('Progress', style: Theme.of(context).textTheme.headlineLarge),
        const SizedBox(height: 16),
        GlassSegmentedControl<_StatRange>(
          segments: const [
            GlassSegment<_StatRange>(_StatRange.week, 'Week'),
            GlassSegment<_StatRange>(_StatRange.month, 'Month'),
          ],
          value: _range,
          onChanged: (value) => setState(() => _range = value),
        ),
        const SizedBox(height: 16),
        ref
            .watch(entriesSinceProvider(daysBefore(todayMidnight(), _days)))
            .when(
              data: (entries) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _CalorieChartCard(entries: entries, days: _days),
                    const SizedBox(height: 28),
                    Text(
                      'Nutrient averages',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 14),
                    GlassCard(
                      child: _NutrientAverages(entries: entries, days: _days),
                    ),
                  ],
                );
              },
              loading: () => const SizedBox(
                height: 420,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (_, _) => const SizedBox(
                height: 420,
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
      ],
    );
  }
}

/// Calories per day (week) or per week (month), oldest → newest.
List<(String, int)> _buckets(List<FoodEntry> entries, int days) {
  final perDay = <DateTime, int>{};
  for (final entry in entries) {
    final day = startOfDay(entry.dateAdded);
    perDay[day] = (perDay[day] ?? 0) + entry.calories;
  }

  final now = todayMidnight();
  const weekdays = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  final result = <(String, int)>[];

  if (days == 7) {
    for (var i = 6; i >= 0; i--) {
      final day = now.subtract(Duration(days: i));
      result.add((weekdays[day.weekday - 1], perDay[day] ?? 0));
    }
  } else {
    for (var w = 4; w >= 1; w--) {
      var sum = 0;
      for (var d = 0; d < 7; d++) {
        final day = now.subtract(Duration(days: w * 7 - d));
        sum += perDay[day] ?? 0;
      }
      result.add(('W$w', sum));
    }
  }
  return result;
}

/// Glass card with a bar chart of calories over the range.
class _CalorieChartCard extends StatelessWidget {
  final List<FoodEntry> entries;
  final int days;

  const _CalorieChartCard({required this.entries, required this.days});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final reduceMotion = MediaQuery.of(context).disableAnimations;
    final buckets = _buckets(entries, days);
    final maxValue = buckets.fold<int>(
      1,
      (max, bucket) => bucket.$2 > max ? bucket.$2 : max,
    );
    final total = buckets.fold<int>(0, (sum, bucket) => sum + bucket.$2);
    final average = (total / days).round();

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calories',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '$average kcal/day',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final bucket in buckets)
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${bucket.$2}',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 9,
                              ),
                        ),
                        const SizedBox(height: 4),
                        AnimatedContainer(
                          duration: reduceMotion
                              ? Duration.zero
                              : const Duration(milliseconds: 600),
                          curve: Curves.easeOutCubic,
                          height: 140 * (bucket.$2 / maxValue).clamp(0.03, 1.0),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            gradient: colors.energyGradient,
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          bucket.$1,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontSize: 10,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One nutrient average row with the intake status dot.
class _NutrientRow extends StatelessWidget {
  final String label;
  final double value;
  final int dailyValue;
  final String unit;
  final Color statusColor;

  const _NutrientRow({
    required this.label,
    required this.value,
    required this.dailyValue,
    required this.unit,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: statusColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Divider(color: colors.glassBorder),
            ),
          ),
          Text(
            value.toStringAsFixed(0),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '/$dailyValue$unit',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

/// Weekly/monthly average rows for the key nutrients.
class _NutrientAverages extends StatelessWidget {
  final List<FoodEntry> entries;
  final int days;

  const _NutrientAverages({required this.entries, required this.days});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final summary = FoodLogSummary.fromEntries(entries);
    final divisor = days.toDouble();

    Color status(num value, int daily) =>
        value > daily ? colors.statusGood : colors.statusLow;

    Color satFatStatus(num value) =>
        value == 0 || value < saturatedFatDailyValue
        ? colors.statusGood
        : colors.statusHigh;

    Color sodiumStatus(num value) {
      if (value == 0) return colors.statusLow;
      if (value < sodiumDailyValue) return colors.statusGood;
      return colors.statusHigh;
    }

    return Column(
      children: [
        _NutrientRow(
          label: 'Protein',
          value: summary.protein / divisor,
          dailyValue: proteinDailyValue,
          unit: 'g',
          statusColor: status(summary.protein, proteinDailyValue),
        ),
        _NutrientRow(
          label: 'Dietary fiber',
          value: summary.dietaryFiber / divisor,
          dailyValue: dietaryFiberDailyValue,
          unit: 'g',
          statusColor: status(summary.dietaryFiber, dietaryFiberDailyValue),
        ),
        _NutrientRow(
          label: 'Potassium',
          value: summary.potassium / divisor,
          dailyValue: potassiumDailyValue,
          unit: 'mg',
          statusColor: status(summary.potassium, potassiumDailyValue),
        ),
        _NutrientRow(
          label: 'Vitamin A',
          value: summary.vitaminA / divisor,
          dailyValue: vitaminADailyValue,
          unit: 'mcg',
          statusColor: status(summary.vitaminA, vitaminADailyValue),
        ),
        _NutrientRow(
          label: 'Vitamin C',
          value: summary.vitaminC / divisor,
          dailyValue: vitaminCDailyValue,
          unit: 'mg',
          statusColor: status(summary.vitaminC, vitaminCDailyValue),
        ),
        _NutrientRow(
          label: 'Vitamin D',
          value: summary.vitaminD / divisor,
          dailyValue: vitaminDDailyValue,
          unit: 'mcg',
          statusColor: status(summary.vitaminD, vitaminDDailyValue),
        ),
        _NutrientRow(
          label: 'Calcium',
          value: summary.calcium / divisor,
          dailyValue: calciumDailyValue,
          unit: 'mg',
          statusColor: status(summary.calcium, calciumDailyValue),
        ),
        _NutrientRow(
          label: 'Iron',
          value: summary.iron / divisor,
          dailyValue: ironDailyValue,
          unit: 'mg',
          statusColor: status(summary.iron, ironDailyValue),
        ),
        _NutrientRow(
          label: 'Saturated fat',
          value: summary.saturatedFat / divisor,
          dailyValue: saturatedFatDailyValue,
          unit: 'g',
          statusColor: satFatStatus(summary.saturatedFat),
        ),
        _NutrientRow(
          label: 'Sodium',
          value: summary.sodium / divisor,
          dailyValue: sodiumDailyValue,
          unit: 'mg',
          statusColor: sodiumStatus(summary.sodium),
        ),
      ],
    );
  }
}
