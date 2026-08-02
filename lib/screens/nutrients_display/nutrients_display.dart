import 'package:flutter/material.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/calcium.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/fiber.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/iron.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/potassium.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/protein.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/vitamin_a.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/vitamin_c.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_row.dart';

/// Nutrient guide: the top foods per nutrient, as glass rows.
class NutrientsDisplay extends StatelessWidget {
  const NutrientsDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nutrient guide')),
      body: const _NutrientList(),
    );
  }
}

class _NutrientList extends StatelessWidget {
  const _NutrientList();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final items = <_GuideItem>[
      _GuideItem('Fiber', Icons.grass, colors.carbs, const Fiber()),
      _GuideItem(
        'Protein',
        Icons.fitness_center,
        colors.protein,
        const Protein(),
      ),
      _GuideItem(
        'Potassium',
        Icons.energy_savings_leaf,
        colors.fat,
        const Potassium(),
      ),
      _GuideItem(
        'Vitamin A',
        Icons.wb_sunny_outlined,
        colors.energyStart,
        const VitaminA(),
      ),
      _GuideItem(
        'Vitamin C',
        Icons.spa_outlined,
        colors.energyEnd,
        const VitaminC(),
      ),
      _GuideItem('Iron', Icons.science_outlined, colors.fat, const Iron()),
      _GuideItem(
        'Calcium',
        Icons.egg_alt_outlined,
        colors.protein,
        const Calcium(),
      ),
    ];

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return GlassRow(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (context) => item.page),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(item.icon, color: item.color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Text(
                'Top foods',
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
  }
}

class _GuideItem {
  final String label;
  final IconData icon;
  final Color color;
  final Widget page;

  const _GuideItem(this.label, this.icon, this.color, this.page);
}
