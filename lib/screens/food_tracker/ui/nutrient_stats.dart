import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/shared/constants.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';

class NutrientStats extends StatefulWidget {
  NutrientStats({Key? key}) : super(key: key);

  @override
  _NutrientStatsState createState() => _NutrientStatsState();
}

class _NutrientStatsState extends State<NutrientStats> {


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
    return StreamBuilder(
      stream: dbUsersCollection
        .doc(myUID(context))
        .collection('foodEntries')
        .where("dateAdded", isGreaterThan: lastWeek)
        .snapshots(),
      builder: _buildNutrientsTotal,
    );
  }


  Widget _buildNutrientsTotal(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if(snapshot.data == null) 
      return loadingWidget;

      final documents = snapshot.data!.docs;
      final proteinSum = documents.fold<double>(0, (s, n) => s + (n['protein'] as num) / 7);
      final dietaryFiberSum = documents.fold<double>(0, (s, n) => s + (n['dietaryFiber'] as num) / 7);
      final potassiumSum = documents.fold<double>(0, (s, n) => s + (n['potassium'] as num) / 7);
      final vitaminASum = documents.fold<double>(0, (s, n) => s + (n['vitaminA'] as num) / 7);
      final vitaminCSum = documents.fold<double>(0, (s, n) => s + (n['vitaminC'] as num) / 7);
      final calciumSum = documents.fold<double>(0, (s, n) => s + (n['calcium'] as num) / 7);
      final ironSum = documents.fold<double>(0, (s, n) => s + (n['iron'] as num) / 7);
      final saturatedFatSum = documents.fold<double>(0, (s, n) => s + (n['saturatedFat'] as num) / 7);
      final sodiumSum = documents.fold<double>(0, (s, n) => s + (n['sodium'] as num) / 7);
      final vitaminDSum = documents.fold<double>(0, (s, n) => s + (n['vitaminD'] as num) / 7);
      // final zincSum = documents.fold(0, (s, n) => s + n['zinc'] / 7);
      // final magnesiumSum = documents.fold(0, (s, n) => s + n['magnesium'] / 7);

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
    return StreamBuilder(
      stream: dbUsersCollection
        .doc(myUID(context))
        .collection('foodEntries')
        .where("dateAdded", isGreaterThan: lastMonth)
        .snapshots(),
      builder: _buildMonthlyNutrientsTotal,
    );
  }


  Widget _buildMonthlyNutrientsTotal(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    if(snapshot.data == null) 
      return loadingWidget;

      final documents = snapshot.data!.docs;
      final proteinSum = documents.fold<double>(0, (s, n) => s + (n['protein'] as num) / 30);
      final dietaryFiberSum = documents.fold<double>(0, (s, n) => s + (n['dietaryFiber'] as num) / 30);
      final potassiumSum = documents.fold<double>(0, (s, n) => s + (n['potassium'] as num) / 30);
      final vitaminASum = documents.fold<double>(0, (s, n) => s + (n['vitaminA'] as num) / 30);
      final vitaminCSum = documents.fold<double>(0, (s, n) => s + (n['vitaminC'] as num) / 30);
      final calciumSum = documents.fold<double>(0, (s, n) => s + (n['calcium'] as num) / 30);
      final ironSum = documents.fold<double>(0, (s, n) => s + (n['iron'] as num) / 30);
      final saturatedFatSum = documents.fold<double>(0, (s, n) => s + (n['saturatedFat'] as num) / 30);
      final sodiumSum = documents.fold<double>(0, (s, n) => s + (n['sodium'] as num) / 30);
      final vitaminDSum = documents.fold<double>(0, (s, n) => s + (n['vitaminD'] as num) / 30);
      // final zincSum = documents.fold(0, (s, n) => s + n['sodium'] / 30);
      // final magnesiumSum = documents.fold(0, (s, n) => s + n['sodium'] / 30);

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
