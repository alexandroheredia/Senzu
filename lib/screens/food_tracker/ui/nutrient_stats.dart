import 'package:flutter/material.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/shared/constants.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';

class NutrientStats extends StatefulWidget {
  NutrientStats({Key? key}) : super(key: key);

  @override
  _NutrientStatsState createState() => _NutrientStatsState();
}

class _NutrientStatsState extends State<NutrientStats> {

  final FoodLogRepository _foodLog = FoodLogRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _weeklyNutrientsTotal(),
            _monthlyNutrientsTotal(),
          ],
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

    // TODO: ZINC and Magnesium to be added after 17 may 2023


      return Container(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 30.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Weekly Average', 
                    style: textColor.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
                  ),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (proteinSum > proteinDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Protein', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${proteinSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${proteinDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (dietaryFiberSum > dietaryFiberDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Dietary Fiber', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${dietaryFiberSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${dietaryFiberDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (potassiumSum > potassiumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Potassium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${potassiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${potassiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminASum > vitaminADailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin A', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminASum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminADailyValue}mcg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminDSum > vitaminDDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin D', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminDSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminDDailyValue}mcg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminCSum > vitaminCDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin C', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminCSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminCDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (calciumSum > calciumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Calcium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${calciumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${calciumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (ironSum > ironDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Iron', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${ironSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${ironDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (saturatedFatSum == 0) {
                        return lowIntakeIcon;
                      } if (saturatedFatSum < saturatedFatDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return highIntakeIcon;
                      }
                    }),
                  ),
                  Text('Saturated Fat', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${saturatedFatSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${saturatedFatDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (sodiumSum == 0) {
                        return lowIntakeIcon;
                      } if (sodiumSum < sodiumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return highIntakeIcon;
                      }
                    }),
                  ),
                  Text('Sodium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${sodiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${sodiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
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
                      Container(child: lowIntakeIcon,),
                      Text(' Low intake', style: textColor),
                      SizedBox(height: 10, width: 15,),
                      Container(child: goodIntakeIcon,),
                      Text(' Average', style: textColor),
                      SizedBox(height: 10, width: 15,),
                      Container(child: highIntakeIcon,),
                      Text(' High intake', style: textColor),
                    ]
                  ),
                ),
              ]),
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
    // final zincSum = summary.zinc / 30;
    // final magnesiumSum = summary.magnesium / 30;

    // TODO: ZINC and Magnesium to be added after 17 may 2023


      return Container(
        padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 30.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Monthly Average', 
                    style: textColor.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
                  ),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (proteinSum > proteinDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Protein', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${proteinSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${proteinDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (dietaryFiberSum > dietaryFiberDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Dietary Fiber', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${dietaryFiberSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${dietaryFiberDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (potassiumSum > potassiumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Potassium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${potassiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${potassiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminASum > vitaminADailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin A', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminASum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminADailyValue}mcg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminDSum > vitaminDDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin D', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminDSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminDDailyValue}mcg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (vitaminCSum > vitaminCDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Vitamin C', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${vitaminCSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${vitaminCDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (calciumSum > calciumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Calcium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${calciumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${calciumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (ironSum > ironDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return lowIntakeIcon;
                      }
                    }),
                  ),
                  Text('Iron', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${ironSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${ironDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (saturatedFatSum == 0) {
                        return lowIntakeIcon;
                      } if (saturatedFatSum < saturatedFatDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return highIntakeIcon;
                      }
                    }),
                  ),
                  Text('Saturated Fat', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${saturatedFatSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${saturatedFatDailyValue}g', style: textColor.copyWith(fontSize: 15)),
                ]),
                Row(children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Builder(builder: (context){
                      if (sodiumSum == 0) {
                        return lowIntakeIcon;
                      } if (sodiumSum < sodiumDailyValue) {
                        return goodIntakeIcon;
                      } else {
                        return highIntakeIcon;
                      }
                    }),
                  ),
                  Text('Sodium', style: textColor.copyWith(fontSize: 15)),
                  Expanded(
                    child: nutrientsDivider
                  ),
                  Text('${sodiumSum.toStringAsFixed(0)}', style: textColor.copyWith(fontSize: 15)),
                  Text('/${sodiumDailyValue}mg', style: textColor.copyWith(fontSize: 15)),
                ]),
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
                      Container(child: lowIntakeIcon,),
                      Text(' Low intake', style: textColor),
                      SizedBox(height: 10, width: 15,),
                      Container(child: goodIntakeIcon,),
                      Text(' Average', style: textColor),
                      SizedBox(height: 10, width: 15,),
                      Container(child: highIntakeIcon,),
                      Text(' High intake', style: textColor),
                    ]
                  ),
                ),
              ]),
            );
          }
  }
