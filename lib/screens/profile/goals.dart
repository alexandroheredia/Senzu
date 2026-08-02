import 'package:flutter/material.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/services/user_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Daily calorie goal editor.
class NutritionGoals extends StatefulWidget {
  const NutritionGoals({super.key});

  @override
  State<NutritionGoals> createState() => _NutritionGoalsState();
}

class _NutritionGoalsState extends State<NutritionGoals> {
  String _text = '';
  bool _saving = false;

  Future<void> _update(int current) async {
    final value = int.tryParse(_text);
    final goal = value ?? current;
    if (value == null && _text.trim().isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a whole number of calories')),
      );
      return;
    }
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await UserRepository(uid: myUID(context)).updateDailyCaloriesGoal(goal);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Daily goal updated')),
      );
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not update the goal')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('Nutrition goals')),
      body: StreamBuilder<AppUser>(
        stream: UserRepository(uid: myUID(context)).userData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final goal = snapshot.data!.dailyCaloriesGoal;

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
                            onChanged: (value) => _text = value,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineMedium,
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
                    const SizedBox(height: 20),
                    GradientButton(
                      label: 'Update goal',
                      icon: Icons.check,
                      loading: _saving,
                      onPressed: () => _update(goal),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
