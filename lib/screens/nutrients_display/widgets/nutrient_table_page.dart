import 'package:flutter/material.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_data.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';

/// Renders a ranking table for one [NutrientPage] inside a glass card.
class NutrientTablePage extends StatelessWidget {
  final NutrientPage page;

  const NutrientTablePage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: Text(page.title)),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          GlassCard(
            padding: EdgeInsets.zero,
            child: Theme(
              data: Theme.of(context).copyWith(
                dataTableTheme: DataTableThemeData(
                  headingRowColor: WidgetStatePropertyAll(
                    colors.textPrimary.withValues(alpha: 0.04),
                  ),
                  dataRowColor: const WidgetStatePropertyAll(
                    Colors.transparent,
                  ),
                  dividerThickness: 0.5,
                  headingTextStyle: Theme.of(context).textTheme.labelSmall,
                  dataTextStyle: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: DataTable(
                  columnSpacing: 24,
                  columns: const [
                    DataColumn(label: Text('No.')),
                    DataColumn(label: Text('Food name')),
                    DataColumn(label: Text('Per 100g')),
                    DataColumn(label: Text('%DV')),
                  ],
                  rows: [
                    for (final row in page.rows)
                      DataRow(
                        cells: [
                          DataCell(Text(row.rank)),
                          DataCell(Text(row.foodName)),
                          DataCell(Text(row.amount)),
                          DataCell(Text(row.percent)),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Amount per 100g · ${page.unitLabel} · %DV based on a 2,000 '
            'calorie diet.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}
