import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/screens/nutrients_display/nutrients_display.dart';
import 'package:senzu_app/screens/profile/account_screen.dart';
import 'package:senzu_app/screens/profile/edit_profile_screen.dart';
import 'package:senzu_app/screens/profile/goals.dart';
import 'package:senzu_app/screens/profile/reminders_screen.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/services/streak_calculator.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';

/// Profile tab: greeting, glass list rows for goals / nutrient guide /
/// feedback, and sign out.
class ProfileTab extends ConsumerWidget {
  const ProfileTab({super.key});

  Future<void> _openFeedback(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: GlassCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Something not working?',
                  style: Theme.of(sheetContext).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Let us know and we will fix it as soon as possible.',
                  style: Theme.of(sheetContext).textTheme.bodyMedium?.copyWith(
                    color: context.appColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 20),
                const _FeedbackRow(
                  icon: Icons.reddit,
                  label: 'r/SenzuApp',
                ),
                const SizedBox(height: 8),
                const _FeedbackRow(
                  icon: Icons.mail_outline,
                  label: 'nointrobusiness@gmail.com',
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final auth = context.authController;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You can sign back in anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Go back'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Sign out',
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
      if (context.mounted) await auth.signOut();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    final user = ref.watch(userDataProvider).value;
    final username = (user?.username ?? '').trim();
    final greeting = username.isEmpty ? 'there' : username;
    final goalText = user == null
        ? ''
        : 'Daily goal · ${user.dailyCaloriesGoal} kcal';

    // Streak from the last 120 days of food entries.
    final entriesAsync = ref.watch(
      entriesSinceProvider(
        daysBefore(todayMidnight(), 120),
      ),
    );
    final streak = entriesAsync.maybeWhen(
      data: (entries) => currentStreak(
        entries.map((entry) => entry.dateAdded).toSet(),
      ),
      orElse: () => 0,
    );

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      children: [
        Row(
          children: [
            Container(
              width: 56,
              height: 56,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: colors.energyGradient,
                boxShadow: colors.energyGlow(),
              ),
              child: Text(
                username.isEmpty ? 'S' : username[0].toUpperCase(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: colors.bgBase,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hey, $greeting!',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  if (goalText.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      goalText,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ],
              ),
            ),
            if (streak > 0) ...[
              const SizedBox(width: 8),
              _StreakBadge(streak: streak),
            ],
          ],
        ),
        const SizedBox(height: 32),
        GlassCard(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              _ProfileRow(
                icon: Icons.person_outline,
                label: 'Edit profile',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const EditProfileScreen(),
                  ),
                ),
              ),
              _divider(colors),
              _ProfileRow(
                icon: Icons.track_changes,
                label: 'Nutrition goals',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const NutritionGoals(),
                  ),
                ),
              ),
              _divider(colors),
              _ProfileRow(
                icon: Icons.menu_book_outlined,
                label: 'Nutrient guide',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const NutrientsDisplay(),
                  ),
                ),
              ),
              _divider(colors),
              _ProfileRow(
                icon: Icons.notifications_outlined,
                label: 'Reminders',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const RemindersScreen(),
                  ),
                ),
              ),
              _divider(colors),
              _ProfileRow(
                icon: Icons.chat_bubble_outline,
                label: 'Feedback',
                onTap: () => _openFeedback(context),
              ),
              _divider(colors),
              _ProfileRow(
                icon: Icons.settings_outlined,
                label: 'Account',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const AccountScreen(),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        GlassCard(
          padding: const EdgeInsets.all(8),
          child: _ProfileRow(
            icon: Icons.logout,
            label: 'Sign out',
            danger: true,
            onTap: () => _confirmSignOut(context),
          ),
        ),
      ],
    );
  }

  Widget _divider(AppColors colors) => Divider(
    height: 1,
    indent: 64,
    color: colors.glassBorder,
  );
}

/// Flame badge showing the current logging streak.
class _StreakBadge extends StatelessWidget {
  final int streak;

  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: colors.energyStart.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department, size: 16, color: colors.energyStart),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colors.energyStart,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _ProfileRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = danger ? colors.danger : colors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: danger
                      ? colors.danger.withValues(alpha: 0.12)
                      : colors.textPrimary.withValues(alpha: 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeedbackRow extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeedbackRow({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        Icon(icon, color: colors.energyStart, size: 18),
        const SizedBox(width: 12),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
