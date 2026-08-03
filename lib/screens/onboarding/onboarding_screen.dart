import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/services/calorie_calculator.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_input.dart';
import 'package:senzu_app/shared/widgets/glass_segmented.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// First-run onboarding: collects the profile data the rest of the app needs
/// (name, sex, activity, body metrics) and suggests a calorie goal + macro
/// targets computed from them.
///
/// Shown once per user (see the `Home` shell); saves via the user repository
/// (profile, calorie goal, macros) and marks onboarding complete.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _age = TextEditingController();
  final _goal = TextEditingController();
  final _protein = TextEditingController();
  final _carbs = TextEditingController();
  final _fat = TextEditingController();

  String _sex = 'male';
  String _activity = 'sedentary';
  bool _saving = false;
  bool _goalTouched = false;
  bool _macrosTouched = false;

  @override
  void dispose() {
    _name.dispose();
    _height.dispose();
    _weight.dispose();
    _age.dispose();
    _goal.dispose();
    _protein.dispose();
    _carbs.dispose();
    _fat.dispose();
    super.dispose();
  }

  double _parse(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  /// Recomputes the suggested goal and macros whenever the body metrics or
  /// activity change — unless the user has manually edited the goal.
  void _recompute() {
    if (_goalTouched) return;
    final tdee = totalDailyEnergyExpenditure(
      sex: _sex,
      weightKg: _parse(_weight),
      heightCm: _parse(_height),
      ageYears: _parse(_age).toInt(),
      activityLevel: _activity,
    );
    final goal = suggestedCalorieGoal(tdee: tdee);
    if (goal > 0) {
      _goal.text = '$goal';
      if (!_macrosTouched) _fillMacros(goal);
    }
  }

  void _fillMacros(int calories) {
    final macros = suggestedMacros(calories);
    _protein.text = '${macros.protein}';
    _carbs.text = '${macros.carbs}';
    _fat.text = '${macros.fat}';
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    final user = context.repos.user;
    try {
      final goal = _parse(_goal).round();
      await user.updateProfile(
        username: _name.text.trim(),
        sex: _sex,
        activityLevel: _activity,
        heightCm: _parse(_height),
        weightKg: _parse(_weight),
        ageYears: _parse(_age).toInt(),
      );
      await user.updateDailyCaloriesGoal(goal);
      await user.updateMacroGoals(
        proteinGoalG: _parse(_protein).round(),
        carbGoalG: _parse(_carbs).round(),
        fatGoalG: _parse(_fat).round(),
      );
      await user.completeOnboarding();
      // The Home shell watches onboardingComplete and swaps to the tabs.
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Could not save your profile. '
              'Check your connection and try again.',
            ),
          ),
        );
      }
    }
  }

  String? _requiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (double.tryParse(value.trim()) == null) return 'Enter a number';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 40),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Set up your profile',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This powers your calorie goal. You can change it '
                    'anytime in Profile.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'About you',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 16),
                        GlassInput(
                          controller: _name,
                          hint: 'Your name',
                          leadingIcon: Icons.person_outline,
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                              ? 'Enter your name'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        _SegmentedPicker<String>(
                          label: 'Sex',
                          segments: const [
                            GlassSegment<String>('male', 'Male'),
                            GlassSegment<String>('female', 'Female'),
                          ],
                          value: _sex,
                          onChanged: (value) =>
                              setState(() => _sex = value),
                        ),
                        const SizedBox(height: 16),
                        _SegmentedPicker<String>(
                          label: 'Activity level',
                          segments: const [
                            GlassSegment<String>(
                              'sedentary',
                              'Sedentary',
                            ),
                            GlassSegment<String>(
                              'slightly_active',
                              'Light',
                            ),
                            GlassSegment<String>('active', 'Active'),
                            GlassSegment<String>(
                              'very_active',
                              'Very active',
                            ),
                          ],
                          value: _activity,
                          onChanged: (value) =>
                              setState(() => _activity = value),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GlassInput(
                                controller: _height,
                                hint: 'cm',
                                label: 'Height',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.]'),
                                  ),
                                ],
                                onChanged: (_) => setState(_recompute),
                                validator: _requiredNumber,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GlassInput(
                                controller: _weight,
                                hint: 'kg',
                                label: 'Weight',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp('[0-9.]'),
                                  ),
                                ],
                                onChanged: (_) => setState(_recompute),
                                validator: _requiredNumber,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        GlassInput(
                          controller: _age,
                          hint: 'Years',
                          label: 'Age',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (_) => setState(_recompute),
                          validator: _requiredNumber,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Your targets',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Suggested from your stats — adjust freely.',
                          style: Theme.of(context).textTheme.labelSmall,
                        ),
                        const SizedBox(height: 16),
                        GlassInput(
                          controller: _goal,
                          hint: 'kcal',
                          label: 'Daily calories',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            _goalTouched = true;
                            final goal = int.tryParse(value);
                            if (goal != null) _fillMacros(goal);
                          },
                          validator: _requiredNumber,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: GlassInput(
                                controller: _protein,
                                hint: 'g',
                                label: 'Protein',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (_) => _macrosTouched = true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GlassInput(
                                controller: _carbs,
                                hint: 'g',
                                label: 'Carbs',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (_) => _macrosTouched = true,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GlassInput(
                                controller: _fat,
                                hint: 'g',
                                label: 'Fat',
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (_) => _macrosTouched = true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    label: 'Get started',
                    icon: Icons.bolt,
                    loading: _saving,
                    onPressed: _save,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Label + [GlassSegmentedControl] pair used for sex / activity selection.
class _SegmentedPicker<T> extends StatelessWidget {
  final String label;
  final List<GlassSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  const _SegmentedPicker({
    required this.label,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label, style: Theme.of(context).textTheme.labelSmall),
        ),
        GlassSegmentedControl<T>(
          segments: segments,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
