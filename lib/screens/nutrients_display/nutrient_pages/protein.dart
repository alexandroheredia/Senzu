import 'package:flutter/material.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_data.dart';
import 'package:senzu_app/screens/nutrients_display/widgets/nutrient_table_page.dart';

class Protein extends StatelessWidget {
  const Protein({super.key});

  @override
  Widget build(BuildContext context) {
    return const NutrientTablePage(page: proteinData);
  }
}
