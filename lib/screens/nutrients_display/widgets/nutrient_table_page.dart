import 'package:flutter/material.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_data.dart';
import 'package:senzu_app/shared/theme.dart';

/// Renders a ranking table for one [NutrientPage].
class NutrientTablePage extends StatelessWidget {
  final NutrientPage page;

  const NutrientTablePage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          page.title,
          style: titleTextStyle,
        ),
        centerTitle: true,
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 15.0,
              dividerThickness: 1.5,
              columns: [
                DataColumn(
                  label: Text(
                    'No.',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Food Name',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
                DataColumn(
                  label: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Amount per 100g',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        page.unitLabel,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),
                ),
                DataColumn(
                  label: Text(
                    ' %DV',
                    style: const TextStyle(fontSize: 20.0),
                  ),
                ),
              ],
              rows: [
                for (final row in page.rows)
                  DataRow(cells: [
                    DataCell(
                      Center(
                        child: Text(
                          row.rank,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        row.foodName,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                    DataCell(
                      Center(
                        child: Text(
                          row.amount,
                          style: const TextStyle(fontSize: 20.0),
                        ),
                      ),
                    ),
                    DataCell(
                      Text(
                        row.percent,
                        style: const TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
