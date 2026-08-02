import 'package:flutter/material.dart';
import 'package:senzu_app/screens/home/dashboard_tab.dart';
import 'package:senzu_app/screens/home/profile_tab.dart';
import 'package:senzu_app/screens/home/shelf_tab.dart';
import 'package:senzu_app/screens/home/stats_tab.dart';
import 'package:senzu_app/shared/widgets/glass_nav_bar.dart';

/// Post-auth shell: four tabs under a floating glass pill nav.
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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
      body: IndexedStack(index: _index, children: _tabs),
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
