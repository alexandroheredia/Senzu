import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senzu_app/screens/authentication/utils/snackbar.dart';
import 'package:senzu_app/shared/constants.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';

class AddFood extends StatefulWidget {
  
  final String? foodIdValue;

  AddFood({
    Key? key, 
    this.foodIdValue
    }) : super(key: key);

  @override
  _AddFoodState createState() => _AddFoodState();
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
  

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    foodNameController.dispose();
    brandNameController.dispose();
    servingSizeController.dispose();
    caloriesController.dispose();
    totalFatController.dispose();
    saturatedFatController.dispose();
    transFatController.dispose();
    cholesterolController.dispose();
    sodiumController.dispose();
    totalCarbohydrateController.dispose();
    dietaryFiberController.dispose();
    sugarsController.dispose();
    addedSugarsController.dispose();
    proteinController.dispose();
    vitaminDController.dispose();
    calciumController.dispose();
    ironController.dispose();
    potassiumController.dispose();
    vitaminAController.dispose();
    vitaminCController.dispose();
    vitaminB6Controller.dispose();
    folateController.dispose();
    thiaminController.dispose();
    magnesiumController.dispose();
    zincController.dispose();
    phosphorusController.dispose();
    riboflavinController.dispose();
    niacinController.dispose();
    pantothenicAcidController.dispose();
    vitaminEController.dispose();
    super.dispose();
  }


  String error = '';
  bool loading = false;


  bool caloriesVisibility = false;
  bool totalFatVisibility = false;
  bool saturatedFatVisibility = false;
  bool transFatVisibility = false;
  bool cholesterolVisibility = false;
  bool sodiumVisibility = false;
  bool totalCarbohydrateVisibility = false;
  bool dietaryFiberVisibility = false;
  bool sugarsVisibility = false;
  bool addedSugarsVisibility = false;
  bool proteinVisibility = false;
  bool vitaminDVisibility = false;
  bool calciumVisibility = false;
  bool ironVisibility = false;
  bool potassiumVisibility = false;
  bool vitaminAVisibility = false;
  bool vitaminCVisibility = false;
  bool vitaminB6Visibility = false;
  bool folateVisibility = false;
  bool thiaminVisibility = false;
  bool magnesiumVisibility = false;
  bool zincVisibility = false;
  bool phosphorusVisibility = false;
  bool riboflavinVisibility = false;
  bool niacinVisibility = false;
  bool pantothenicAcidVisibility = false;
  bool vitaminEVisibility = false;


  // Widget _bottomAction(IconData icon, Function callback) {
  //   return InkWell(
  //     child: Padding(
  //       padding: const EdgeInsets.all(8.0),
  //       child: Icon(icon, color: Color(0xFF1e1f38),)
  //       ),
  //     onTap: callback,
  //   );
  // }
  
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
          title: Text('Add To Your Shelf'),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFF1e1f38),
          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    
            children: <Widget>[
              // _bottomAction(FontAwesomeIcons.smileWink, () {}),
              // _bottomAction(FontAwesomeIcons.chartPie, () {}),
              SizedBox(
                height: 40,
                width: 150.0),
              // _bottomAction(FontAwesomeIcons.wallet, () {}),
    
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          heroTag: "add_food_button",
          backgroundColor: primaryButtonColor,
          onPressed: () async {
            // print(saturatedFatController.text.replaceAll(',', '.'));
            try {
              if (_addFoodFormKey.currentState!.validate()) {
                setState(() => loading = true);
                await saveFoodToShelf();
                await saveToFoodDatabase(context);
                if (!mounted) return;
                Navigator.of(context).pop();
                CustomSnackBar(
                    context, const Text('Food item added successfully'));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill the required boxes')));
              }
            } catch (e) {
              if (mounted) {
                setState(() => loading = false);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Could not save the food item. '
                        'Please check your connection and try again.')));
              }
            }
          },
          child: Container(
            child: Center(
              child: Builder(
                builder: (context) {
                  return loading ? loadingWidget : Icon(Icons.add);
                },
              ),
            ),
          ),
        ),
        body: addFoodForm(),
      ),
    );
  }

