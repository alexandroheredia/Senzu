import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/theme.dart';

class NutrientStats extends StatefulWidget {
  const NutrientStats({super.key});

  @override
  State<NutrientStats> createState() => _NutrientStatsState();
}

class _NutrientStatsState extends State<NutrientStats> {
  late final FoodLogRepository _foodLog;

  @override
  void initState() {
    super.initState();
    _foodLog = context.read<FoodLogRepository>();
  }

  /// One row of the nutrient summary: icon + label + divider + value + daily.
  Widget _nutrientRow(
    String label,
    double value,
    int dailyValue,
    String unit, {
    Widget? icon,
  }) {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: icon ?? (value > dailyValue ? goodIntakeIcon : lowIntakeIcon),
        ),
        Text(label, style: textColor.copyWith(fontSize: 15)),
        const Expanded(child: nutrientsDivider),
        Text(
          value.toStringAsFixed(0),
          style: textColor.copyWith(fontSize: 15),
        ),
        Text('/$dailyValue$unit', style: textColor.copyWith(fontSize: 15)),
      ],
    );
  }

  /// Icon logic for nutrients where zero is bad, under target is good and
  /// over target is high.
  Widget _threeStateIcon(double value, int dailyValue) {
    if (value == 0) return lowIntakeIcon;
    if (value < dailyValue) return goodIntakeIcon;
    return highIntakeIcon;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[_weeklyNutrientsTotal(), _monthlyNutrientsTotal()],
        ),
      ),
    );
  }

  Widget _weeklyNutrientsTotal() {
    return StreamBuilder<List<FoodEntry>>(
      stream: _foodLog.entriesSince(
        myUID(context),
        daysBefore(todayMidnight(), 7),
      ),
      builder: _buildNutrientsTotal,
    );
  }

  Widget _buildNutrientsTotal(
    BuildContext context,
    AsyncSnapshot<List<FoodEntry>> snapshot,
  ) {
    if (!snapshot.hasData) return loadingWidget;

    final summary = FoodLogSummary.fromEntries(snapshot.data!);
    final proteinSum = summary.protein / 7;
    final dietaryFiberSum = summary.dietaryFiber / 7;
    final potassiumSum = summary.potassium / 7;
    final vitaminASum = summary.vitaminA / 7;
    final vitaminCSum = summary.vitaminC / 7;
    final calciumSum = summary.calcium / 7;
    final ironSum = summary.iron / 7;
    final saturatedFatSum = summary.saturatedFat / 7;
    final sodiumSum = summary.sodium / 7;
    final vitaminDSum = summary.vitaminD / 7;
    // final zincSum = summary.zinc / 7;
    // final magnesiumSum = summary.magnesium / 7;

    return Container(
      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 30.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Weekly Average',
                  style: textColor.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _nutrientRow('Protein', proteinSum, proteinDailyValue, 'g'),
          _nutrientRow(
            'Dietary Fiber',
            dietaryFiberSum,
            dietaryFiberDailyValue,
            'g',
          ),
          _nutrientRow('Potassium', potassiumSum, potassiumDailyValue, 'mg'),
          _nutrientRow('Vitamin A', vitaminASum, vitaminADailyValue, 'mcg'),
          _nutrientRow('Vitamin D', vitaminDSum, vitaminDDailyValue, 'mcg'),
          _nutrientRow('Vitamin C', vitaminCSum, vitaminCDailyValue, 'mg'),
          _nutrientRow('Calcium', calciumSum, calciumDailyValue, 'mg'),
          _nutrientRow('Iron', ironSum, ironDailyValue, 'mg'),
          _nutrientRow(
            'Saturated Fat',
            saturatedFatSum,
            saturatedFatDailyValue,
            'g',
            icon: _threeStateIcon(saturatedFatSum, saturatedFatDailyValue),
          ),
          _nutrientRow(
            'Sodium',
            sodiumSum,
            sodiumDailyValue,
            'mg',
            icon: _threeStateIcon(sodiumSum, sodiumDailyValue),
          ),
          // Row(children: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Builder(builder: (context){
          //       if (sodiumSum == 0) {
          //         return lowIntakeIcon;
          //       } if (sodiumSum < sodiumDailyValue) {
          //         return goodIntakeIcon;
          //       } else {
          //         return highIntakeIcon;
          //       }
          //     }),
          //   ),
          //   Text('Zinc (Placeholder)', style: textColor.copyWith(fontSize: 15)),
          //   Expanded(
          //     child: nutrientsDivider
          //   ),
          //   Text('${zincSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
          //   Text('/${zincDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
          // ]),
          // Row(children: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Builder(builder: (context){
          //       if (sodiumSum == 0) {
          //         return lowIntakeIcon;
          //       } if (sodiumSum < sodiumDailyValue) {
          //         return goodIntakeIcon;
          //       } else {
          //         return highIntakeIcon;
          //       }
          //     }),
          //   ),
          //   Text('Magnesium (Placeholder)', style: textColor.copyWith(fontSize: 15)),
          //   Expanded(
          //     child: nutrientsDivider
          //   ),
          //   Text('${magnesiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
          //   Text('/${magnesiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
          // ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: lowIntakeIcon),
                const Text(' Low intake', style: textColor),
                const SizedBox(height: 10, width: 15),
                Container(child: goodIntakeIcon),
                const Text(' Average', style: textColor),
                const SizedBox(height: 10, width: 15),
                Container(child: highIntakeIcon),
                const Text(' High intake', style: textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _monthlyNutrientsTotal() {
    return StreamBuilder<List<FoodEntry>>(
      stream: _foodLog.entriesSince(
        myUID(context),
        daysBefore(todayMidnight(), 30),
      ),
      builder: _buildMonthlyNutrientsTotal,
    );
  }

  Widget _buildMonthlyNutrientsTotal(
    BuildContext context,
    AsyncSnapshot<List<FoodEntry>> snapshot,
  ) {
    if (!snapshot.hasData) return loadingWidget;

    final summary = FoodLogSummary.fromEntries(snapshot.data!);
    final proteinSum = summary.protein / 30;
    final dietaryFiberSum = summary.dietaryFiber / 30;
    final potassiumSum = summary.potassium / 30;
    final vitaminASum = summary.vitaminA / 30;
    final vitaminCSum = summary.vitaminC / 30;
    final calciumSum = summary.calcium / 30;
    final ironSum = summary.iron / 30;
    final saturatedFatSum = summary.saturatedFat / 30;
    final sodiumSum = summary.sodium / 30;
    final vitaminDSum = summary.vitaminD / 30;

    return Container(
      padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 30.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Monthly Average',
                  style: textColor.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          _nutrientRow('Protein', proteinSum, proteinDailyValue, 'g'),
          _nutrientRow(
            'Dietary Fiber',
            dietaryFiberSum,
            dietaryFiberDailyValue,
            'g',
          ),
          _nutrientRow('Potassium', potassiumSum, potassiumDailyValue, 'mg'),
          _nutrientRow('Vitamin A', vitaminASum, vitaminADailyValue, 'mcg'),
          _nutrientRow('Vitamin D', vitaminDSum, vitaminDDailyValue, 'mcg'),
          _nutrientRow('Vitamin C', vitaminCSum, vitaminCDailyValue, 'mg'),
          _nutrientRow('Calcium', calciumSum, calciumDailyValue, 'mg'),
          _nutrientRow('Iron', ironSum, ironDailyValue, 'mg'),
          _nutrientRow(
            'Saturated Fat',
            saturatedFatSum,
            saturatedFatDailyValue,
            'g',
            icon: _threeStateIcon(saturatedFatSum, saturatedFatDailyValue),
          ),
          _nutrientRow(
            'Sodium',
            sodiumSum,
            sodiumDailyValue,
            'mg',
            icon: _threeStateIcon(sodiumSum, sodiumDailyValue),
          ),
          // Row(children: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Builder(builder: (context){
          //       if (sodiumSum == 0) {
          //         return lowIntakeIcon;
          //       } if (sodiumSum < sodiumDailyValue) {
          //         return goodIntakeIcon;
          //       } else {
          //         return highIntakeIcon;
          //       }
          //     }),
          //   ),
          //   Text('Zinc (Placeholder)', style: textColor.copyWith(fontSize: 15)),
          //   Expanded(
          //     child: nutrientsDivider
          //   ),
          //   Text('${zincSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
          //   Text('/${zincDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
          // ]),
          // Row(children: <Widget>[
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Builder(builder: (context){
          //       if (sodiumSum == 0) {
          //         return lowIntakeIcon;
          //       } if (sodiumSum < sodiumDailyValue) {
          //         return goodIntakeIcon;
          //       } else {
          //         return highIntakeIcon;
          //       }
          //     }),
          //   ),
          //   Text('Magnesium (Placeholder)', style: textColor.copyWith(fontSize: 15)),
          //   Expanded(
          //     child: nutrientsDivider
          //   ),
          //   Text('${magnesiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
          //   Text('/${magnesiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
          // ]),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: lowIntakeIcon),
                const Text(' Low intake', style: textColor),
                const SizedBox(height: 10, width: 15),
                Container(child: goodIntakeIcon),
                const Text(' Average', style: textColor),
                const SizedBox(height: 10, width: 15),
                Container(child: highIntakeIcon),
                const Text(' High intake', style: textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
