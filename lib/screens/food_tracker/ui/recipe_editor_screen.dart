import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/recipe.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/random_id.dart';
import 'package:senzu_app/shared/widgets/empty_state.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_input.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Recipe editor: name, servings, ingredients (picked from the shelf with a
/// gram amount each), and a live per-serving nutrition preview.
///
/// [initial] set → edit mode. Otherwise a new recipe is created on save.
class RecipeEditorScreen extends ConsumerStatefulWidget {
  final Recipe? initial;

  const RecipeEditorScreen({super.key, this.initial});

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  late final String _recipeId;
  late final TextEditingController _name;
  late int _servings;
  late final List<RecipeIngredient> _ingredients;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _recipeId = initial?.id ?? generateRandomId();
    _name = TextEditingController(text: initial?.name ?? '');
    _servings = initial?.servings ?? 1;
    _ingredients = [...?initial?.ingredients];
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Recipe get _draft => Recipe(
    id: _recipeId,
    name: _name.text.trim(),
    servings: _servings,
    ingredients: _ingredients,
  );

  /// Adds a shelf food as an ingredient. Grams default to the food's own
  /// serving size; per-100g nutrition is derived from it so the math is
  /// exact regardless of what the food's serving is.
  void _addIngredient(ShelfFood food) {
    final per100g = food.servingSize <= 0
        ? 0.0
        : 100.0 / food.servingSize;
    setState(() {
      _ingredients.add(
        RecipeIngredient(
          foodId: food.foodId,
          name: food.foodName,
          grams: food.servingSize > 0 ? food.servingSize : 100,
          calories: food.calories * per100g,
          protein: food.protein * per100g,
          totalFat: food.totalFat * per100g,
          totalCarbohydrate: food.totalCarbohydrate * per100g,
        ),
      );
    });
  }

  Future<void> _pickIngredient() async {
    final picked = await showModalBottomSheet<ShelfFood>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return _IngredientPicker(
          onPicked: (food) => Navigator.pop(sheetContext, food),
        );
      },
    );
    if (picked != null && mounted) _addIngredient(picked);
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Give the recipe a name')),
      );
      return;
    }
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add at least one ingredient')),
      );
      return;
    }
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final repos = context.repos;
    try {
      if (widget.initial == null) {
        await repos.recipes.create(_draft);
      } else {
        await repos.recipes.update(_draft);
      }
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            widget.initial == null ? 'Recipe created' : 'Recipe updated',
          ),
        ),
      );
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Could not save the recipe. '
              'Check your connection and try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final recipe = _draft;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initial == null ? 'New recipe' : 'Edit recipe'),
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
                  GlassInput(
                    controller: _name,
                    hint: 'e.g. Protein pancakes',
                    label: 'Recipe name',
                    leadingIcon: Icons.menu_book_outlined,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SERVINGS',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 8),
                  _ServingsStepper(
                    value: _servings,
                    onChange: (value) => setState(() => _servings = value),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'INGREDIENTS',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 8),
            if (_ingredients.isEmpty)
              const EmptyState(
                message: 'No ingredients yet. Add foods from your shelf.',
                icon: Icons.add_circle_outline,
              )
            else
              for (final (index, ingredient) in _ingredients.indexed)
                _IngredientRow(
                  key: ValueKey<String>('$index-${ingredient.foodId}'),
                  ingredient: ingredient,
                  onGramsChanged: (grams) => setState(() {
                    _ingredients[index] = RecipeIngredient(
                      foodId: ingredient.foodId,
                      name: ingredient.name,
                      grams: grams,
                      calories: ingredient.calories,
                      protein: ingredient.protein,
                      totalFat: ingredient.totalFat,
                      totalCarbohydrate: ingredient.totalCarbohydrate,
                    );
                  }),
                  onRemove: () => setState(() => _ingredients.removeAt(index)),
                ),
            const SizedBox(height: 12),
            GradientButton(
              label: 'Add ingredient',
              icon: Icons.add,
              onPressed: _pickIngredient,
            ),
            const SizedBox(height: 16),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Per serving',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _PerServingStat(
                        label: 'Calories',
                        value: '${recipe.caloriesPerServing}',
                        unit: 'kcal',
                        color: colors.energyEnd,
                      ),
                      _PerServingStat(
                        label: 'Protein',
                        value: '${recipe.proteinPerServing}',
                        unit: 'g',
                        color: colors.protein,
                      ),
                      _PerServingStat(
                        label: 'Carbs',
                        value: '${recipe.carbsPerServing}',
                        unit: 'g',
                        color: colors.carbs,
                      ),
                      _PerServingStat(
                        label: 'Fat',
                        value: '${recipe.fatPerServing}',
                        unit: 'g',
                        color: colors.fat,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            GradientButton(
              label: widget.initial == null ? 'Create recipe' : 'Save changes',
              icon: Icons.check,
              loading: _saving,
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }
}