Widget addFoodForm() {
  return SingleChildScrollView(
      child: Form(
        key: _addFoodFormKey,
              child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        style: textColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Food Name'),
                        controller: foodNameController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'Brand / Category'),
                        controller: brandNameController,
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Amount per serving (g/mL)',
                      style: textColor.copyWith(fontSize: 18, ),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Required';
                          }
                          return null;
                        },
                        decoration: textInputDecoration.copyWith(hintText: 'g/mL'),
                        controller: servingSizeController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Calories (kcal)',
                      style: textColor.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'kcal'),
                        controller: caloriesController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total Fat',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'g'),
                        controller: totalFatController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Saturated Fat',
                      style: textColor.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'g'),
                        controller: saturatedFatController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Trans Fat',
                      style: textColor.copyWith(fontSize: 18),
                    ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'g'),
                        controller: transFatController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Cholesterol',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'mg'),
                        controller: cholesterolController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Sodium/Salt',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'mg'),
                        controller: sodiumController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Total Carbohydrate',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'g'),
                        controller: totalCarbohydrateController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Dietary Fiber',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'g'),
                        controller: dietaryFiberController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Sugars',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'g'),
                        controller: sugarsController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Added sugars',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'g'),
                        controller: addedSugarsController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Protein',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: 'g'),
                        controller: proteinController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Calcium (100% = 800mg)*',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: '%'),
                        controller: calciumController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Iron (100% = 9mg)*',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: '%'),
                        controller: ironController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Potassium (100% = 3500mg)',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: '%'),
                        controller: potassiumController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Vitamin A (100% = 900mcg)*',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: '%'),
                        controller: vitaminAController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Vitamin C (100% = 75mg)*',
                      style: textColor.copyWith(fontSize: 18),
                      ),
                    SizedBox(
                      width: 70,
                      child: TextFormField(
                        style: textColor,
                        decoration: textInputDecoration.copyWith(hintText: '%'),
                        controller: vitaminCController,
                        keyboardType: TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: vitaminDVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Vitamin D (100% = 10mcg)*',
                        style: textColor.copyWith(fontSize: 18),
                        ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: vitaminDController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: vitaminB6Visibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Vitamin B6 (100% = 	1.7mg)*',
                        style: textColor.copyWith(fontSize: 18),
                        ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: vitaminB6Controller,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: folateVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Folate (100% = 400mcg DFE)*',
                        style: textColor.copyWith(fontSize: 18),
                        ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: folateController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: thiaminVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Thiamin (100% = 1.2mg)*',
                        style: textColor.copyWith(fontSize: 18),
                        ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: thiaminController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: magnesiumVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Magnesium (100% = 350mg)*',
                        style: textColor.copyWith(fontSize: 18),
                        ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: magnesiumController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: zincVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Zinc (100% = 9mg)*',
                        style: textColor.copyWith(fontSize: 18),
                        ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: zincController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: phosphorusVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Phosphorus (100% = 1250mg)*',
                        style: textColor.copyWith(fontSize: 18),
                        ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: phosphorusController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: riboflavinVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Riboflavin (100% = 1.3mg)*',
                        style: textColor.copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: riboflavinController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: niacinVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Niacin (100% = 16mg)*',
                        style: textColor.copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: niacinController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: pantothenicAcidVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Pantothenic Acid (100% = 5mg)*',
                        style: textColor.copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: pantothenicAcidController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: vitaminEVisibility,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Vitamin E (100% = 15mg)*',
                        style: textColor.copyWith(fontSize: 18),
                      ),
                      SizedBox(
                        width: 70,
                        child: TextFormField(
                          style: textColor,
                          decoration: textInputDecoration.copyWith(hintText: '%'),
                          controller: vitaminEController,
                          keyboardType: TextInputType.numberWithOptions(decimal: true),
                          inputFormatters: [ FilteringTextInputFormatter.allow((RegExp("[,.0-9]"))) ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                thickness: 1,
                indent: 5,
                endIndent: 5,
                color: Colors.white,
              ),
              SizedBox(height: 10,),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Additional fields',
                    style: textColor.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Vitamin D",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: vitaminDVisibility,
                  onChanged: (bool? showVitaminDField) {
                    setState(() {
                      vitaminDVisibility = showVitaminDField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Vitamin B6",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: vitaminB6Visibility,
                  onChanged: (bool? showVitaminB6Field) {
                    setState(() {
                      vitaminB6Visibility = showVitaminB6Field ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Folate",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: folateVisibility,
                  onChanged: (bool? showFolateField) {
                    setState(() {
                      folateVisibility = showFolateField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Thiamin",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: thiaminVisibility,
                  onChanged: (bool? showThiaminField) {
                    setState(() {
                      thiaminVisibility = showThiaminField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Magnesium",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: magnesiumVisibility,
                  onChanged: (bool? showMagnesiumField) {
                    setState(() {
                      magnesiumVisibility = showMagnesiumField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Zinc",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: zincVisibility,
                  onChanged: (bool? showZincField) {
                    setState(() {
                      zincVisibility = showZincField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Phosphorus",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: phosphorusVisibility,
                  onChanged: (bool? showPhosphorusField) {
                    setState(() {
                      phosphorusVisibility = showPhosphorusField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Riboflavin",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: riboflavinVisibility,
                  onChanged: (bool? showRiboflavinField) {
                    setState(() {
                      riboflavinVisibility = showRiboflavinField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Niacin",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: niacinVisibility,
                  onChanged: (bool? showNiacinField) {
                    setState(() {
                      niacinVisibility = showNiacinField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Pantothenic Acid",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: pantothenicAcidVisibility,
                  onChanged: (bool? showPantothenicAcidField) {
                    setState(() {
                      pantothenicAcidVisibility = showPantothenicAcidField ?? false;
                    });
                  },
                ),
              ),
              Theme(
                data: ThemeData(unselectedWidgetColor: Colors.white),
                child: CheckboxListTile(
                  title: Text("Vitamin E",
                    style: textColor.copyWith(fontSize: 20),
                  ),
                  activeColor: primaryButtonColor,
                  controlAffinity: ListTileControlAffinity.trailing,
                  value: vitaminEVisibility,
                  onChanged: (bool? showVitaminEField) {
                    setState(() {
                      vitaminEVisibility = showVitaminEField ?? false;
                    });
                  },
                ),
              ),
              SizedBox(height: 25,),
              SizedBox(
                height: 60,
                width: 320,
                child: Text('* The % Daily Value (DV) tells you how much a nutrient in a serving of food contributes to a daily diet. 2,000 calories a day is used for general nutrition advice.',
                  style: textColor.copyWith(fontSize: 13,),
                      textAlign: TextAlign.justify,
                    ),
                  ),
              SizedBox(height: 25,),
            ],
          ),
        ),
    ),
      ),
  );

}


   _ironPercentage(){
     var ironPercentage = (double.parse(ironController.text.replaceAll(',', '.')) / 100) * ironDailyValue;
     return ironPercentage.toStringAsFixed(2);
   }

   _calciumPercentage(){
     var calciumPercentage = (double.parse(calciumController.text.replaceAll(',', '.')) / 100) * calciumDailyValue;
     return calciumPercentage.toStringAsFixed(2);
   }

   _potassiumPercentage(){
     var potassiumPercentage = (double.parse(potassiumController.text.replaceAll(',', '.')) / 100) * potassiumDailyValue;
     return potassiumPercentage.toStringAsFixed(2);
   }

   _vitaminAPercentage(){
     var vitaminAPercentage = (double.parse(vitaminAController.text.replaceAll(',', '.')) / 100) * vitaminADailyValue;
     return vitaminAPercentage.toStringAsFixed(2);
   }

   _vitaminCPercentage(){
     var vitaminCPercentage = (double.parse(vitaminCController.text.replaceAll(',', '.')) / 100) * vitaminCDailyValue;
     return vitaminCPercentage.toStringAsFixed(2);
   }

   _vitaminDPercentage(){
     var vitaminDPercentage = (double.parse(vitaminDController.text.replaceAll(',', '.')) / 100) * vitaminDDailyValue;
     return vitaminDPercentage.toStringAsFixed(2);
   }

   _vitaminB6Percentage(){
     var vitaminB6Percentage = (double.parse(vitaminB6Controller.text.replaceAll(',', '.')) / 100) * vitaminB6DailyValue;
     return vitaminB6Percentage.toStringAsFixed(2);
   }
   
   _folatePercentage(){
     var folatePercentage = (double.parse(folateController.text.replaceAll(',', '.')) / 100) * folateDailyValue;
     return folatePercentage.toStringAsFixed(2);
   }

    _thiaminPercentage(){
    var thiaminPercentage = (double.parse(thiaminController.text.replaceAll(',', '.')) / 100) * thiaminDailyValue;
    return thiaminPercentage.toStringAsFixed(2);
  }

   _magnesiumPercentage(){
     var magnesiumPercentage = (double.parse(magnesiumController.text.replaceAll(',', '.')) / 100) * magnesiumDailyValue;
     return magnesiumPercentage.toStringAsFixed(2);
   }

   _zincPercentage(){
     var zincPercentage = (double.parse(zincController.text.replaceAll(',', '.')) / 100) * zincDailyValue;
     return zincPercentage.toStringAsFixed(2);
   }

   _phosphorusPercentage(){
     var phosphorusPercentage = (double.parse(phosphorusController.text.replaceAll(',', '.')) / 100) * phosphorusDailyValue;
     return phosphorusPercentage.toStringAsFixed(2);
   }

   _riboflavinPercentage(){
     var riboflavinPercentage = (double.parse(riboflavinController.text.replaceAll(',', '.')) / 100) * riboflavinDailyValue;
     return riboflavinPercentage.toStringAsFixed(2);
   }

   _niacinPercentage(){
     var niacinPercentage = (double.parse(niacinController.text.replaceAll(',', '.')) / 100) * niacinDailyValue;
     return niacinPercentage.toStringAsFixed(2);
   }

   _pantothenicAcidPercentage(){
     var pantothenicAcidPercentage = (double.parse(pantothenicAcidController.text.replaceAll(',', '.')) / 100) * pantothenicAcidDailyValue;
     return pantothenicAcidPercentage.toStringAsFixed(2);
   }

   _vitaminEPercentage(){
     var vitaminEPercentage = (double.parse(vitaminEController.text.replaceAll(',', '.')) / 100) * vitaminEDailyValue;
     return vitaminEPercentage.toStringAsFixed(2);
   }


  // Saves manual food entry to the user's shelf collection "database/users/userID/foodShelf/"
  Future<void> saveFoodToShelf() async {

    await dbUsersCollection
      .doc(myUID(context))
      .collection('foodShelf')
      .doc(widget.foodIdValue)
      .set({
      "foodId": widget.foodIdValue,
      "foodName": foodNameController.text,
      "brandName": brandNameController.text,
      "servingSize": servingSizeController.text.isNotEmpty ? double.parse(servingSizeController.text) : 0,
      "calories": caloriesController.text.isNotEmpty ? double.parse(caloriesController.text.replaceAll(',', '.')) : 0,
      "totalFat": totalFatController.text.isNotEmpty ? double.parse(totalFatController.text.replaceAll(',', '.')) : 0,
      "saturatedFat": saturatedFatController.text.isNotEmpty ? double.parse(saturatedFatController.text.replaceAll(',', '.')) : 0,
      "transFat": transFatController.text.isNotEmpty ? double.parse(transFatController.text.replaceAll(',', '.')) : 0,
      "cholesterol": cholesterolController.text.isNotEmpty ? double.parse(cholesterolController.text.replaceAll(',', '.')) : 0,
      "sodium": sodiumController.text.isNotEmpty ? double.parse(sodiumController.text.replaceAll(',', '.')) : 0,
      "totalCarbohydrate": totalCarbohydrateController.text.isNotEmpty ? double.parse(totalCarbohydrateController.text.replaceAll(',', '.')) : 0,
      "dietaryFiber": dietaryFiberController.text.isNotEmpty ? double.parse(dietaryFiberController.text.replaceAll(',', '.')) : 0,
      "sugars": sugarsController.text.isNotEmpty ? double.parse(sugarsController.text.replaceAll(',', '.')) : 0,
      "addedSugars": addedSugarsController.text.isNotEmpty ? double.parse(addedSugarsController.text.replaceAll(',', '.')) : 0,
      "protein": proteinController.text.isNotEmpty ? double.parse(proteinController.text.replaceAll(',', '.')) : 0,
      "vitaminD": vitaminDController.text.isNotEmpty ? double.parse(_vitaminDPercentage()) : 0,
      "calcium": calciumController.text.isNotEmpty ? double.parse(_calciumPercentage()) : 0,
      "iron": ironController.text.isNotEmpty ? double.parse(_ironPercentage()) : 0,
      "potassium": potassiumController.text.isNotEmpty ? double.parse(_potassiumPercentage()) : 0,
      "vitaminA": vitaminAController.text.isNotEmpty ? double.parse(_vitaminAPercentage()) : 0,
      "vitaminC": vitaminCController.text.isNotEmpty ? double.parse(_vitaminCPercentage()) : 0,
      "vitaminB6": vitaminB6Controller.text.isNotEmpty ? double.parse(_vitaminB6Percentage()) : 0,
      "folate": folateController.text.isNotEmpty ? double.parse(_folatePercentage()) : 0,
      "thiamin": thiaminController.text.isNotEmpty ? double.parse(_thiaminPercentage()) : 0,
      "magnesium": magnesiumController.text.isNotEmpty ? double.parse(_magnesiumPercentage()) : 0,
      "zinc": zincController.text.isNotEmpty ? double.parse(_zincPercentage()) : 0,
      "phosphorus": phosphorusController.text.isNotEmpty ? double.parse(_phosphorusPercentage()) : 0,
      "riboflavin": riboflavinController.text.isNotEmpty ? double.parse(_riboflavinPercentage()) : 0,
      "niacin": niacinController.text.isNotEmpty ? double.parse(_niacinPercentage()) : 0,
      "pantothenicAcid": pantothenicAcidController.text.isNotEmpty ? double.parse(_pantothenicAcidPercentage()) : 0,
      "vitaminE": vitaminEController.text.isNotEmpty ? double.parse(_vitaminEPercentage()) : 0,
      "timesAdded": 0,
    });
  }

  // Saves manual food entry to the root database/foods collection
  Future<void> saveToFoodDatabase(BuildContext context) async {
    await dbFoodsCollection
      .doc(widget.foodIdValue)
      .set({
      "foodId": widget.foodIdValue,
      "foodName": foodNameController.text,
      "brandName": brandNameController.text,
      "servingSize": servingSizeController.text.isNotEmpty ? double.parse(servingSizeController.text) : 0,
      "calories": caloriesController.text.isNotEmpty ? double.parse(caloriesController.text.replaceAll(',', '.')) : 0,
      "totalFat": totalFatController.text.isNotEmpty ? double.parse(totalFatController.text.replaceAll(',', '.')) : 0,
      "saturatedFat": saturatedFatController.text.isNotEmpty ? double.parse(saturatedFatController.text.replaceAll(',', '.')) : 0,
      "transFat": transFatController.text.isNotEmpty ? double.parse(transFatController.text.replaceAll(',', '.')) : 0,
      "cholesterol": cholesterolController.text.isNotEmpty ? double.parse(cholesterolController.text.replaceAll(',', '.')) : 0,
      "sodium": sodiumController.text.isNotEmpty ? double.parse(sodiumController.text.replaceAll(',', '.')) : 0,
      "totalCarbohydrate": totalCarbohydrateController.text.isNotEmpty ? double.parse(totalCarbohydrateController.text.replaceAll(',', '.')) : 0,
      "dietaryFiber": dietaryFiberController.text.isNotEmpty ? double.parse(dietaryFiberController.text.replaceAll(',', '.')) : 0,
      "sugars": sugarsController.text.isNotEmpty ? double.parse(sugarsController.text.replaceAll(',', '.')) : 0,
      "addedSugars": addedSugarsController.text.isNotEmpty ? double.parse(addedSugarsController.text.replaceAll(',', '.')) : 0,
      "protein": proteinController.text.isNotEmpty ? double.parse(proteinController.text.replaceAll(',', '.')) : 0,
      "vitaminD": vitaminDController.text.isNotEmpty ? double.parse(vitaminDController.text.replaceAll(',', '.')) : 0,
      "calcium": calciumController.text.isNotEmpty ? double.parse(_calciumPercentage()) : 0,
      "iron": ironController.text.isNotEmpty ? double.parse(_ironPercentage()) : 0,
      "potassium": potassiumController.text.isNotEmpty ? double.parse(_potassiumPercentage()) : 0,
      "vitaminA": vitaminAController.text.isNotEmpty ? double.parse(_vitaminAPercentage()) : 0,
      "vitaminC": vitaminCController.text.isNotEmpty ? double.parse(_vitaminCPercentage()) : 0,
      "vitaminB6": vitaminB6Controller.text.isNotEmpty ? double.parse(_vitaminB6Percentage()) : 0,
      "folate": folateController.text.isNotEmpty ? double.parse(_folatePercentage()) : 0,
      "thiamin": thiaminController.text.isNotEmpty ? double.parse(_thiaminPercentage()) : 0,
      "magnesium": magnesiumController.text.isNotEmpty ? double.parse(_magnesiumPercentage()) : 0,
      "zinc": zincController.text.isNotEmpty ? double.parse(_zincPercentage()) : 0,
      "phosphorus": phosphorusController.text.isNotEmpty ? double.parse(_phosphorusPercentage()) : 0,
      "riboflavin": riboflavinController.text.isNotEmpty ? double.parse(_riboflavinPercentage()) : 0,
      "niacin": niacinController.text.isNotEmpty ? double.parse(_niacinPercentage()) : 0,
      "pantothenicAcid": pantothenicAcidController.text.isNotEmpty ? double.parse(_pantothenicAcidPercentage()) : 0,
      "vitaminE": vitaminEController.text.isNotEmpty ? double.parse(_vitaminEPercentage()) : 0,
    });
  }
}

