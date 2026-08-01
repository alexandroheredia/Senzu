import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/services/meal_repository.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/theme.dart';

class FoodDetails extends StatefulWidget {
  /// The food being logged (name, brand, serving size and all nutrients).
  final ShelfFood food;
  final DateTime? selectedDateSecondStep;
  final String? breakfastMealAdd;
  final String? lunchMealAdd;
  final String? snacksMealAdd;
  final String? dinnerMealAdd;

  /// Non-null when opened from a meal builder (saves to meals/{mealId}).
  final String? mealIdValue;

  const FoodDetails({
    super.key,
    required this.food,
    this.selectedDateSecondStep,
    this.breakfastMealAdd,
    this.lunchMealAdd,
    this.snacksMealAdd,
    this.dinnerMealAdd,
    this.mealIdValue,
  });

  @override
  State<FoodDetails> createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  String selectedMealValue() {
    for (final meal in [
      widget.breakfastMealAdd,
      widget.lunchMealAdd,
      widget.snacksMealAdd,
      widget.dinnerMealAdd,
    ]) {
      if (meal != null && meal.isNotEmpty) return meal;
    }
    return '';
  }

  final portionSizeController = TextEditingController();

  /// Parsed portion size; falls back to 0 when empty/invalid.
  int get _portionSize => int.tryParse(portionSizeController.text) ?? 0;

