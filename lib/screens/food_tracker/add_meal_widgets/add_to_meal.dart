import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/screens/food_tracker/ui/log_food.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/empty_state.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Per-meal logging screen: the meal's entries for the selected day, an
/// "Add food" action that opens the search flow, and a Done button.
class AddToMeal extends StatefulWidget {
  final DateTime selectedDateValue;
  final MealType mealType;

  const AddToMeal({
    super.key,
    required this.selectedDateValue,
    required this.mealType,
  });

  @override
  State<AddToMeal> createState() => _AddToMealState();
}

class _AddToMealState extends State<AddToMeal> {
  late final FoodLogRepository _foodLog;

  @override
  void initState() {
    super.initState();
    _foodLog = context.read<FoodLogRepository>();
  }

  void _openLogFood() {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => LogFood(
            date: widget.selectedDateValue,
            mealType: widget.mealType,
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(FoodEntry entry) async {
    final uid = myUID(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Remove "${entry.foodName}"?'),
        content: Text(
          'It will be removed from your ${widget.mealType.label.toLowerCase()}.',
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
      await _foodLog.deleteEntry(uid, entry.id);
    }
  }

  String get _dateLabel {
    final difference = DateTime.now().difference(widget.selectedDateValue);
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
    final date = widget.selectedDateValue;
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  IconData get _mealIcon => switch (widget.mealType) {
    MealType.breakfast => Icons.free_breakfast_outlined,
    MealType.lunch => Icons.lunch_dining_outlined,
    MealType.snacks => Icons.cookie_outlined,
    MealType.dinner => Icons.dinner_dining_outlined,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: Text(widget.mealType.label)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: colors.textPrimary.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(_mealIcon, color: colors.textPrimary, size: 24),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.mealType.label,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Text(_dateLabel, style: Theme.of(context).textTheme.labelSmall),
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
            child: StreamBuilder<List<FoodEntry>>(
              stream: _foodLog.mealEntries(
                myUID(context),
                widget.mealType,
                widget.selectedDateValue,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final entries = snapshot.data!;
                if (entries.isEmpty) {
                  return const EmptyState(
                    message: 'No meals logged yet. Add your first one.',
                    icon: Icons.restaurant_outlined,
                  );
                }
                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return GlassRow(
                      key: ValueKey<String>(entry.id),
                      onLongPress: () => _confirmDelete(entry),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  entry.foodName,
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
                                  '${entry.calories} kcal · '
                                  '${entry.portionSize.toStringAsFixed(0)}g',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelSmall,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${entry.calories} kcal',
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
            child: GradientButton(
              label: 'Done',
              icon: Icons.check,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
