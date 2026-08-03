import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/meal.dart';
import 'package:senzu_app/screens/food_tracker/ui/log_food.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/services/meal_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/empty_state.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';
import 'package:senzu_app/shared/widgets/glass_segmented.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Custom meal builder: edit the meal's food items, then log the whole meal
/// to a chosen day and meal in one tap.
class MealDetails extends ConsumerStatefulWidget {
  final String mealName;
  final String mealId;
  final DateTime? date;
  final MealType? initialMeal;

  const MealDetails({
    super.key,
    required this.mealName,
    required this.mealId,
    this.date,
    this.initialMeal,
  });

  @override
  ConsumerState<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends ConsumerState<MealDetails> {
  late final MealRepository _meals;
  late MealType? _meal;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _meals = context.repos.meals;
    _meal = widget.initialMeal;
  }

  void _openLogFood() {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => LogFood(
            date: widget.date ?? todayMidnight(),
            mealIdValue: widget.mealId,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(MealFoodItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Remove "${item.foodName}"?'),
        content: const Text('It will be removed from this meal.'),
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
      await _meals.deleteFoodItem(widget.mealId, item.id);
    }
  }

  /// Edits an item's portion in a bottom sheet; calories and macros are
  /// rescaled proportionally and persisted via `updateFoodItem`.
  Future<void> _editPortion(MealFoodItem item) async {
    var portion = item.portionSize.round();
    final messenger = ScaffoldMessenger.of(context);
    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    item.foodName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adjust the portion — totals update automatically.',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 20),
                  _PortionStepper(
                    value: portion,
                    onChange: (value) => setSheetState(() => portion = value),
                  ),
                  const SizedBox(height: 20),
                  GradientButton(
                    label: 'Save portion',
                    icon: Icons.check,
                    onPressed: () => Navigator.pop(sheetContext, true),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    if (saved != true || portion == item.portionSize.round()) return;

    final ratio = item.portionSize == 0 ? 0 : portion / item.portionSize;
    try {
      await _meals.updateFoodItem(widget.mealId, item.id, {
        'portionSize': portion,
        'calories': (item.calories * ratio).round(),
        'protein': (item.protein * ratio).round(),
        'totalFat': (item.totalFat * ratio).round(),
        'totalCarbohydrate': (item.totalCarbohydrate * ratio).round(),
      });
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Portion updated')),
        );
      }
    } on Object {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Could not update. Check your connection.'),
          ),
        );
      }
    }
  }

  Future<void> _logMeal() async {
    setState(() => _saving = true);
    final date = startOfDay(widget.date ?? DateTime.now());
    try {
      await _meals.updateFoodItemsForDate(widget.mealId, {
        'mealType': mealTypeToString(_meal),
        'weekNo': getWeekNumber(date),
        'month': cleanMonthFormat(date.toString()),
        'year': cleanYearFormat(date.toString()),
        'dateAdded': date,
      });
      await _meals.copyMealToFoodEntries(widget.mealId);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${widget.mealName} to ${_meal!.label}'),
          ),
        );
      }
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not add the meal. Check your connection and try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: Text(widget.mealName)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colors.textPrimary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.restaurant_outlined,
                    color: colors.textPrimary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mealName,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(
                      'Custom meal',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: GradientButton(
              label: 'Add food',
              icon: Icons.add,
              onPressed: _openLogFood,
            ),
          ),
          Expanded(
            child: ref
                .watch(foodItemsProvider(widget.mealId))
                .when(
                  data: (items) {
                    if (items.isEmpty) {
                      return const EmptyState(
                        message: 'No foods in this meal yet. Add some.',
                        icon: Icons.restaurant_outlined,
                      );
                    }
                    final totals = _MealTotals(items);
                    return ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                      children: [
                        _MealTotalsCard(totals: totals),
                        const SizedBox(height: 12),
                        for (final item in items)
                          GlassRow(
                            key: ValueKey<String>(item.id),
                            onTap: () => _editPortion(item),
                            onLongPress: () => _confirmDelete(item),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.foodName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge
                                            ?.copyWith(
                                              fontWeight: FontWeight.w600,
                                            ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        '${item.portionSize.toStringAsFixed(0)}g · '
                                        '${item.calories.toStringAsFixed(0)} kcal',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.labelSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: colors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('LOG TO', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 10),
                GlassSegmentedControl<MealType>(
                  segments: const [
                    GlassSegment<MealType>(MealType.breakfast, 'Breakfast'),
                    GlassSegment<MealType>(MealType.lunch, 'Lunch'),
                    GlassSegment<MealType>(MealType.snacks, 'Snacks'),
                    GlassSegment<MealType>(MealType.dinner, 'Dinner'),
                  ],
                  value: _meal,
                  onChanged: (meal) => setState(() => _meal = meal),
                ),
                const SizedBox(height: 12),
                GradientButton(
                  label: 'Add this meal to log',
                  icon: Icons.add,
                  loading: _saving,
                  onPressed: _meal == null ? null : _logMeal,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Aggregated totals for the meal's food items.
class _MealTotals {
  final int calories;
  final int protein;
  final int fat;
  final int carbs;

  _MealTotals(List<MealFoodItem> items)
    : calories = items.fold(
        0,
        (sum, item) => sum + item.calories.round(),
      ),
      protein = items.fold(0, (sum, item) => sum + item.protein.round()),
      fat = items.fold(0, (sum, item) => sum + item.totalFat.round()),
      carbs = items.fold(
        0,
        (sum, item) => sum + item.totalCarbohydrate.round(),
      );
}

/// Glass card showing the meal's calorie + macro totals.
class _MealTotalsCard extends StatelessWidget {
  final _MealTotals totals;

  const _MealTotalsCard({required this.totals});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GlassCard(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Meal totals',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              Text(
                '${totals.calories} kcal',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colors.energyEnd,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _TotalsChip(
                label: 'Protein',
                grams: totals.protein,
                color: colors.protein,
              ),
              _TotalsChip(
                label: 'Carbs',
                grams: totals.carbs,
                color: colors.carbs,
              ),
              _TotalsChip(
                label: 'Fat',
                grams: totals.fat,
                color: colors.fat,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TotalsChip extends StatelessWidget {
  final String label;
  final int grams;
  final Color color;

  const _TotalsChip({
    required this.label,
    required this.grams,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          '$label $grams g',
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

/// Glass pill quantity stepper (− 10g / + 10g).
class _PortionStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChange;

  const _PortionStepper({required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 56,
      decoration: colors.glassDecoration(),
      child: Row(
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: value > 0 ? () => onChange(value - 10) : null,
          ),
          Expanded(
            child: Text(
              '$value g',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _StepButton(icon: Icons.add, onTap: () => onChange(value + 10)),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.all(6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox.square(
            dimension: 44,
            child: Icon(
              icon,
              size: 20,
              color: onTap == null
                  ? colors.textSecondary.withValues(alpha: 0.4)
                  : colors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
