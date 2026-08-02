import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/add_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_details.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/random_id.dart';
import 'package:senzu_app/shared/widgets/empty_state.dart';
import 'package:senzu_app/shared/widgets/glass_input.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';

/// Log-food flow: a glass search field over the user's shelf foods.
///
/// * [mealType] set → opened from a meal (AddToMeal): foods are logged into
///   that meal for [date].
/// * [mealIdValue] set → opened from a custom meal (MealDetails): foods are
///   added as items of that meal instead of the daily log.
class LogFood extends StatefulWidget {
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
  State<LogFood> createState() => _LogFoodState();
}

class _LogFoodState extends State<LogFood> {
  final TextEditingController _search = TextEditingController();
  String _query = '';
  late final ShelfRepository _shelf;

  @override
  void initState() {
    super.initState();
    _shelf = context.read<ShelfRepository>();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _openAddFood() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => AddFood(foodIdValue: generateRandomId()),
      ),
    );
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
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: GlassInput(
              controller: _search,
              hint: 'Search your foods',
              leadingIcon: Icons.search,
              onChanged: (value) => setState(() => _query = value.trim()),
            ),
          ),
          if (widget.mealType != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
              child: Text(
                'Logging to ${widget.mealType!.label}',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colors.energyEnd,
                ),
              ),
            ),
          Expanded(
            child: StreamBuilder<List<ShelfFood>>(
              stream: _shelf.shelfStream(myUID(context)),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final foods = snapshot.data!;
                if (foods.isEmpty) {
                  return EmptyState(
                    message: 'Your shelf is empty. '
                        'Add a food first, then log it.',
                    actionLabel: 'Add a food',
                    onAction: _openAddFood,
                  );
                }

                final query = _query.toLowerCase();
                final filtered = query.isEmpty
                    ? foods
                    : foods
                          .where(
                            (food) =>
                                food.foodName.toLowerCase().contains(query) ||
                                food.brandName.toLowerCase().contains(query),
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
            ),
          ),
        ],
      ),
    );
  }
}
