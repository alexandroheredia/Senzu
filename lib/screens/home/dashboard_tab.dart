import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/screens/food_tracker/add_meal_widgets/add_to_meal.dart';
import 'package:senzu_app/screens/food_tracker/ui/log_food.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/services/user_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';
import 'package:senzu_app/shared/widgets/hero_ring.dart';
import 'package:senzu_app/shared/widgets/macro_ring.dart';

/// Today tab: date navigation, the hero calorie ring, the macro-ring glass
/// card, and the day's meals. The floating add button logs straight into the
/// selected day.
class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  DateTime _date = todayMidnight();
  late final FoodLogRepository _foodLog;

  @override
  void initState() {
    super.initState();
    _foodLog = context.read<FoodLogRepository>();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = startOfDay(picked));
  }

  void _shiftDate(int days) {
    final next = _date.add(Duration(days: days));
    if (next.isAfter(todayMidnight())) return;
    setState(() => _date = next);
  }

  void _openMeal(MealType mealType) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) =>
              AddToMeal(mealType: mealType, selectedDateValue: _date),
        ),
      ),
    );
  }

  void _openLogFood() {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(builder: (context) => LogFood(date: _date)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final uid = myUID(context);
    if (uid.isEmpty) return const SizedBox.shrink();

    return Stack(
      children: [
        ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
          children: [
            _DateNav(
              date: _date,
              onPick: _pickDate,
              onShift: _shiftDate,
            ),
            const SizedBox(height: 28),
            StreamBuilder<AppUser>(
              stream: UserRepository(uid: uid).userData,
              builder: (context, userSnapshot) {
                final goal = userSnapshot.data?.dailyCaloriesGoal ?? 2400;
                return StreamBuilder<List<FoodEntry>>(
                  stream: _foodLog.dayEntries(uid, _date),
                  builder: (context, entrySnapshot) {
                    if (!entrySnapshot.hasData) {
                      return const SizedBox(
                        height: 420,
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final entries = entrySnapshot.data!;
                    final summary = FoodLogSummary.fromEntries(entries);
                    final intake = summary.totalCalories;
                    final remaining = goal - intake > 0 ? goal - intake : 0;

                    return Column(
                      children: [
                        HeroRing(
                          progress: goal > 0 ? intake / goal : 0,
                          remaining: remaining,
                          intake: intake,
                          goal: goal,
                        ),
                        const SizedBox(height: 28),
                        GlassCard(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24,
                            horizontal: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              MacroRing(
                                color: colors.carbs,
                                progress:
                                    summary.totalCarbohydrate /
                                    totalCarbohydrateDailyValue,
                                percentLabel:
                                    '${(summary.totalCarbohydrate / totalCarbohydrateDailyValue * 100).round()}%',
                                label: 'Carbs',
                                amount: '${summary.totalCarbohydrate}g',
                              ),
                              MacroRing(
                                color: colors.protein,
                                progress:
                                    summary.protein / proteinDailyValue,
                                percentLabel:
                                    '${(summary.protein / proteinDailyValue * 100).round()}%',
                                label: 'Protein',
                                amount: '${summary.protein}g',
                              ),
                              MacroRing(
                                color: colors.fat,
                                progress: summary.totalFat / totalFatDailyValue,
                                percentLabel:
                                    '${(summary.totalFat / totalFatDailyValue * 100).round()}%',
                                label: 'Fat',
                                amount: '${summary.totalFat}g',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Text(
                          'Meals',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 14),
                        for (final meal in MealType.values)
                          _MealRow(
                            mealType: meal,
                            calories: mealCalories(entries, meal),
                            onTap: () => _openMeal(meal),
                          ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
        Positioned(
          right: 24,
          bottom: 16,
          child: _AddFab(onPressed: _openLogFood),
        ),
      ],
    );
  }
}

/// Sum of calories for one meal type across [entries].
int mealCalories(List<FoodEntry> entries, MealType meal) =>
    entries
        .where((entry) => entry.mealType == meal)
        .fold(0, (sum, entry) => sum + entry.calories);

/// Glass date-navigation pill: back arrow, tappable date label, forward arrow
/// (disabled once we reach today).
class _DateNav extends StatelessWidget {
  final DateTime date;
  final VoidCallback onPick;
  final ValueChanged<int> onShift;

  const _DateNav({
    required this.date,
    required this.onPick,
    required this.onShift,
  });

  String _label() {
    final difference = DateTime.now().difference(date);
    if (difference.inDays <= 0) return 'Today';
    if (difference.inDays == 1) return 'Yesterday';
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final atToday = !date.isBefore(todayMidnight());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: colors.glassDecoration(),
      child: Row(
        children: [
          IconButton(
            onPressed: () => onShift(-1),
            icon: const Icon(Icons.chevron_left, size: 26),
          ),
          Expanded(
            child: InkWell(
              onTap: onPick,
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  _label(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          if (atToday)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Icon(Icons.chevron_right, size: 26),
            )
          else
            IconButton(
              onPressed: () => onShift(1),
              icon: const Icon(Icons.chevron_right, size: 26),
            ),
        ],
      ),
    );
  }
}

/// One meal row in the dashboard list.
class _MealRow extends StatelessWidget {
  final MealType mealType;
  final int calories;
  final VoidCallback onTap;

  const _MealRow({
    required this.mealType,
    required this.calories,
    required this.onTap,
  });

  IconData get _icon => switch (mealType) {
    MealType.breakfast => Icons.free_breakfast_outlined,
    MealType.lunch => Icons.lunch_dining_outlined,
    MealType.snacks => Icons.cookie_outlined,
    MealType.dinner => Icons.dinner_dining_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GlassRow(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: colors.textPrimary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(_icon, color: colors.textPrimary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mealType.label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '$calories kcal',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: colors.textSecondary),
        ],
      ),
    );
  }
}

/// Floating gradient add button, bottom-right.
class _AddFab extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddFab({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: Ink(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: colors.energyGradient,
          boxShadow: colors.energyGlow(blur: 28, opacity: 0.45),
        ),
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Icon(Icons.add, color: colors.bgBase, size: 30),
        ),
      ),
    );
  }
}
