import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/shared/constants.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';


class FoodDetails extends StatefulWidget {
  final String? foodNameValue;
  final String? brandNameValue;
  final dynamic servingSizeValue;
  final dynamic portionSizeValue;
  final dynamic caloriesValue;
  final dynamic totalFatValue;
  final dynamic saturatedFatValue;
  final dynamic transFatValue;
  final dynamic cholesterolValue;
  final dynamic sodiumValue;
  final dynamic totalCarbohydrateValue;
  final dynamic dietaryFiberValue;
  final dynamic sugarsValue;
  final dynamic addedSugarsValue;
  final dynamic proteinValue;
  final dynamic calciumValue;
  final dynamic ironValue;
  final dynamic potassiumValue;
  final dynamic vitaminAValue;
  final dynamic vitaminCValue;
  final dynamic vitaminDValue;
  final dynamic magnesiumValue;
  final dynamic zincValue;
  final DateTime? selectedDateSecondStep;
  final String? foodIdValue;
  final String? breakfastMealAdd;
  final String? lunchMealAdd;
  final String? snacksMealAdd;
  final String? dinnerMealAdd;
  final dynamic timesAddedValue;
  final String? getFoodIdValue;


  FoodDetails({
    Key? key, 
    this.foodNameValue,
    this.brandNameValue,
    this.servingSizeValue,
    this.portionSizeValue,
    this.caloriesValue, 
    this.totalFatValue, 
    this.saturatedFatValue, 
    this.transFatValue, 
    this.cholesterolValue, 
    this.sodiumValue, 
    this.totalCarbohydrateValue, 
    this.dietaryFiberValue, 
    this.sugarsValue, 
    this.addedSugarsValue,
    this.proteinValue, 
    this.calciumValue, 
    this.ironValue, 
    this.potassiumValue, 
    this.vitaminAValue, 
    this.vitaminCValue,
    this.vitaminDValue,
    this.selectedDateSecondStep, 
    this.foodIdValue, 
    this.breakfastMealAdd, 
    this.lunchMealAdd, 
    this.snacksMealAdd,
    this.dinnerMealAdd, 
    this.timesAddedValue, 
    this.getFoodIdValue, 
    this.magnesiumValue, 
    this.zincValue, 
    }) : super(key: key);

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {

  selectedMealValue(){
    return widget.breakfastMealAdd;
  
  }

  final portionSizeController = TextEditingController();

  Widget _bottomAction(IconData icon, Function callback) {
    return Icon(icon, color: Color(0xFF1e1f38));
  }

  _caloriesIntake(){
    var caloriesIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.caloriesValue;
    return caloriesIntake.toInt();
  }
   
  _totalFatIntake(){
    var totalFatIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.totalFatValue;
    return totalFatIntake.toInt();
  }

  _saturatedFatIntake(){
    var saturatedFatIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.saturatedFatValue;
    return saturatedFatIntake.toInt();
  }

  _transFatIntake(){
    var transFatIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.transFatValue;
    return transFatIntake.toInt();
  }

  _cholesterolIntake(){
    var cholesterolIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.cholesterolValue;
    return cholesterolIntake.toInt();
  }

  _sodiumIntake(){
    var sodiumIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.sodiumValue;
    return sodiumIntake.toInt();
  }

  _totalCarbohydrateIntake(){
    var totalCarbohydrateIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.totalCarbohydrateValue;
    return totalCarbohydrateIntake.toInt();
  }

  _dietaryFiberIntake(){
    var dietaryFiberIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.dietaryFiberValue;
    return dietaryFiberIntake.toInt();
  }

  _sugarsIntake(){
    var sugarsIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.sugarsValue;
    return sugarsIntake.toInt();
  }

  _proteinIntake(){
    var proteinIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.proteinValue;
    return proteinIntake.toInt();
  }

  _calciumIntake(){
    var calciumIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.calciumValue;
    return calciumIntake.toInt();
  }

  _ironIntake(){
    var ironIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.ironValue;
    return ironIntake.toInt();
  }

  _potassiumIntake(){
    var potassiumIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.potassiumValue;
    return potassiumIntake.toInt();
  }

  _vitaminAIntake(){
    var vitaminAIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.vitaminAValue;
    return vitaminAIntake.toInt();
  }

  _vitaminCIntake(){
    var vitaminCIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.vitaminCValue;
    return vitaminCIntake.toInt();
  }

  _vitaminDIntake(){
    var vitaminDIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.vitaminDValue;
    return vitaminDIntake.toInt();
  }

  _magnesiumIntake(){
    var magnesiumIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.magnesiumValue;
    return magnesiumIntake.toInt();
  }

  _zincIntake(){
    var zincIntake = (int.parse(portionSizeController.text) / widget.servingSizeValue) * widget.zincValue;
    return zincIntake.toInt();
  }

   breakfastCalories(){
     var breakfastCalories = _caloriesIntake();
     return breakfastCalories;
      }

   lunchCalories(){
     var lunchCalories = _caloriesIntake();
     return lunchCalories;
      }

   snacksCalories(){
     var snacksCalories = _caloriesIntake();
     return snacksCalories;
      }

  dinnerCalories(){
    var dinnerCalories = _caloriesIntake();
    return dinnerCalories;
    }

  totalFatPercentage(){
    if (widget.totalFatValue != null) {
      var totalFatPercentage = (widget.totalFatValue / totalFatDailyValue) * 100;
      return totalFatPercentage;
    } return 0;
  }

  saturatedFatPercentage(){
    if (widget.saturatedFatValue != null) {
      var saturatedFatPercentage = (widget.saturatedFatValue / saturatedFatDailyValue) * 100;
      return saturatedFatPercentage;
    } return 0;
  }

  cholesterolPercentage(){
    if (widget.cholesterolValue != null) {
      var cholesterolPercentage = (widget.cholesterolValue / cholesterolDailyValue) * 100;
      return cholesterolPercentage;
    } return 0;
  }

  sodiumPercentage(){
    if (widget.sodiumValue != null) {
      var sodiumPercentage = (widget.sodiumValue / sodiumDailyValue) *100;
      return sodiumPercentage;
    } return 0;
  }

  totalCarbohydratePercentage(){
    if (widget.totalCarbohydrateValue != null) {
      var totalCarbohydratePercentage = (widget.totalCarbohydrateValue / totalCarbohydrateDailyValue) * 100;
      return totalCarbohydratePercentage;
    } return 0;
  }

  dietaryFiberPercentage(){
    if (widget.dietaryFiberValue != null) {
      var dietaryFiberPercentage = (widget.dietaryFiberValue / dietaryFiberDailyValue) * 100;
      return dietaryFiberPercentage;
    } return 0;
  }

  addedSugarsPercentage(){
    if (widget.addedSugarsValue != null) {
      var addedSugarsPercentage = (widget.addedSugarsValue / addedSugarsDailyValue) * 100;
      return addedSugarsPercentage;
    } return 0;
  }

  vitaminDPercentage(){
    if (widget.vitaminDValue != null) {
      var vitaminDPercentage = (widget.vitaminDValue / vitaminDDailyValue) * 100;
      return vitaminDPercentage;
    } return 0;
  }

  calciumPercentage(){
    if (widget.calciumValue != null) {
      var calciumPercentage = (widget.calciumValue / calciumDailyValue) * 100;
      return calciumPercentage;
    } return 0;
  }

  ironPercentage(){
    if (widget.ironValue != null) {
      var ironPercentage = (widget.ironValue / ironDailyValue) * 100;
      return ironPercentage;
    } return 0;
  }

  potassiumPercentage(){
    if (widget.potassiumValue != null) {
      var potassiumPercentage = (widget.potassiumValue / potassiumDailyValue) * 100;
      return potassiumPercentage;
    } return 0;
  }

  vitaminCPercentage(){
    if (widget.vitaminCValue != null) {
      var vitaminCPercentage = (widget.vitaminCValue / vitaminCDailyValue) * 100;
      return vitaminCPercentage;
    } return 0;
  }
  
  vitaminAPercentage(){
    if (widget.vitaminAValue != null) {
      var vitaminAPercentage = (widget.vitaminAValue / vitaminADailyValue) * 100;
      return vitaminAPercentage;
    } return 0;
  }

  addedSugarsValue(){
    if (widget.addedSugarsValue != null) {
      var addedSugarsValue = widget.addedSugarsValue;
      return addedSugarsValue;
    } return 0;
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(Icons.chevron_left,
              size: 40,
            )
          ),
          backgroundColor: primaryBackgroundColor,
          centerTitle: true,
          title: Text('Nutrition Facts'
          )
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFF1e1f38),
          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              _bottomAction(Icons.cleaning_services_outlined, () {}),
              SizedBox(width: 150.0),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryButtonColor,
          child: Icon(Icons.add),
          onPressed: () {
            try {
              updateTimesAddedCount();
              saveFoodToMeal();
              Navigator.of(context).pop();
            } catch (e) {
              print(e);
            }
          },
        ),
        body: _foodDetailsBody(),
      ),
    );
  }

  Widget _foodDetailsBody(){
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: foodDetailsBorderColor
              ),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.foodNameValue ?? '',
                    style: textColor.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 32.0,
                    )
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Text(widget.brandNameValue ?? '',
                    style: textColor.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    )
                  ),
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Enter amount had:',
                      style: textColor.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      )
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: notBoldTextOnLabel,
                        decoration: textInputDecoration.copyWith(hintText: 'g', hintStyle: textColor),
                        controller: portionSizeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Serving size',
                        style: textColor.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        )
                      ),
                      Text(' ',                                
                        style: textColor.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        )
                      ),
                      Text('(' + widget.servingSizeValue.toStringAsFixed(0) + 'g' + ')',                                
                        style: textColor.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        )
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 15,
                  thickness: 14,
                  color: foodDetailsBorderColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Calories',
                      style: textColor.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                      )
                    ),
                    Text('${widget.caloriesValue.toStringAsFixed(0)}',
                      style: textColor.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 60,
                      )
                    ),
                  ],
                ),
                semiThickDivider,
                Container(
                  alignment: Alignment.centerRight,
                  child: Text('% Daily Value*',
                    style: textColor.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    )
                  ),
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Text('Total Fat ',
                          style: textColor.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          )
                        ),
                        Text('${widget.totalFatValue.toStringAsFixed(0)}g',
                          style: notBoldTextOnLabel
                        ),
                      ],
                    ),
                    Text('${totalFatPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel
                    ),
                  ]
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                        Text('Saturated Fat ',
                          style: notBoldTextOnLabel
                        ),
                        Text('${widget.saturatedFatValue.toStringAsFixed(0)}g',
                            style: notBoldTextOnLabel
                          ),
                        ],
                      ),
                    ),
                    Text('${saturatedFatPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel
                    ),
                  ]
                ),
                thinDivider,
                Container(
                  margin: EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text('Trans Fat ',
                        style: textColor.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic
                        )
                      ),
                      Text('${widget.transFatValue.toStringAsFixed(0)}g',
                        style: notBoldTextOnLabel
                      ),
                    ],
                  ),
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Text('Cholesterol ',
                          style: boldTextOnLabel
                        ),
                        Text('${widget.cholesterolValue.toStringAsFixed(0)}g',
                          style: notBoldTextOnLabel
                        ),
                      ],
                    ),
                    Text('${cholesterolPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel
                    ),
                  ]
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                    children: [
                      Text('Sodium ',
                        style: boldTextOnLabel
                      ),
                      Text('${widget.sodiumValue.toStringAsFixed(0)}g',
                        style: notBoldTextOnLabel
                      ),
                    ],
                  ),
                  Text('${sodiumPercentage().toStringAsFixed(0)}%',
                    style: boldTextOnLabel
                  ),
                ]
              ),
              thinDivider,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: [
                      Text('Total Carbohydrate ',
                        style: boldTextOnLabel
                      ),
                      Text('${widget.totalCarbohydrateValue.toStringAsFixed(0)}g',
                        style: notBoldTextOnLabel
                      ),
                    ],
                  ),
                  Text('${totalCarbohydratePercentage().toStringAsFixed(0)}%',
                    style: boldTextOnLabel
                  ),
                ]
              ),
              thinDivider,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        Text('Dietary Fiber ',
                          style: notBoldTextOnLabel
                        ),
                        Text('${widget.dietaryFiberValue.toStringAsFixed(0)}g',
                          style: notBoldTextOnLabel
                        ),
                      ],
                    ),
                  ),
                  Text('${dietaryFiberPercentage().toStringAsFixed(0)}%',
                    style: boldTextOnLabel
                  ),
                ]
              ),
              thinDivider,
              Container(
                margin: EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    Text('Total Sugars ',
                      style: notBoldTextOnLabel
                    ),
                    Text('${widget.sugarsValue.toStringAsFixed(0)}g',
                    style: notBoldTextOnLabel
                    ),
                  ],
                ),
              ),
              Divider(height: 8, thickness: 1, indent: 38, color: foodDetailsBorderColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 35),
                  child: Row(
                    children: [
                      Text('Includes ${addedSugarsValue().toStringAsFixed(0)}g Added Sugars',
                        style: notBoldTextOnLabel
                      ),
                    ],
                  ),
                ),
                Text('${addedSugarsPercentage().toStringAsFixed(0)}%',
                  style: boldTextOnLabel
                ),
              ]
            ),
            Row(
              children: [
                Text('Protein ',
                  style: boldTextOnLabel
                ),
                Text('${widget.proteinValue.toStringAsFixed(0)}g',
                  style: notBoldTextOnLabel
                ),
              ],
            ),
            Divider(
              height: 20,
              thickness: 14,
              color: foodDetailsBorderColor,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vitamin D ' + widget.vitaminDValue.toStringAsFixed(0) + 'mcg',
                  style: notBoldTextOnLabel
                ),
                Text('${vitaminDPercentage().toStringAsFixed(0)}%',
                  style: notBoldTextOnLabel
                ),
              ],
            ),
            thinDivider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Calcium ' + widget.calciumValue.toStringAsFixed(0) + 'mg',
                  style: notBoldTextOnLabel
                ),
                Text('${calciumPercentage().toStringAsFixed(0)}%',
                  style: notBoldTextOnLabel
                ),
              ],
            ),
            thinDivider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Iron ' + widget.ironValue.toStringAsFixed(0) + 'mg',
                  style: notBoldTextOnLabel
                ),
                Text('${ironPercentage().toStringAsFixed(0)}%',
                  style: notBoldTextOnLabel
                ),
              ],
            ),
            thinDivider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Potassium ' + widget.potassiumValue.toStringAsFixed(0) + 'mg',
                  style: notBoldTextOnLabel
                ),
                Text('${potassiumPercentage().toStringAsFixed(0)}%',
                  style: notBoldTextOnLabel
                ),
              ],
            ),
            thinDivider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vitamin C ' + widget.vitaminCValue.toStringAsFixed(0) + 'mg',
                  style: notBoldTextOnLabel
                ),
                Text('${vitaminCPercentage().toStringAsFixed(0)}%',
                  style: notBoldTextOnLabel
                ),
              ],
            ),
            thinDivider,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Vitamin A ' + widget.vitaminAValue.toStringAsFixed(0) + 'mcg',
                  style: notBoldTextOnLabel
                ),
                Text('${vitaminAPercentage().toStringAsFixed(0)}%',
                  style: notBoldTextOnLabel
                ),
              ],
            ),
            Divider(height: 10, thickness: 5, color: foodDetailsBorderColor),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 6),
              child: Text('* The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. 2,000 calories a day is used for general nutrition advice.',
                style: textColor.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 12
                )
              )
            ),
          ],
        ),
      ),
      Container(
        padding: EdgeInsets.only(bottom: 20),
      ),
    ],
  ),
);
}

  void saveFoodToMeal() {

    dbUsersCollection
      .doc(myUID(context))
      .collection('foodEntries')
      .add({
      "foodId": widget.getFoodIdValue,
      "foodName": widget.foodNameValue,
      "brandName": widget.brandNameValue,
      'portionSize': int.parse(portionSizeController.text),
      "servingSize": widget.servingSizeValue,
      'mealType': selectedMealValue(),
      "calories": _caloriesIntake(),
      "totalFat": _totalFatIntake(),
      "saturatedFat": _saturatedFatIntake(),
      "transFat": _transFatIntake(),
      "cholesterol": _cholesterolIntake(),
      "sodium": _sodiumIntake(),
      "totalCarbohydrate": _totalCarbohydrateIntake(),
      "dietaryFiber": _dietaryFiberIntake(),
      "sugars": _sugarsIntake(),
      "protein": _proteinIntake(),
      "calcium": _calciumIntake(),
      "iron": _ironIntake(),
      "potassium": _potassiumIntake(),
      "vitaminA": _vitaminAIntake(),
      "vitaminC": _vitaminCIntake(),
      "vitaminD": _vitaminDIntake(),
      "magnesium": _magnesiumIntake(),
      "zinc": _zincIntake(),
      "weekNo": getWeekNumber(widget.selectedDateSecondStep!),
      "month": cleanMonthFormat(widget.selectedDateSecondStep.toString()),
      "year": cleanYearFormat(widget.selectedDateSecondStep.toString()),
      "dateAdded": widget.selectedDateSecondStep,
      "breakfastCalories": breakfastCalories(),
      "lunchCalories": lunchCalories(),
      "snacksCalories": snacksCalories(),
      "dinnerCalories": dinnerCalories(),
    });
  }

  void updateTimesAddedCount() {

    dbUsersCollection
      .doc(myUID(context))
      .collection('foodShelf')
      .doc(widget.getFoodIdValue)
      .update({'timesAdded': FieldValue.increment(1)});
  }
}

