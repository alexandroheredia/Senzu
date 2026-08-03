import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/screens/home/dashboard_tab.dart';
import 'package:senzu_app/screens/home/profile_tab.dart';
import 'package:senzu_app/screens/home/shelf_tab.dart';
import 'package:senzu_app/screens/home/stats_tab.dart';
import 'package:senzu_app/screens/onboarding/onboarding_screen.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/shared/widgets/glass_nav_bar.dart';

/// Post-auth shell: four tabs under a floating glass pill nav.
///
/// Shows the first-run onboarding wizard until the user has completed it.
class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userDataProvider);
    return userAsync.when(
      data: (user) =>
          user.onboardingComplete ? const _HomeShell() : const OnboardingScreen(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      // If the profile can't load, still show the app rather than locking
      // the user out; onboarding runs again when the doc is reachable.
      error: (_, _) => const _HomeShell(),
    );
  }
}

class _HomeShell extends StatefulWidget {
  const _HomeShell();

  @override
  State<_HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<_HomeShell> {
  int _index = 0;

  static const List<Widget> _tabs = <Widget>[
    DashboardTab(),
    StatsTab(),
    ShelfTab(),
    ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Absorb the status-bar/notch inset here so every tab's content starts
      // below it. bottom stays open so the background runs full-bleed behind
      // the floating nav pill.
      body: SafeArea(
        bottom: false,
        child: IndexedStack(index: _index, children: _tabs),
      ),
      bottomNavigationBar: GlassNavBar(
        currentIndex: _index,
        onSelected: (index) => setState(() => _index = index),
        items: const <GlassNavItem>[
          GlassNavItem(Icons.bolt, 'Today'),
          GlassNavItem(Icons.bar_chart, 'Stats'),
          GlassNavItem(Icons.kitchen_outlined, 'Shelf'),
          GlassNavItem(Icons.person_outline, 'Profile'),
        ],
      ),
    );
  }
}