  /// One vitamin/mineral row of the facts panel.
  Widget _vitaminRow(String label, String percent) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: notBoldTextOnLabel),
        Text(percent, style: notBoldTextOnLabel),
      ],
    );
  }

  /// Whether this screen is opened from a meal builder (has a mealId).
  bool get _isMealContext => widget.mealIdValue != null;

  Widget _bottomAction(IconData icon, Function callback) {
    return Icon(icon, color: const Color(0xFF1e1f38));
  }

  Future<void> _save() async {
    if (_isMealContext) {
      await _saveFoodItemToMeal();
    } else {
      updateTimesAddedCount();
      await saveFoodToMeal();
    }
  }

  int _caloriesIntake() {
    final caloriesIntake =
        (_portionSize / widget.food.servingSize) * widget.food.calories;
    return caloriesIntake.toInt();
  }

  int _totalFatIntake() {
    final totalFatIntake =
        (_portionSize / widget.food.servingSize) * widget.food.totalFat;
    return totalFatIntake.toInt();
  }

  int _saturatedFatIntake() {
    final saturatedFatIntake =
        (_portionSize / widget.food.servingSize) * widget.food.saturatedFat;
    return saturatedFatIntake.toInt();
  }

  int _transFatIntake() {
    final transFatIntake =
        (_portionSize / widget.food.servingSize) * widget.food.transFat;
    return transFatIntake.toInt();
  }

  int _cholesterolIntake() {
    final cholesterolIntake =
        (_portionSize / widget.food.servingSize) * widget.food.cholesterol;
    return cholesterolIntake.toInt();
  }

  int _sodiumIntake() {
    final sodiumIntake =
        (_portionSize / widget.food.servingSize) * widget.food.sodium;
    return sodiumIntake.toInt();
  }

  int _totalCarbohydrateIntake() {
    final totalCarbohydrateIntake =
        (_portionSize / widget.food.servingSize) *
        widget.food.totalCarbohydrate;
    return totalCarbohydrateIntake.toInt();
  }

  int _dietaryFiberIntake() {
    final dietaryFiberIntake =
        (_portionSize / widget.food.servingSize) * widget.food.dietaryFiber;
    return dietaryFiberIntake.toInt();
  }

  int _sugarsIntake() {
    final sugarsIntake =
        (_portionSize / widget.food.servingSize) * widget.food.sugars;
    return sugarsIntake.toInt();
  }

  int _proteinIntake() {
    final proteinIntake =
        (_portionSize / widget.food.servingSize) * widget.food.protein;
    return proteinIntake.toInt();
  }

  int _calciumIntake() {
    final calciumIntake =
        (_portionSize / widget.food.servingSize) * widget.food.calcium;
    return calciumIntake.toInt();
  }

  int _ironIntake() {
    final ironIntake =
        (_portionSize / widget.food.servingSize) * widget.food.iron;
    return ironIntake.toInt();
  }

  int _potassiumIntake() {
    final potassiumIntake =
        (_portionSize / widget.food.servingSize) * widget.food.potassium;
    return potassiumIntake.toInt();
  }

  int _vitaminAIntake() {
    final vitaminAIntake =
        (_portionSize / widget.food.servingSize) * widget.food.vitaminA;
    return vitaminAIntake.toInt();
  }

  int _vitaminCIntake() {
    final vitaminCIntake =
        (_portionSize / widget.food.servingSize) * widget.food.vitaminC;
    return vitaminCIntake.toInt();
  }

  int _vitaminDIntake() {
    final vitaminDIntake =
        (_portionSize / widget.food.servingSize) * widget.food.vitaminD;
    return vitaminDIntake.toInt();
  }

  int _magnesiumIntake() {
    final magnesiumIntake =
        (_portionSize / widget.food.servingSize) * widget.food.magnesium;
    return magnesiumIntake.toInt();
  }

  int _zincIntake() {
    final zincIntake =
        (_portionSize / widget.food.servingSize) * widget.food.zinc;
    return zincIntake.toInt();
  }

  dynamic breakfastCalories() {
    final breakfastCalories = _caloriesIntake();
    return breakfastCalories;
  }

  dynamic lunchCalories() {
    final lunchCalories = _caloriesIntake();
    return lunchCalories;
  }

  dynamic snacksCalories() {
    final snacksCalories = _caloriesIntake();
    return snacksCalories;
  }

  dynamic dinnerCalories() {
    final dinnerCalories = _caloriesIntake();
    return dinnerCalories;
  }

  double totalFatPercentage() {
    return (widget.food.totalFat / totalFatDailyValue) * 100;
  }

  double saturatedFatPercentage() {
    return (widget.food.saturatedFat / saturatedFatDailyValue) * 100;
  }

  double cholesterolPercentage() {
    return (widget.food.cholesterol / cholesterolDailyValue) * 100;
  }

  double sodiumPercentage() {
    return (widget.food.sodium / sodiumDailyValue) * 100;
  }

  double totalCarbohydratePercentage() {
    return (widget.food.totalCarbohydrate / totalCarbohydrateDailyValue) * 100;
  }

  double dietaryFiberPercentage() {
    return (widget.food.dietaryFiber / dietaryFiberDailyValue) * 100;
  }

  double addedSugarsPercentage() {
    return (widget.food.addedSugars / addedSugarsDailyValue) * 100;
  }

  double vitaminDPercentage() {
    return (widget.food.vitaminD / vitaminDDailyValue) * 100;
  }

  double calciumPercentage() {
    return (widget.food.calcium / calciumDailyValue) * 100;
  }

  double ironPercentage() {
    return (widget.food.iron / ironDailyValue) * 100;
  }

  double potassiumPercentage() {
    return (widget.food.potassium / potassiumDailyValue) * 100;
  }

  double vitaminCPercentage() {
    return (widget.food.vitaminC / vitaminCDailyValue) * 100;
  }

  double vitaminAPercentage() {
    return (widget.food.vitaminA / vitaminADailyValue) * 100;
  }

  double addedSugarsValue() => widget.food.addedSugars;

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
            child: const Icon(Icons.chevron_left, size: 40),
          ),
          backgroundColor: primaryBackgroundColor,
          centerTitle: true,
          title: const Text('Nutrition Facts'),
        ),
        bottomNavigationBar: _isMealContext
            ? null
            : BottomAppBar(
                color: const Color(0xFF1e1f38),
                notchMargin: 8.0,
                shape: const CircularNotchedRectangle(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    _bottomAction(Icons.cleaning_services_outlined, () {}),
                    const SizedBox(width: 150.0),
                  ],
                ),
              ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _isMealContext
            ? null
            : FloatingActionButton(
                backgroundColor: primaryButtonColor,
                child: const Icon(Icons.add),
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final scaffoldMessenger = ScaffoldMessenger.of(context);
                  try {
                    await _save();
                    if (!mounted) return;
                    navigator.pop();
                  } on Object {
                    if (!mounted) return;
                    scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Could not save the food entry. '
                            'Please check your connection and try again.',
                          ),
                        ),
                      );
                  }
                },
              ),
        body: _isMealContext
            ? Column(
                children: <Widget>[
                  Expanded(child: _foodDetailsBody()),
                  _addMealFoodItemsButton(),
                ],
              )
            : _foodDetailsBody(),
      ),
    );
  }

  Widget _foodDetailsBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              border: Border.all(color: foodDetailsBorderColor),
            ),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.food.foodName,
                    style: textColor.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 32.0,
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                  child: Text(
                    widget.food.brandName,
                    style: textColor.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Enter amount had:',
                      style: textColor.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: notBoldTextOnLabel,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'g',
                          hintStyle: textColor,
                        ),
                        controller: portionSizeController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                        ],
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Serving size',
                        style: textColor.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        ' ',
                        style: textColor.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        '(${widget.food.servingSize.toStringAsFixed(0)}g)',
                        style: textColor.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 15,
                  thickness: 14,
                  color: foodDetailsBorderColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Calories',
                      style: textColor.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 40,
                      ),
                    ),
                    Text(
                      widget.food.calories.toStringAsFixed(0),
                      style: textColor.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 60,
                      ),
                    ),
                  ],
                ),
                semiThickDivider,
                Container(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '% Daily Value*',
                    style: textColor.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 16.0,
                    ),
                  ),
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          'Total Fat ',
                          style: textColor.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          '${widget.food.totalFat.toStringAsFixed(0)}g',
                          style: notBoldTextOnLabel,
                        ),
                      ],
                    ),
                    Text(
                      '${totalFatPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel,
                    ),
                  ],
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          const Text('Saturated Fat ', style: notBoldTextOnLabel),
                          Text(
                            '${widget.food.saturatedFat.toStringAsFixed(0)}g',
                            style: notBoldTextOnLabel,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${saturatedFatPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel,
                    ),
                  ],
                ),
                thinDivider,
                Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        'Trans Fat ',
                        style: textColor.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Text(
                        '${widget.food.transFat.toStringAsFixed(0)}g',
                        style: notBoldTextOnLabel,
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
                        const Text('Cholesterol ', style: boldTextOnLabel),
                        Text(
                          '${widget.food.cholesterol.toStringAsFixed(0)}g',
                          style: notBoldTextOnLabel,
                        ),
                      ],
                    ),
                    Text(
                      '${cholesterolPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel,
                    ),
                  ],
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        const Text('Sodium ', style: boldTextOnLabel),
                        Text(
                          '${widget.food.sodium.toStringAsFixed(0)}g',
                          style: notBoldTextOnLabel,
                        ),
                      ],
                    ),
                    Text(
                      '${sodiumPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel,
                    ),
                  ],
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        const Text('Total Carbohydrate ', style: boldTextOnLabel),
                        Text(
                          '${widget.food.totalCarbohydrate.toStringAsFixed(0)}g',
                          style: notBoldTextOnLabel,
                        ),
                      ],
                    ),
                    Text(
                      '${totalCarbohydratePercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel,
                    ),
                  ],
                ),
                thinDivider,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        children: [
                          const Text('Dietary Fiber ', style: notBoldTextOnLabel),
                          Text(
                            '${widget.food.dietaryFiber.toStringAsFixed(0)}g',
                            style: notBoldTextOnLabel,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${dietaryFiberPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel,
                    ),
                  ],
                ),
                thinDivider,
                Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      const Text('Total Sugars ', style: notBoldTextOnLabel),
                      Text(
                        '${widget.food.sugars.toStringAsFixed(0)}g',
                        style: notBoldTextOnLabel,
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 8,
                  thickness: 1,
                  indent: 38,
                  color: foodDetailsBorderColor,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 35),
                      child: Row(
                        children: [
                          Text(
                            'Includes ${addedSugarsValue().toStringAsFixed(0)}g Added Sugars',
                            style: notBoldTextOnLabel,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${addedSugarsPercentage().toStringAsFixed(0)}%',
                      style: boldTextOnLabel,
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Protein ', style: boldTextOnLabel),
                    Text(
                      '${widget.food.protein.toStringAsFixed(0)}g',
                      style: notBoldTextOnLabel,
                    ),
                  ],
                ),
                const Divider(
                  height: 20,
                  thickness: 14,
                  color: foodDetailsBorderColor,
                ),
                _vitaminRow(
                  'Vitamin D ${widget.food.vitaminD.toStringAsFixed(0)}mcg',
                  '${vitaminDPercentage().toStringAsFixed(0)}%',
                ),
                thinDivider,
                _vitaminRow(
                  'Calcium ${widget.food.calcium.toStringAsFixed(0)}mg',
                  '${calciumPercentage().toStringAsFixed(0)}%',
                ),
                thinDivider,
                _vitaminRow(
                  'Iron ${widget.food.iron.toStringAsFixed(0)}mg',
                  '${ironPercentage().toStringAsFixed(0)}%',
                ),
                thinDivider,
                _vitaminRow(
                  'Potassium ${widget.food.potassium.toStringAsFixed(0)}mg',
                  '${potassiumPercentage().toStringAsFixed(0)}%',
                ),
                thinDivider,
                _vitaminRow(
                  'Vitamin C ${widget.food.vitaminC.toStringAsFixed(0)}mg',
                  '${vitaminCPercentage().toStringAsFixed(0)}%',
                ),
                thinDivider,
                _vitaminRow(
                  'Vitamin A ${widget.food.vitaminA.toStringAsFixed(0)}mcg',
                  '${vitaminAPercentage().toStringAsFixed(0)}%',
                ),
                const Divider(
                  height: 10,
                  thickness: 5,
                  color: foodDetailsBorderColor,
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 6),
                  child: Text(
                    '* The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. 2,000 calories a day is used for general nutrition advice.',
                    style: textColor.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(padding: const EdgeInsets.only(bottom: 20)),
        ],
      ),
    );
  }

  // Adds food items in meal to the food log
  Widget _addMealFoodItemsButton() {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50.0,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: primaryButtonColor,
            ),
            child: MaterialButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                try {
                  await _save();
                  if (!mounted) return;
                  navigator.pop();
                } on Object {
                  if (!mounted) return;
                  scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Could not add the food to your meal. '
                          'Please check your connection and try again.',
                        ),
                      ),
                    );
                }
              },
              child: const Text(
                'ADD FOOD TO MEAL',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveFoodItemToMeal() async {
    await context
        .read<MealRepository>()
        .addFoodItem(myUID(context), widget.mealIdValue!, {
          'foodId': widget.food.foodId,
          'foodName': widget.food.foodName,
          'brandName': widget.food.brandName,
          'mealId': widget.mealIdValue,
          'portionSize': _portionSize,
          'servingSize': widget.food.servingSize,
          'calories': _caloriesIntake(),
          'totalFat': _totalFatIntake(),
          'saturatedFat': _saturatedFatIntake(),
          'transFat': _transFatIntake(),
          'cholesterol': _cholesterolIntake(),
          'sodium': _sodiumIntake(),
          'totalCarbohydrate': _totalCarbohydrateIntake(),
          'dietaryFiber': _dietaryFiberIntake(),
          'sugars': _sugarsIntake(),
          'protein': _proteinIntake(),
          'calcium': _calciumIntake(),
          'iron': _ironIntake(),
          'potassium': _potassiumIntake(),
          'vitaminA': _vitaminAIntake(),
          'vitaminC': _vitaminCIntake(),
        });
  }

  Future<void> saveFoodToMeal() async {
    await context.read<FoodLogRepository>().addEntry(myUID(context), {
      'foodId': widget.food.foodId,
      'foodName': widget.food.foodName,
      'brandName': widget.food.brandName,
      'portionSize': _portionSize,
      'servingSize': widget.food.servingSize,
      'mealType': selectedMealValue(),
      'calories': _caloriesIntake(),
      'totalFat': _totalFatIntake(),
      'saturatedFat': _saturatedFatIntake(),
      'transFat': _transFatIntake(),
      'cholesterol': _cholesterolIntake(),
      'sodium': _sodiumIntake(),
      'totalCarbohydrate': _totalCarbohydrateIntake(),
      'dietaryFiber': _dietaryFiberIntake(),
      'sugars': _sugarsIntake(),
      'protein': _proteinIntake(),
      'calcium': _calciumIntake(),
      'iron': _ironIntake(),
      'potassium': _potassiumIntake(),
      'vitaminA': _vitaminAIntake(),
      'vitaminC': _vitaminCIntake(),
      'vitaminD': _vitaminDIntake(),
      'magnesium': _magnesiumIntake(),
      'zinc': _zincIntake(),
      'weekNo': getWeekNumber(widget.selectedDateSecondStep!),
      'month': cleanMonthFormat(widget.selectedDateSecondStep.toString()),
      'year': cleanYearFormat(widget.selectedDateSecondStep.toString()),
      'dateAdded': widget.selectedDateSecondStep,
      'breakfastCalories': breakfastCalories(),
      'lunchCalories': lunchCalories(),
      'snacksCalories': snacksCalories(),
      'dinnerCalories': dinnerCalories(),
    });
  }

  void updateTimesAddedCount() {
    unawaited(context.read<ShelfRepository>().incrementTimesAdded(
      myUID(context),
      widget.food.foodId,
    ));
  }
}
