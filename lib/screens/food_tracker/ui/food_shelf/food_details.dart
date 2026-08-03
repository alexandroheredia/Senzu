import 'dart:async';

import 'package:flutter/material.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/services/entry_builder.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_segmented.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Food detail / portion entry: glass card with the food's name and macros,
/// a glass pill quantity stepper, a meal picker (when logging to a day), and
/// a gradient confirm button.
///
/// * [mealType] set → logs the food into that meal on [date].
/// * [mealIdValue] set → adds the food as an item of that custom meal.
class FoodDetails extends StatefulWidget {
  final ShelfFood food;
  final DateTime? date;
  final MealType? mealType;
  final String? mealIdValue;

  const FoodDetails({
    super.key,
    required this.food,
    this.date,
    this.mealType,
    this.mealIdValue,
  });

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  late final bool _isMealItemMode;
  late final bool _showMealPicker;
  late MealType? _meal;
  late int _portion;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _isMealItemMode = widget.mealIdValue != null;
    _meal = widget.mealType;
    _showMealPicker = !_isMealItemMode && _meal == null;
    _portion = widget.food.servingSize.round();
  }

  double get _ratio =>
      widget.food.servingSize == 0 ? 0 : _portion / widget.food.servingSize;

  int _scaled(double value) => (value * _ratio).round();

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      if (_isMealItemMode) {
        await context.repos.meals.addFoodItem(
          widget.mealIdValue!,
          _mealItemData(),
        );
      } else {
        unawaited(
          context.repos.shelf.incrementTimesAdded(widget.food.foodId),
        );
        await context.repos.foodLog.addEntry(_entryData());
      }
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added ${widget.food.foodName}')),
        );
      }
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not save. Check your connection and try again.',
            ),
          ),
        );
      }
    }
  }

  Map<String, dynamic> _entryData() => buildFoodEntry(
    food: widget.food,
    date: widget.date ?? DateTime.now(),
    meal: _meal,
    portion: _portion,
  );

  Map<String, dynamic> _mealItemData() => buildMealItem(
    food: widget.food,
    mealId: widget.mealIdValue!,
    portion: _portion,
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isMealItemMode ? 'Add to meal' : 'Food details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.food.foodName,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.food.brandName,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: colors.glassDecoration(radius: 14),
                      child: Text(
                        '${widget.food.calories.toStringAsFixed(0)} kcal · '
                        'per ${widget.food.servingSize.toStringAsFixed(0)}g',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'PORTION',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 10),
                  _PortionStepper(
                    value: _portion,
                    onChange: (value) => setState(() => _portion = value),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'MACROS',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 14),
                  _MacroBar(
                    label: 'Protein',
                    color: colors.protein,
                    grams: _scaled(widget.food.protein),
                    fraction: _percent(
                      _scaled(widget.food.protein),
                      proteinDailyValue,
                    ),
                  ),
                  _MacroBar(
                    label: 'Carbs',
                    color: colors.carbs,
                    grams: _scaled(widget.food.totalCarbohydrate),
                    fraction: _percent(
                      _scaled(widget.food.totalCarbohydrate),
                      totalCarbohydrateDailyValue,
                    ),
                  ),
                  _MacroBar(
                    label: 'Fat',
                    color: colors.fat,
                    grams: _scaled(widget.food.totalFat),
                    fraction: _percent(
                      _scaled(widget.food.totalFat),
                      totalFatDailyValue,
                    ),
                  ),
                  if (_showMealPicker) ...[
                    const SizedBox(height: 24),
                    Text(
                      'ADD TO',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
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
                  ],
                  const SizedBox(height: 28),
                  GradientButton(
                    label: _isMealItemMode ? 'Add to meal' : 'Add to log',
                    icon: Icons.add,
                    loading: _saving,
                    onPressed: (_isMealItemMode || _meal != null)
                        ? _save
                        : null,
                  ),
                  if (!_isMealItemMode && _meal == null) ...[
                    const SizedBox(height: 10),
                    Text(
                      'Pick a meal to log this food.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            _NutritionFacts(food: widget.food, ratio: _ratio),
          ],
        ),
      ),
    );
  }

  double _percent(int intake, num daily) =>
      daily <= 0 ? 0.0 : (intake / daily).clamp(0.0, 3.0);
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

