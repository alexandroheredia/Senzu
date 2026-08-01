import 'package:flutter/material.dart';
import 'package:senzu_app/shared/constants.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';

class SaveToShelf extends StatefulWidget {
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
    final dynamic proteinValue;
    final dynamic calciumValue;
    final dynamic addedSugarsValue;
    final dynamic ironValue;
    final dynamic potassiumValue;
    final dynamic vitaminAValue;
    final dynamic vitaminCValue;
    final DateTime? selectedDateSecondStep;
    final String? foodIdValue;
    final dynamic vitaminDValue;
    final dynamic vitaminB6Value;
    final dynamic folateValue;
    final dynamic thiaminValue;
    final dynamic magnesiumValue;
    final dynamic zincValue;
    final dynamic barcodeValue;
    final dynamic phosphorusValue;
    final dynamic riboflavinValue;
    final dynamic niacinValue;
    final dynamic pantothenicAcidValue;
    final dynamic vitaminEValue;
    

  SaveToShelf({
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
    this.proteinValue, 
    this.calciumValue, 
    this.ironValue, 
    this.potassiumValue, 
    this.vitaminAValue, 
    this.vitaminCValue,
    this.selectedDateSecondStep, 
    this.foodIdValue, 
    this.vitaminDValue, 
    this.vitaminB6Value, 
    this.folateValue, 
    this.thiaminValue, 
    this.magnesiumValue, 
    this.zincValue, 
    this.addedSugarsValue, 
    this.barcodeValue, 
    this.phosphorusValue, 
    this.riboflavinValue, 
    this.niacinValue, 
    this.pantothenicAcidValue, 
    this.vitaminEValue,
    }) : super(key: key);


  @override
  _SaveToShelfState createState() => _SaveToShelfState();
}

class _SaveToShelfState extends State<SaveToShelf> {


  @override
  void initState() {
    super.initState();
  }


  final portionSizeController = TextEditingController();

  bool loading = false;

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
      var ironPercentage = widget.ironValue / ironDailyValue;
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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        centerTitle: true,
        title: Text('Nutrition Facts',
          style: titleTextStyle,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: _addManuallyButton(),
      ),
      body: saveToShelfBody(),
      backgroundColor: primaryBackgroundColor,
    );
  }


  Widget saveToShelfBody(){
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
                      Text('(${widget.servingSizeValue.toStringAsFixed(0)}g)',                                
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Calories',
                          style: textColor.copyWith(
                            fontWeight: FontWeight.w900,
                            fontSize: 34,
                          )
                        ),
                      ],
                    ),
                    Text('${widget.caloriesValue.toStringAsFixed(0)}',
                      style: textColor.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 58,
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
                      Text('Includes ' + '0' + 'g Added Sugars',
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

  Future<void> saveFoodToShelf() async {

    await dbUsersCollection
      .doc(myUID(context))
      .collection('foodShelf')
      .doc(widget.foodIdValue)
      .set({
        "foodId": widget.foodIdValue,
        "foodName": widget.foodNameValue,
        "brandName": widget.brandNameValue ?? '',
        "servingSize": widget.servingSizeValue,
        "calories": widget.caloriesValue ?? 0,
        "totalFat": widget.totalFatValue ?? 0,
        "saturatedFat": widget.saturatedFatValue ?? 0,
        "transFat": widget.transFatValue ?? 0,
        "cholesterol": widget.cholesterolValue ?? 0,
        "sodium": widget.sodiumValue ?? 0,
        "totalCarbohydrate": widget.totalCarbohydrateValue ?? 0,
        "dietaryFiber": widget.dietaryFiberValue ?? 0,
        "sugars": widget.sugarsValue ?? 0,
        "addedSugars": widget.addedSugarsValue ?? 0,
        "protein": widget.proteinValue ?? 0,
        "calcium": widget.calciumValue ?? 0,
        "iron": widget.ironValue ?? 0,
        "potassium": widget.potassiumValue ?? 0,
        "vitaminA": widget.vitaminAValue ?? 0,
        "vitaminC": widget.vitaminCValue ?? 0,
        "vitaminD": widget.vitaminDValue ?? 0,
        "vitaminB6": widget.vitaminB6Value ?? 0,
        "folate": widget.folateValue ?? 0,
        "thiamin": widget.thiaminValue ?? 0,
        "magnesium": widget.magnesiumValue ?? 0,
        "zinc": widget.zincValue ?? 0,
        "phosphorus": widget.phosphorusValue ?? 0,
        "riboflavin": widget.riboflavinValue ?? 0,
        "niacin": widget.niacinValue ?? 0,
        "pantothenicAcid": widget.pantothenicAcidValue ?? 0,
        "vitaminE": widget.vitaminEValue ?? 0,
        "timesAdded": 0,
      });
    }




    Widget _addManuallyButton() {
    return Builder(builder: (BuildContext context){
      return Hero(
        tag: "add_food_button",
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            color: primaryButtonColor
          ),
          child: MaterialButton(
            onPressed: () async {
              setState(() => loading = true);
              try {
                await saveFoodToShelf();
                if (!mounted) return;
                Navigator.of(context).pop();
              } catch (e) {
                if (mounted) {
                  setState(() => loading = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Could not save to your shelf. '
                          'Please check your connection and try again.')));
                }
              }
            },
            child: Container(
              child: Center(
                child: Builder(
                  builder: (context) {
                    return loading ? loadingWidget : Text(
                      'ADD TO SHELF',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
    }
  );
}
}