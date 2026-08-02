import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/meal.dart';
import 'package:senzu_app/screens/food_tracker/ui/log_food.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/meal_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/empty_state.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';
import 'package:senzu_app/shared/widgets/glass_segmented.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Custom meal builder: edit the meal's food items, then log the whole meal
/// to a chosen day and meal in one tap.
class MealDetails extends StatefulWidget {
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
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  late final MealRepository _meals;
  late MealType? _meal;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _meals = context.read<MealRepository>();
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
    final uid = myUID(context);
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
      await _meals.deleteFoodItem(uid, widget.mealId, item.id);
    }
  }

  Future<void> _logMeal() async {
    setState(() => _saving = true);
    final uid = myUID(context);
    final date = startOfDay(widget.date ?? DateTime.now());
    try {
      await _meals.updateFoodItemsForDate(uid, widget.mealId, {
        'mealType': mealTypeToString(_meal),
        'weekNo': getWeekNumber(date),
        'month': cleanMonthFormat(date.toString()),
        'year': cleanYearFormat(date.toString()),
        'dateAdded': date,
      });
      await _meals.copyMealToFoodEntries(uid, widget.mealId);
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
            child: StreamBuilder<List<MealFoodItem>>(
              stream: _meals.foodItemsStream(myUID(context), widget.mealId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final items = snapshot.data!;
                if (items.isEmpty) {
                  return const EmptyState(
                    message: 'No foods in this meal yet. Add some.',
                    icon: Icons.restaurant_outlined,
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return GlassRow(
                      key: ValueKey<String>(item.id),
                      onLongPress: () => _confirmDelete(item),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                  '${item.calories.toStringAsFixed(0)} kcal · '
                                  '${item.portionSize.toStringAsFixed(0)}g',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${item.calories.toStringAsFixed(0)} kcal',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
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