/// One macro bar: label, colored track, gram count.
class _MacroBar extends StatelessWidget {
  final String label;
  final Color color;
  final int grams;

  /// 0..1 fraction of the daily value.
  final double fraction;

  const _MacroBar({
    required this.label,
    required this.color,
    required this.grams,
    required this.fraction,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          SizedBox(
            width: 64,
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: colors.textPrimary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: fraction.clamp(0.0, 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 44,
            child: Text(
              '$grams g',
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}

/// Collapsible nutrition facts panel, scaled to the chosen portion.
class _NutritionFacts extends StatefulWidget {
  final ShelfFood food;
  final double ratio;

  const _NutritionFacts({required this.food, required this.ratio});

  @override
  State<_NutritionFacts> createState() => _NutritionFactsState();
}

class _NutritionFactsState extends State<_NutritionFacts> {
  bool _expanded = false;

  int _scaled(double value) => (value * widget.ratio).round();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final food = widget.food;

    Widget row(
      String label, {
      required double value,
      String? unit,
      num? daily,
      bool indent = false,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            if (indent) const SizedBox(width: 18),
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Text(
              '${_scaled(value)}${unit ?? ''}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (daily != null) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: 40,
                child: Text(
                  '${(daily <= 0 ? 0 : value / daily * 100).round()}%',
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
          ],
        ),
      );
    }

    return GlassCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(28),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Nutrition facts',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expanded ? 0.5 : 0,
                    duration: MediaQuery.of(context).disableAnimations
                        ? Duration.zero
                        : const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.expand_more,
                      color: colors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  row(
                    'Calories',
                    value: food.calories,
                    unit: ' kcal',
                  ),
                  Divider(height: 16, color: colors.glassBorder),
                  row(
                    'Total fat',
                    value: food.totalFat,
                    unit: 'g',
                    daily: totalFatDailyValue,
                  ),
                  row(
                    'Saturated fat',
                    value: food.saturatedFat,
                    unit: 'g',
                    daily: saturatedFatDailyValue,
                    indent: true,
                  ),
                  row(
                    'Trans fat',
                    value: food.transFat,
                    unit: 'g',
                    indent: true,
                  ),
                  row(
                    'Cholesterol',
                    value: food.cholesterol,
                    unit: 'mg',
                    daily: cholesterolDailyValue,
                  ),
                  row(
                    'Sodium',
                    value: food.sodium,
                    unit: 'mg',
                    daily: sodiumDailyValue,
                  ),
                  Divider(height: 16, color: colors.glassBorder),
                  row(
                    'Total carbohydrate',
                    value: food.totalCarbohydrate,
                    unit: 'g',
                    daily: totalCarbohydrateDailyValue,
                  ),
                  row(
                    'Dietary fiber',
                    value: food.dietaryFiber,
                    unit: 'g',
                    daily: dietaryFiberDailyValue,
                    indent: true,
                  ),
                  row(
                    'Total sugars',
                    value: food.sugars,
                    unit: 'g',
                    indent: true,
                  ),
                  row(
                    'Added sugars',
                    value: food.addedSugars,
                    unit: 'g',
                    daily: addedSugarsDailyValue,
                    indent: true,
                  ),
                  row('Protein', value: food.protein, unit: 'g'),
                  Divider(height: 16, color: colors.glassBorder),
                  row(
                    'Vitamin D',
                    value: food.vitaminD,
                    unit: 'mcg',
                    daily: vitaminDDailyValue,
                  ),
                  row(
                    'Calcium',
                    value: food.calcium,
                    unit: 'mg',
                    daily: calciumDailyValue,
                  ),
                  row(
                    'Iron',
                    value: food.iron,
                    unit: 'mg',
                    daily: ironDailyValue,
                  ),
                  row(
                    'Potassium',
                    value: food.potassium,
                    unit: 'mg',
                    daily: potassiumDailyValue,
                  ),
                  row(
                    'Vitamin C',
                    value: food.vitaminC,
                    unit: 'mg',
                    daily: vitaminCDailyValue,
                  ),
                  row(
                    'Vitamin A',
                    value: food.vitaminA,
                    unit: 'mcg',
                    daily: vitaminADailyValue,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '* The % Daily Value (DV) tells you how much a nutrient in a '
                    'serving of food contributes to a daily diet. 2,000 calories a '
                    'day is used for general nutrition advice.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 10,
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
