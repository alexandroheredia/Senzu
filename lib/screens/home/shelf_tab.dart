import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/meal.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/add_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_details.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/meal_details.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/meal_repository.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/random_id.dart';
import 'package:senzu_app/shared/widgets/empty_state.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_input.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';
import 'package:senzu_app/shared/widgets/glass_segmented.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

enum _ShelfSegment { food, meals, top }

/// Shelf tab: your saved foods, custom meals, and most-added foods, with a
/// glass search field up top.
class ShelfTab extends StatefulWidget {
  const ShelfTab({super.key});

  @override
  State<ShelfTab> createState() => _ShelfTabState();
}

class _ShelfTabState extends State<ShelfTab> {
  _ShelfSegment _segment = _ShelfSegment.food;
  final TextEditingController _search = TextEditingController();
  String _query = '';
  late final ShelfRepository _shelf;
  late final MealRepository _meals;

  @override
  void initState() {
    super.initState();
    _shelf = context.read<ShelfRepository>();
    _meals = context.read<MealRepository>();
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

  Future<void> _openCreateMeal() async {
    final controller = TextEditingController();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'New meal',
                  style: Theme.of(sheetContext).textTheme.headlineMedium,
                ),
                const SizedBox(height: 16),
                GlassInput(
                  controller: controller,
                  hint: 'Meal name',
                  leadingIcon: Icons.restaurant_outlined,
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                GradientButton(
                  label: 'Create meal',
                  icon: Icons.add,
                  onPressed: () async {
                    final name = controller.text.trim();
                    if (name.isEmpty) return;
                    await _meals.createMeal(
                      myUID(context),
                      generateRandomId(),
                      name,
                    );
                    navigator.pop();
                    messenger.showSnackBar(
                      SnackBar(content: Text('Created "$name"')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    controller.dispose();
  }

  Future<void> _confirmDelete({
    required String title,
    required VoidCallback onConfirm,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
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
    if (confirmed ?? false) onConfirm();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Text(
                'Food shelf',
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: GlassInput(
                controller: _search,
                hint: 'Search your foods',
                leadingIcon: Icons.search,
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GlassSegmentedControl<_ShelfSegment>(
                segments: const [
                  GlassSegment<_ShelfSegment>(_ShelfSegment.food, 'Food'),
                  GlassSegment<_ShelfSegment>(_ShelfSegment.meals, 'Meals'),
                  GlassSegment<_ShelfSegment>(_ShelfSegment.top, 'Top'),
                ],
                value: _segment,
                onChanged: (value) => setState(() => _segment = value),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(child: _body()),
          ],
        ),
        Positioned(
          right: 24,
          bottom: 24,
          child: _ShelfFab(onPressed: _openAddFood),
        ),
      ],
    );
  }

  Widget _body() {
    return switch (_segment) {
      _ShelfSegment.food => _foodList(),
      _ShelfSegment.meals => _mealsList(),
      _ShelfSegment.top => _topFoodsList(),
    };
  }

  Widget _foodList() {
    return StreamBuilder<List<ShelfFood>>(
      stream: _shelf.shelfStream(myUID(context)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final foods = snapshot.data!;
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

        if (foods.isEmpty) {
          return const EmptyState(
            message: 'Your shelf is empty. '
                'Tap + to add your first food.',
            icon: Icons.kitchen_outlined,
          );
        }
        if (filtered.isEmpty) {
          return EmptyState(
            message: 'No foods match "$_query".',
            icon: Icons.search_off,
          );
        }

        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final food = filtered[index];
            return GlassRow(
              key: ValueKey<String>(food.id),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => FoodDetails(
                    food: food,
                    date: todayMidnight(),
                  ),
                ),
              ),
              onLongPress: () => _confirmDelete(
                title: 'Remove "${food.foodName}" from your shelf?',
                onConfirm: () => _shelf.deleteFood(
                  myUID(context),
                  food.foodId,
                ),
              ),
              child: _FoodRowContent(
                name: food.foodName,
                subtitle: food.brandName,
                trailing: '${food.calories.toStringAsFixed(0)} kcal',
              ),
            );
          },
        );
      },
    );
  }

  Widget _mealsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: GradientButton(
            label: 'New meal',
            icon: Icons.add,
            onPressed: _openCreateMeal,
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Meal>>(
            stream: _meals.mealsStream(myUID(context)),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final meals = snapshot.data!;
              if (meals.isEmpty) {
                return const EmptyState(
                  message: 'No custom meals yet. '
                      'Build one to log it in one tap.',
                  icon: Icons.restaurant_outlined,
                );
              }
              return ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  return GlassRow(
                    key: ValueKey<String>(meal.id),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => MealDetails(
                          mealName: meal.mealName,
                          mealId: meal.mealId,
                          date: todayMidnight(),
                        ),
                      ),
                    ),
                    child: _FoodRowContent(
                      name: meal.mealName,
                      subtitle: 'Custom meal',
                      trailing: null,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _topFoodsList() {
    return StreamBuilder<List<ShelfFood>>(
      stream: _shelf.topFoodsStream(myUID(context)),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final foods = snapshot.data!;
        if (foods.isEmpty) {
          return const EmptyState(
            message: 'Foods you log often will show up here.',
            icon: Icons.emoji_events_outlined,
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: foods.length,
          itemBuilder: (context, index) {
            final food = foods[index];
            final rank = index + 1;
            return GlassRow(
              key: ValueKey<String>(food.id),
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (context) => FoodDetails(
                    food: food,
                    date: todayMidnight(),
                  ),
                ),
              ),
              child: _FoodRowContent(
                name: food.foodName,
                subtitle: food.brandName,
                trailing: rank <= 3 ? '$rank · ${food.timesAdded}x' : '${food.timesAdded}x',
              ),
            );
          },
        );
      },
    );
  }
}

/// Shared row content for shelf lists.
class _FoodRowContent extends StatelessWidget {
  final String name;
  final String subtitle;
  final String? trailing;

  const _FoodRowContent({
    required this.name,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 12),
          Text(trailing!, style: Theme.of(context).textTheme.labelSmall),
        ],
        const SizedBox(width: 4),
        Icon(Icons.chevron_right, color: colors.textSecondary, size: 20),
      ],
    );
  }
}

class _ShelfFab extends StatelessWidget {
  final VoidCallback onPressed;

  const _ShelfFab({required this.onPressed});

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
