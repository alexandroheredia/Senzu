import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/services/calorie_calculator.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_input.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Daily calorie goal + macro targets editor.
class NutritionGoals extends ConsumerStatefulWidget {
  const NutritionGoals({super.key});

  @override
  ConsumerState<NutritionGoals> createState() => _NutritionGoalsState();
}

class _NutritionGoalsState extends ConsumerState<NutritionGoals> {
  String _calorieText = '';
  String _proteinText = '';
  String _carbsText = '';
  String _fatText = '';
  bool _savingCalories = false;
  bool _savingMacros = false;

  Future<void> _updateCalories(int current) async {
    final value = int.tryParse(_calorieText);
    final goal = value ?? current;
    if (value == null && _calorieText.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a whole number of calories')),
      );
      return;
    }
    setState(() => _savingCalories = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.repos.user.updateDailyCaloriesGoal(goal);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Daily goal updated')),
      );
    } on Object {
      if (mounted) {
        setState(() => _savingCalories = false);
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not update the goal')),
        );
      }
    }
  }

  Future<void> _updateMacros() async {
    final messenger = ScaffoldMessenger.of(context);
    final protein = int.tryParse(_proteinText);
    final carbs = int.tryParse(_carbsText);
    final fat = int.tryParse(_fatText);
    if (protein == null || carbs == null || fat == null) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Enter whole gram amounts for macros')),
      );
      return;
    }
    setState(() => _savingMacros = true);
    try {
      await context.repos.user.updateMacroGoals(
        proteinGoalG: protein,
        carbGoalG: carbs,
        fatGoalG: fat,
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Macro targets updated')),
      );
    } on Object {
      if (mounted) {
        setState(() => _savingMacros = false);
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not update the macros')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition goals')),
      body: ref
          .watch(userDataProvider)
          .when(
            data: (user) {
              final goal = user.dailyCaloriesGoal;
              final suggested = _suggestedGoal(user);

              return ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  Text(
                    'Daily calorie goal',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is what the ring on your dashboard fills toward.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'KCAL / DAY',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                key: ValueKey<int>(goal),
                                initialValue: '$goal',
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _calorieText = value,
                                textAlign: TextAlign.center,
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineMedium,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'kcal',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                        if (suggested != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            'Suggested for you: $suggested kcal',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(color: colors.energyEnd),
                          ),
                        ],
                        const SizedBox(height: 20),
                        GradientButton(
                          label: 'Update goal',
                          icon: Icons.check,
                          loading: _savingCalories,
                          onPressed: () => _updateCalories(goal),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Macro targets',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your dashboard macro rings fill toward these.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: GlassInput(
                                key: ValueKey<int>(user.proteinGoalG),
                                initialValue: user.proteinGoalG == 0
                                    ? ''
                                    : '${user.proteinGoalG}',
                                hint: 'g',
                                label: 'Protein',
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _proteinText = value,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GlassInput(
                                key: ValueKey<int>(user.carbGoalG),
                                initialValue: user.carbGoalG == 0
                                    ? ''
                                    : '${user.carbGoalG}',
                                hint: 'g',
                                label: 'Carbs',
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _carbsText = value,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GlassInput(
                                key: ValueKey<int>(user.fatGoalG),
                                initialValue: user.fatGoalG == 0
                                    ? ''
                                    : '${user.fatGoalG}',
                                hint: 'g',
                                label: 'Fat',
                                keyboardType: TextInputType.number,
                                onChanged: (value) => _fatText = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        GradientButton(
                          label: 'Save macros',
                          icon: Icons.check,
                          loading: _savingMacros,
                          onPressed: _updateMacros,
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => const Center(child: CircularProgressIndicator()),
          ),
    );
  }

  /// The suggested calorie goal from the user's body metrics, or null when
  /// the metrics aren't complete enough to compute one.
  int? _suggestedGoal(AppUser user) {
    if (user.heightCm <= 0 || user.weightKg <= 0 || user.ageYears <= 0) {
      return null;
    }
    final tdee = totalDailyEnergyExpenditure(
      sex: user.sex,
      weightKg: user.weightKg,
      heightCm: user.heightCm,
      ageYears: user.ageYears,
      activityLevel: user.activityLevel,
    );
    return suggestedCalorieGoal(tdee: tdee);
  }
}
