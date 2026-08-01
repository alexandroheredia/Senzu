import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/theme.dart';

/// One label + numeric-input row of the add-food form.
class _NutrientField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final String? Function(String?)? validator;

  const _NutrientField({
    required this.label,
    required this.controller,
    required this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: textColor.copyWith(fontSize: 18)),
          SizedBox(
            width: 70,
            child: TextFormField(
              style: textColor,
              validator: validator,
              decoration: textInputDecoration.copyWith(hintText: hint),
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp('[,.0-9]')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// An optional nutrient that can be revealed via its checkbox.
class _OptionalNutrient {
  final String key;
  final String label;
  final TextEditingController controller;

  const _OptionalNutrient(this.key, this.label, this.controller);
}

class AddFood extends StatefulWidget {
  final String? foodIdValue;

  const AddFood({super.key, this.foodIdValue});

  @override
  State<AddFood> createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final foodNameController = TextEditingController();
  final brandNameController = TextEditingController();
  final servingSizeController = TextEditingController();
  final caloriesController = TextEditingController();
  final totalFatController = TextEditingController();
  final saturatedFatController = TextEditingController();
  final transFatController = TextEditingController();
  final cholesterolController = TextEditingController();
  final sodiumController = TextEditingController();
  final totalCarbohydrateController = TextEditingController();
  final dietaryFiberController = TextEditingController();
  final sugarsController = TextEditingController();
  final addedSugarsController = TextEditingController();
  final proteinController = TextEditingController();
  final vitaminDController = TextEditingController();
  final calciumController = TextEditingController();
  final ironController = TextEditingController();
  final potassiumController = TextEditingController();
  final vitaminAController = TextEditingController();
  final vitaminCController = TextEditingController();
  final vitaminB6Controller = TextEditingController();
  final folateController = TextEditingController();
  final thiaminController = TextEditingController();
  final magnesiumController = TextEditingController();
  final zincController = TextEditingController();
  final phosphorusController = TextEditingController();
  final riboflavinController = TextEditingController();
  final niacinController = TextEditingController();
  final pantothenicAcidController = TextEditingController();
  final vitaminEController = TextEditingController();

  /// Optional nutrients revealed by the "Additional fields" checkboxes.
  late final List<_OptionalNutrient> _optionalNutrients = [
    _OptionalNutrient(
      'vitaminD',
      'Vitamin D (100% = 10mcg)*',
      vitaminDController,
    ),
    _OptionalNutrient(
      'vitaminB6',
      'Vitamin B6 (100% = 1.7mg)*',
      vitaminB6Controller,
    ),
    _OptionalNutrient(
      'folate',
      'Folate (100% = 400mcg DFE)*',
      folateController,
    ),
    _OptionalNutrient('thiamin', 'Thiamin (100% = 1.2mg)*', thiaminController),
    _OptionalNutrient(
      'magnesium',
      'Magnesium (100% = 350mg)*',
      magnesiumController,
    ),
    _OptionalNutrient('zinc', 'Zinc (100% = 9mg)*', zincController),
    _OptionalNutrient(
      'phosphorus',
      'Phosphorus (100% = 1250mg)*',
      phosphorusController,
    ),
    _OptionalNutrient(
      'riboflavin',
      'Riboflavin (100% = 1.3mg)*',
      riboflavinController,
    ),
    _OptionalNutrient('niacin', 'Niacin (100% = 16mg)*', niacinController),
    _OptionalNutrient(
      'pantothenicAcid',
      'Pantothenic Acid (100% = 5mg)*',
      pantothenicAcidController,
    ),
    _OptionalNutrient(
      'vitaminE',
      'Vitamin E (100% = 15mg)*',
      vitaminEController,
    ),
  ];

  @override
  void dispose() {
    for (final c in [
      foodNameController,
      brandNameController,
      servingSizeController,
      caloriesController,
      totalFatController,
      saturatedFatController,
      transFatController,
      cholesterolController,
      sodiumController,
      totalCarbohydrateController,
      dietaryFiberController,
      sugarsController,
      addedSugarsController,
      proteinController,
      vitaminDController,
      calciumController,
      ironController,
      potassiumController,
      vitaminAController,
      vitaminCController,
      vitaminB6Controller,
      folateController,
      thiaminController,
      magnesiumController,
      zincController,
      phosphorusController,
      riboflavinController,
      niacinController,
      pantothenicAcidController,
      vitaminEController,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  bool loading = false;

  /// Keys of the optional nutrient fields currently revealed.
  final Set<String> _visible = {};

  final _addFoodFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragDown: (details) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: primaryBackgroundColor,
        appBar: AppBar(
          backgroundColor: primaryBackgroundColor,
          centerTitle: true,
          title: const Text('Add To Your Shelf'),
        ),
        bottomNavigationBar: const BottomAppBar(
          color: Color(0xFF1e1f38),
          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[SizedBox(height: 40, width: 150.0)],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          heroTag: 'add_food_button',
          backgroundColor: primaryButtonColor,
          onPressed: () async {
            final navigator = Navigator.of(context);
            final scaffoldMessenger = ScaffoldMessenger.of(context);
            final shelf = context.read<ShelfRepository>();
            try {
              if (_addFoodFormKey.currentState!.validate()) {
                setState(() => loading = true);
                await saveFoodToShelf();
                await shelf.addToCatalog(widget.foodIdValue!, _foodData());
                if (!mounted) return;
                navigator.pop();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text('Food item added successfully'),
                  ),
                );
              } else {
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('Please fill the required boxes')),
                );
              }
            } on Object {
              if (mounted) {
                setState(() => loading = false);
                scaffoldMessenger.showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Could not save the food item. '
                      'Please check your connection and try again.',
                    ),
                  ),
                );
              }
            }
          },
          child: Center(
            child: Builder(
              builder: (context) {
                return loading ? loadingWidget : const Icon(Icons.add);
              },
            ),
          ),
        ),
        body: addFoodForm(),
      ),
    );
  }

  String? _required(String? value) =>
      (value == null || value.isEmpty) ? 'Required' : null;

  Widget addFoodForm() {
    return SingleChildScrollView(
      child: Form(
        key: _addFoodFormKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              _NutrientField(
                label: 'Food Name',
                  controller: foodNameController,
                  hint: 'Food Name',
                  validator: _required,
                ),
                _NutrientField(
                  label: 'Brand / Category',
                  controller: brandNameController,
                  hint: 'Brand / Category',
                ),
                _NutrientField(
                  label: 'Amount per serving (g/mL)',
                  controller: servingSizeController,
                  hint: 'g/mL',
                  validator: _required,
                ),
                _NutrientField(
                  label: 'Calories (kcal)',
                  controller: caloriesController,
                  hint: 'kcal',
                ),
                _NutrientField(
                  label: 'Total Fat',
                  controller: totalFatController,
                  hint: 'g',
                ),
                _NutrientField(
                  label: 'Saturated Fat',
                  controller: saturatedFatController,
                  hint: 'g',
                ),
                _NutrientField(
                  label: 'Trans Fat',
                  controller: transFatController,
                  hint: 'g',
                ),
                _NutrientField(
                  label: 'Cholesterol',
                  controller: cholesterolController,
                  hint: 'mg',
                ),
                _NutrientField(
                  label: 'Sodium/Salt',
                  controller: sodiumController,
                  hint: 'mg',
                ),
                _NutrientField(
                  label: 'Total Carbohydrate',
                  controller: totalCarbohydrateController,
                  hint: 'g',
                ),
                _NutrientField(
                  label: 'Dietary Fiber',
                  controller: dietaryFiberController,
                  hint: 'g',
                ),
                _NutrientField(
                  label: 'Sugars',
                  controller: sugarsController,
                  hint: 'g',
                ),
                _NutrientField(
                  label: 'Added sugars',
                  controller: addedSugarsController,
                  hint: 'g',
                ),
                _NutrientField(
                  label: 'Protein',
                  controller: proteinController,
                  hint: 'g',
                ),
                _NutrientField(
                  label: 'Calcium (100% = 800mg)*',
                  controller: calciumController,
                  hint: '%',
                ),
                _NutrientField(
                  label: 'Iron (100% = 9mg)*',
                  controller: ironController,
                  hint: '%',
                ),
                _NutrientField(
                  label: 'Potassium (100% = 3500mg)',
                  controller: potassiumController,
                  hint: '%',
                ),
                _NutrientField(
                  label: 'Vitamin A (100% = 900mcg)*',
                  controller: vitaminAController,
                  hint: '%',
                ),
                _NutrientField(
                  label: 'Vitamin C (100% = 75mg)*',
                  controller: vitaminCController,
                  hint: '%',
                ),
                for (final nutrient in _optionalNutrients)
                  if (_visible.contains(nutrient.key))
                    _NutrientField(
                      label: nutrient.label,
                      controller: nutrient.controller,
                      hint: '%',
                    ),
                const SizedBox(height: 10),
                const Divider(
                  thickness: 1,
                  indent: 5,
                  endIndent: 5,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Additional fields',
                      style: textColor.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                for (final nutrient in _optionalNutrients)
                  Theme(
                    data: ThemeData(unselectedWidgetColor: Colors.white),
                    child: CheckboxListTile(
                      title: Text(
                        nutrient.label.split(' (')[0],
                        style: textColor.copyWith(fontSize: 20),
                      ),
                      activeColor: primaryButtonColor,
                      controlAffinity: ListTileControlAffinity.trailing,
                      value: _visible.contains(nutrient.key),
                      onChanged: (show) {
                        setState(() {
                          if (show ?? false) {
                            _visible.add(nutrient.key);
                          } else {
                            _visible.remove(nutrient.key);
                          }
                        });
                      },
                    ),
                  ),
                const SizedBox(height: 25),
                SizedBox(
                  height: 60,
                  width: 320,
                  child: Text(
                    '* The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. 2,000 calories a day is used for general nutrition advice.',
                    style: textColor.copyWith(fontSize: 13),
                    textAlign: TextAlign.justify,
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      );
  }

  /// Parses a controller value to a double; 0 when empty/invalid.
  double _parse(TextEditingController c) {
    final text = c.text.replaceAll(',', '.').trim();
    return text.isEmpty ? 0 : double.parse(text);
  }

  /// Converts a %-DV input to the absolute nutrient amount.
  double _percent(TextEditingController c, num dailyValue) {
    return _parse(c) / 100 * dailyValue;
  }

  /// The food document shared by the shelf and global-food collections.
  Map<String, dynamic> _foodData() {
    double raw(TextEditingController c) => _parse(c);
    double pct(TextEditingController c, num daily) => _percent(c, daily);
    return {
      'foodId': widget.foodIdValue,
      'foodName': foodNameController.text,
      'brandName': brandNameController.text,
      'servingSize': raw(servingSizeController),
      'calories': raw(caloriesController),
      'totalFat': raw(totalFatController),
      'saturatedFat': raw(saturatedFatController),
      'transFat': raw(transFatController),
      'cholesterol': raw(cholesterolController),
      'sodium': raw(sodiumController),
      'totalCarbohydrate': raw(totalCarbohydrateController),
      'dietaryFiber': raw(dietaryFiberController),
      'sugars': raw(sugarsController),
      'addedSugars': raw(addedSugarsController),
      'protein': raw(proteinController),
      'vitaminD': pct(vitaminDController, vitaminDDailyValue),
      'calcium': pct(calciumController, calciumDailyValue),
      'iron': pct(ironController, ironDailyValue),
      'potassium': pct(potassiumController, potassiumDailyValue),
      'vitaminA': pct(vitaminAController, vitaminADailyValue),
      'vitaminC': pct(vitaminCController, vitaminCDailyValue),
      'vitaminB6': pct(vitaminB6Controller, vitaminB6DailyValue),
      'folate': pct(folateController, folateDailyValue),
      'thiamin': pct(thiaminController, thiaminDailyValue),
      'magnesium': pct(magnesiumController, magnesiumDailyValue),
      'zinc': pct(zincController, zincDailyValue),
      'phosphorus': pct(phosphorusController, phosphorusDailyValue),
      'riboflavin': pct(riboflavinController, riboflavinDailyValue),
      'niacin': pct(niacinController, niacinDailyValue),
      'pantothenicAcid': pct(
        pantothenicAcidController,
        pantothenicAcidDailyValue,
      ),
      'vitaminE': pct(vitaminEController, vitaminEDailyValue),
    };
  }

  // Saves manual food entry to the user's shelf collection
  // "database/users/userID/foodShelf/"
  Future<void> saveFoodToShelf() async {
    await context.read<ShelfRepository>().addFood(
      myUID(context),
      widget.foodIdValue!,
      {..._foodData(), 'timesAdded': 0},
    );
  }

  // Saves manual food entry to the root database/foods collection
  Future<void> saveToFoodDatabase(BuildContext context) async {
    await context.read<ShelfRepository>().addToCatalog(widget.foodIdValue!, _foodData());
  }
}