/// Servings quantity stepper.
class _ServingsStepper extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChange;

  const _ServingsStepper({required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      height: 48,
      decoration: colors.glassDecoration(radius: 24),
      child: Row(
        children: [
          IconButton(
            onPressed: value > 1 ? () => onChange(value - 1) : null,
            icon: const Icon(Icons.remove, size: 18),
          ),
          Expanded(
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          IconButton(
            onPressed: () => onChange(value + 1),
            icon: const Icon(Icons.add, size: 18),
          ),
        ],
      ),
    );
  }
}

/// One ingredient row with a gram input and remove action.
class _IngredientRow extends StatelessWidget {
  final RecipeIngredient ingredient;
  final ValueChanged<double> onGramsChanged;
  final VoidCallback onRemove;

  const _IngredientRow({
    super.key,
    required this.ingredient,
    required this.onGramsChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return GlassRow(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ingredient.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${ingredient.contributionCalories.round()} kcal · '
                  '${ingredient.contributionProtein.round()}p · '
                  '${ingredient.contributionCarbs.round()}c · '
                  '${ingredient.contributionFat.round()}f',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: TextFormField(
              initialValue: ingredient.grams.toStringAsFixed(0),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
              ],
              onChanged: (value) {
                final grams = double.tryParse(value);
                if (grams != null && grams > 0) onGramsChanged(grams);
              },
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Text('g', style: Theme.of(context).textTheme.labelSmall),
          IconButton(
            onPressed: onRemove,
            icon: Icon(Icons.close, size: 18, color: colors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _PerServingStat extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _PerServingStat({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
          ),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}

/// Bottom sheet that searches the shelf and returns a picked food.
class _IngredientPicker extends ConsumerStatefulWidget {
  final ValueChanged<ShelfFood> onPicked;

  const _IngredientPicker({required this.onPicked});

  @override
  ConsumerState<_IngredientPicker> createState() => _IngredientPickerState();
}

class _IngredientPickerState extends ConsumerState<_IngredientPicker> {
  final TextEditingController _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Add ingredient',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          GlassInput(
            controller: _search,
            hint: 'Search your foods',
            leadingIcon: Icons.search,
            autofocus: true,
            onChanged: (value) => setState(() => _query = value.trim()),
          ),
          const SizedBox(height: 12),
          Flexible(
            child: ref
                .watch(shelfStreamProvider)
                .when(
                  data: (foods) {
                    final query = _query.toLowerCase();
                    final filtered = query.isEmpty
                        ? foods
                        : foods
                              .where(
                                (food) => food.foodName
                                    .toLowerCase()
                                    .contains(query),
                              )
                              .toList();
                    if (filtered.isEmpty) {
                      return const EmptyState(
                        message: 'No foods match. Add foods to your shelf '
                            'first.',
                        icon: Icons.search_off,
                      );
                    }
                    return ListView(
                      shrinkWrap: true,
                      children: [
                        for (final food in filtered)
                          GlassRow(
                            key: ValueKey<String>(food.id),
                            onTap: () => widget.onPicked(food),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
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
                                ),
                                Text(
                                  '${food.calories.toStringAsFixed(0)} kcal',
                                  style: Theme.of(context).textTheme.labelSmall,
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
        ],
      ),
    );
  }
}
