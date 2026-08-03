import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/screens/food_tracker/ui/log_food.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/hero_ring.dart';
import 'package:senzu_app/shared/widgets/macro_ring.dart';

/// Today tab: date navigation, the hero calorie ring, the macro-ring glass
/// card, and collapsible meal sections listing the day's logged foods.
///
/// Each meal section shows its calorie total in the header; tapping it
/// expands the foods logged to that meal (long-press to remove). The
/// floating add button opens a meal picker and drops you straight into
/// logging for that meal.
class DashboardTab extends ConsumerStatefulWidget {
  const DashboardTab({super.key});

  @override
  ConsumerState<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends ConsumerState<DashboardTab> {
  DateTime _date = todayMidnight();

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

  void _openLogFood(MealType meal) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => LogFood(date: _date, mealType: meal),
        ),
      ),
    );
  }

  /// Floating add button: pick a meal first so logging is scoped up front.
  Future<void> _pickMealAndLog() async {
    final meal = await showModalBottomSheet<MealType>(
      context: context,
      builder: (sheetContext) => _MealPickerSheet(),
    );
    if (meal == null) return;
    if (!mounted) return;
    _openLogFood(meal);
  }

  Future<void> _confirmDelete(FoodEntry entry, MealType meal) async {
    final foodLog = context.repos.foodLog;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Remove "${entry.foodName}"?'),
        content: Text(
          'It will be removed from your ${meal.label.toLowerCase()}.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Remove',
              style: TextStyle(
                color: context.appColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed ?? false) {
      await foodLog.deleteEntry(entry.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final goal = ref.watch(userDataProvider).value?.dailyCaloriesGoal ?? 2400;
    final entriesAsync = ref.watch(dayEntriesProvider(_date));

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
            entriesAsync.when(
              data: (entries) {
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
                            progress: summary.protein / proteinDailyValue,
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
                    for (final meal in MealType.values)
                      _MealSection(
                        mealType: meal,
                        entries: entries
                            .where((entry) => entry.mealType == meal)
                            .toList(),
                        onAdd: () => _openLogFood(meal),
                        onDelete: (entry) => _confirmDelete(entry, meal),
                      ),
                    // Legacy entries without a meal type still need a home.
                    if (entries.any((entry) => entry.mealType == null))
                      _MealSection(
                        mealType: MealType.dinner,
                        title: 'Other',
                        icon: Icons.restaurant_menu,
                        entries: entries
                            .where((entry) => entry.mealType == null)
                            .toList(),
                        onAdd: () => _openLogFood(MealType.dinner),
                        onDelete: (entry) =>
                            _confirmDelete(entry, MealType.dinner),
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
        ),
        Positioned(
          right: 24,
          bottom: 16,
          child: _AddFab(onPressed: _pickMealAndLog),
        ),
      ],
    );
  }
}

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

/// Collapsible glass card for one meal: header shows the total calories and
/// toggles the logged-food list underneath.
class _MealSection extends StatefulWidget {
  final MealType mealType;
  final List<FoodEntry> entries;
  final VoidCallback onAdd;
  final ValueChanged<FoodEntry> onDelete;

  /// Optional overrides for the catch-all "Other" section.
  final String? title;
  final IconData? icon;

  const _MealSection({
    required this.mealType,
    required this.entries,
    required this.onAdd,
    required this.onDelete,
    this.title,
    this.icon,
  });

  @override
  State<_MealSection> createState() => _MealSectionState();
}

class _MealSectionState extends State<_MealSection> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    // Sections with food start expanded; empty ones stay compact.
    _expanded = widget.entries.isNotEmpty;
  }

  @override
  void didUpdateWidget(_MealSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Auto-open when something new was logged to this meal; don't fight the
    // user if they deliberately collapsed it while entries are unchanged.
    if (widget.entries.length > oldWidget.entries.length) _expanded = true;
  }

  IconData get _icon => widget.icon ?? switch (widget.mealType) {
    MealType.breakfast => Icons.free_breakfast_outlined,
    MealType.lunch => Icons.lunch_dining_outlined,
    MealType.snacks => Icons.cookie_outlined,
    MealType.dinner => Icons.dinner_dining_outlined,
  };

  String get _title => widget.title ?? widget.mealType.label;

  int get _calories =>
      widget.entries.fold(0, (sum, entry) => sum + entry.calories);

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: colors.glassDecoration(),
          child: Column(
            children: [
              // Header row: icon, label, kcal, add, chevron.
              InkWell(
                onTap: () => setState(() => _expanded = !_expanded),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 12, 8, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors.textPrimary.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          _icon,
                          color: colors.textPrimary,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _title,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.entries.isEmpty
                                  ? 'Nothing logged'
                                  : '${widget.entries.length} '
                                        '${widget.entries.length == 1 ? 'item' : 'items'}',
                              style: Theme.of(context).textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '$_calories kcal',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onAdd,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: colors.energyEnd,
                            ),
                          ),
                        ),
                      ),
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: reduceMotion
                            ? Duration.zero
                            : const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: colors.textSecondary,
                        ),
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: reduceMotion
                    ? Duration.zero
                    : const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                alignment: Alignment.topCenter,
                child: _expanded
                    ? _MealItemsList(
                        entries: widget.entries,
                        mealType: widget.mealType,
                        onDelete: widget.onDelete,
                        onAdd: widget.onAdd,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The expanded body of a [_MealSection]: logged items (long-press to
/// remove) plus a full-width add action when the section is empty.
class _MealItemsList extends StatelessWidget {
  final List<FoodEntry> entries;
  final MealType mealType;
  final ValueChanged<FoodEntry> onDelete;
  final VoidCallback onAdd;

  const _MealItemsList({
    required this.entries,
    required this.mealType,
    required this.onDelete,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    if (entries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onAdd,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: colors.glassDecoration(radius: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: colors.energyEnd, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Add to ${mealType.label.toLowerCase()}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
      child: Column(
        children: [
          for (final entry in entries)
            _EntryTile(
              key: ValueKey<String>(entry.id),
              entry: entry,
              onDelete: () => onDelete(entry),
            ),
        ],
      ),
    );
  }
}

/// One logged-food row inside a meal section.
class _EntryTile extends StatelessWidget {
  final FoodEntry entry;
  final VoidCallback onDelete;

  const _EntryTile({super.key, required this.entry, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return InkWell(
      onLongPress: onDelete,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.energyEnd.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.foodName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    '${entry.portionSize.toStringAsFixed(0)}g',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Text(
              '${entry.calories} kcal',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.more_horiz,
              size: 18,
              color: colors.textSecondary.withValues(alpha: 0.6),
            ),
          ],
        ),
      ),
    );
  }
}

/// Bottom sheet listing the four meals; tapping one starts logging for it.
class _MealPickerSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    IconData icon(MealType meal) => switch (meal) {
      MealType.breakfast => Icons.free_breakfast_outlined,
      MealType.lunch => Icons.lunch_dining_outlined,
      MealType.snacks => Icons.cookie_outlined,
      MealType.dinner => Icons.dinner_dining_outlined,
    };

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add to a meal',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          for (final meal in MealType.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Colors.transparent,
                child: Ink(
                  decoration: colors.glassDecoration(radius: 20),
                  child: InkWell(
                    onTap: () => Navigator.pop(context, meal),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Icon(icon(meal), color: colors.textPrimary, size: 22),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              meal.label,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: colors.textSecondary,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
