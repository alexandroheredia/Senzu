import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/food_draft.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/screens/food_tracker/barcode/barcode_scanner_screen.dart';
import 'package:senzu_app/screens/food_tracker/barcode/nutrition_label_capture_screen.dart';
import 'package:senzu_app/screens/food_tracker/ui/add_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_details.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/services/entry_builder.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/random_id.dart';
import 'package:senzu_app/shared/widgets/empty_state.dart';
import 'package:senzu_app/shared/widgets/glass_input.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';

/// Log-food flow: search the shelf, quick-add frequent foods, or add a brand
/// new food via barcode / label capture.
///
/// * [mealType] set → foods are logged into that meal for [date].
/// * [mealIdValue] set → foods are added as items of that custom meal.
class LogFood extends ConsumerStatefulWidget {
  final DateTime date;
  final MealType? mealType;
  final String? mealIdValue;

  const LogFood({
    super.key,
    required this.date,
    this.mealType,
    this.mealIdValue,
  });

  @override
  ConsumerState<LogFood> createState() => _LogFoodState();
}

class _LogFoodState extends ConsumerState<LogFood> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  bool get _hasMealContext =>
      widget.mealType != null || widget.mealIdValue != null;

  Future<void> _openAddFood({FoodDraft? draft}) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AddFood(
          foodIdValue: generateRandomId(),
          initial: draft,
        ),
      ),
    );
  }

  Future<void> _openBarcodeScanner() async {
    final draft = await Navigator.of(context).push<FoodDraft>(
      MaterialPageRoute<FoodDraft>(
        builder: (context) => const BarcodeScannerScreen(),
      ),
    );
    if (draft == null || !mounted) return;
    await _openAddFood(draft: draft);
  }

  Future<void> _openLabelCapture() async {
    final draft = await Navigator.of(context).push<FoodDraft>(
      MaterialPageRoute<FoodDraft>(
        builder: (context) => const NutritionLabelCaptureScreen(),
      ),
    );
    if (draft == null || !mounted) return;
    await _openAddFood(draft: draft);
  }

  void _openFood(ShelfFood food) {
    unawaited(
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => FoodDetails(
            food: food,
            date: widget.date,
            mealType: widget.mealType,
            mealIdValue: widget.mealIdValue,
          ),
        ),
      ),
    );
  }

  /// One-tap log: adds the food at its serving size to the current meal
  /// (or to the custom meal), skipping the detail screen.
  Future<void> _quickAdd(ShelfFood food) async {
    final messenger = ScaffoldMessenger.of(context);
    final repos = context.repos;
    try {
      if (widget.mealIdValue != null) {
        await repos.meals.addFoodItem(
          widget.mealIdValue!,
          buildMealItem(
            food: food,
            mealId: widget.mealIdValue!,
            portion: food.servingSize.round(),
          ),
        );
      } else if (widget.mealType != null) {
        unawaited(repos.shelf.incrementTimesAdded(food.foodId));
        await repos.foodLog.addEntry(
          buildFoodEntry(
            food: food,
            date: widget.date,
            meal: widget.mealType,
            portion: food.servingSize.round(),
          ),
        );
      } else {
        _openFood(food);
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text('Added ${food.foodName}')),
      );
    } on Object {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Could not add. Check your connection and try again.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.mealIdValue != null ? 'Add to meal' : 'Log food'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: GlassInput(
              controller: _search,
              hint: 'Search your foods',
              leadingIcon: Icons.search,
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          if (widget.mealType != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 4, 24, 8),
              child: Text(
                'Logging to ${widget.mealType!.label}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.energyEnd,
                ),
              ),
            ),
          _QuickActions(
            onScanBarcode: _openBarcodeScanner,
            onScanLabel: _openLabelCapture,
            onAddManually: _openAddFood,
          ),
          _FrequentFoods(onQuickAdd: _quickAdd),
          Expanded(
            child: ref
                .watch(shelfStreamProvider)
                .when(
                  data: (foods) {
                    if (foods.isEmpty) {
                      return EmptyState(
                        message:
                            'Your shelf is empty. '
                            'Add a food first, then log it.',
                        actionLabel: 'Scan a barcode',
                        onAction: _openBarcodeScanner,
                      );
                    }

                    final query = _query.toLowerCase();
                    final filtered = query.isEmpty
                        ? foods
                        : foods
                              .where(
                                (food) =>
                                    food.foodName.toLowerCase().contains(
                                      query,
                                    ) ||
                                    food.brandName.toLowerCase().contains(
                                      query,
                                    ),
                              )
                              .toList();

                    if (filtered.isEmpty) {
                      return EmptyState(
                        message: 'No foods match "$_query".',
                        icon: Icons.search_off,
                      );
                    }

                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final food = filtered[index];
                        return GlassRow(
                          key: ValueKey<String>(food.id),
                          onTap: () => _openFood(food),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      food.foodName,
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
                                      food.brandName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.labelSmall,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${food.calories.toStringAsFixed(0)} kcal',
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                              if (_hasMealContext) ...[
                                const SizedBox(width: 4),
                                _QuickAddButton(
                                  onPressed: () => _quickAdd(food),
                                ),
                              ] else
                                const SizedBox(width: 4),
                              Icon(
                                Icons.chevron_right,
                                color: colors.textSecondary,
                                size: 20,
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (_, _) =>
                      const Center(child: CircularProgressIndicator()),
                ),
          ),
        ],
      ),
    );
  }
}

/// Row of quick actions: scan a barcode, capture a label, add manually.
class _QuickActions extends StatelessWidget {
  final VoidCallback onScanBarcode;
  final VoidCallback onScanLabel;
  final VoidCallback onAddManually;

  const _QuickActions({
    required this.onScanBarcode,
    required this.onScanLabel,
    required this.onAddManually,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Widget pill(IconData icon, String label, VoidCallback onTap) {
      return Expanded(
        child: Material(
          color: colors.glassFill,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: colors.energyEnd, size: 18),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
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
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Row(
        children: [
          pill(Icons.qr_code_scanner, 'Scan', onScanBarcode),
          const SizedBox(width: 10),
          pill(Icons.auto_awesome, 'Label', onScanLabel),
          const SizedBox(width: 10),
          pill(Icons.edit_outlined, 'Manual', onAddManually),
        ],
      ),
    );
  }
}

/// One-tap add button shown on shelf rows.
class _QuickAddButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _QuickAddButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(Icons.add_circle, size: 26, color: colors.energyEnd),
        ),
      ),
    );
  }
}

/// Horizontal strip of the user's most-logged foods for one-tap logging.
class _FrequentFoods extends ConsumerWidget {
  final ValueChanged<ShelfFood> onQuickAdd;

  const _FrequentFoods({required this.onQuickAdd});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final topAsync = ref.watch(topFoodsStreamProvider);

    return topAsync.when(
      data: (foods) {
        final frequent = foods.take(6).toList();
        if (frequent.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 6, 20, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FREQUENT',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 36,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: frequent.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final food = frequent[index];
                    return Material(
                      color: colors.glassFill,
                      borderRadius: BorderRadius.circular(18),
                      child: InkWell(
                        onTap: () => onQuickAdd(food),
                        borderRadius: BorderRadius.circular(18),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: Row(
                            children: [
                              Icon(
                                Icons.bolt,
                                color: colors.energyStart,
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                food.foodName,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                food.calories.toStringAsFixed(0),
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }
}
