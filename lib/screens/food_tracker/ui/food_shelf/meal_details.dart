import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_details_for_meals.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/shared/constants.dart';



class MealDetails extends StatefulWidget {
  final String? mealNameValue;
  final String? mealIdValue;
  final String? breakfastMealAdd;
  final String? lunchMealAdd;
  final String? snacksMealAdd;
  final String? dinnerMealAdd;
  final DateTime? selectedDateSecondStep;

  
  MealDetails({
    Key? key, 
    this.mealNameValue,
    this.mealIdValue, 
    this.breakfastMealAdd, 
    this.lunchMealAdd, 
    this.snacksMealAdd, 
    this.dinnerMealAdd, 
    this.selectedDateSecondStep,
    }) : super(key: key);

  @override
  _MealDetailsState createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {

  bool isFoodAdded = false;
  
  bool loading = false;

  selectedMealValue(){
    return widget.breakfastMealAdd;
  
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: Text('Meal Details',
        style: titleTextStyle,),
        centerTitle: true,
      ),
      body: _mealDetailsBody(),
    );
  }

  Widget _mealDetailsBody(){
    return Column(
      children: <Widget>[
        mealDetailsHeader(),
        addFoodItemToMealButton(),
        _mealFoodItemsList(),
        _addMealFoodItemsButton(),
        SizedBox(height: 20,),
      ],
    );
  }

  Widget mealDetailsHeader(){
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('🍽 ',
                style: textColor.copyWith(fontSize: 25),
              ),
              Text('${widget.mealNameValue}',
                style: textColor.copyWith(fontSize: 25),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
          width: 10,
        ),
      ],
    );
  }

  // Pops the foods in the user's food shelf so they can add it to the specified meal
  Widget addFoodItemToMealButton(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Color(0xFF1e1f38),
            child: InkWell(
              splashColor: Color(0xFF2b2c4a),
              borderRadius: BorderRadius.circular(15.0),
              onTap: () {
                _openFoodShelf();
            
              },
              child: Column(
                children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('ADD TO MEAL ',
                            style: textColor.copyWith(fontWeight: FontWeight.bold, fontSize: 22)
                          ),
                          FaIcon(FontAwesomeIcons.plus,
                          color: Colors.white,
                          size: 22,)
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ),
      ],
    );
  }

  // Adds food items in meal to the food log
  Widget _addMealFoodItemsButton() {
    return Builder(builder: (BuildContext context){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 50.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.0),
            color: primaryButtonColor
          ),
          child: MaterialButton(
            onPressed: () async {
              await updateFieldsOnFoodItems();
              documentsLoopFromFirestore();
              Navigator.of(context).pop();
            },
            child: Text('ADD THIS MEAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      );
    }
  );
}


  // Displays the list of food items in the meal from firestore
  Widget _mealFoodItemsList(){
    return Expanded(
      child: StreamBuilder(
        stream: dbUsersCollection
        .doc(myUID(context))
        .collection('meals')
        .doc(widget.mealIdValue)
        .collection('foodItems')
        .orderBy('foodName')
        .snapshots(),
        builder: buildMealFoodItemsList,
      ),
    );
  }


Widget buildMealFoodItemsList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  
  if (snapshot.hasData) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (BuildContext context, int index) {

    DocumentSnapshot user = snapshot.data!.docs[index];

    var foodName = user.get('foodName');
    var calories = user.get('calories');
    var portionSize = user.get('portionSize');

    return GestureDetector(
      key: Key(user.id),
      onLongPress: () async {

        var doc = snapshot.data!.docs[index];

        try {
          showDialog<String>(
          context: context, 
          builder: (BuildContext context) => AlertDialog(
            title: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,10),
                  child: Text('Removing from your dinner:',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.start,
                  ),
                ),
                Text('$foodName',
                style: TextStyle(fontSize: 18,
                fontStyle: FontStyle.italic),
                textAlign: TextAlign.start,),
                ]
                ),
            actions: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent[400], // background
                  foregroundColor: Colors.white, // foreground
                ),
                child: Text('DELETE'),
                onPressed: () {
                  // Deletes entry from Firestore database
                  dbUsersCollection
                  .doc(myUID(context))
                  .collection('meals')
                  .doc(widget.mealIdValue)
                  .collection('foodItems')
                  .doc(doc.id)
                  .delete();
                  Navigator.pop(context, 'ok');
                },
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0.0,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: Text('Nope',
                style: TextStyle(
                  fontSize: 15.0,
                  ),
                ),
              ),
            ],
          )
        );
        } catch (e) {
          print(e);
        }
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12,6,12,0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white70
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(8.0),
            )
          ),
          child: Column(
            children: [
              ListTile(
                // tileColor: Color(0xFF1e1f38),
                title: Text(foodName,
                  style: textColor.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Row(
                  children: <Widget>[
                    Text('🔥 $calories kcal      🍽 ${portionSize}g',
                      style: textColor.copyWith(fontSize: 14),
                      ),
                  ]
                ),
              )
            ],
          ),
        ),
      ),
    );
  } 
        
      );
    } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
      // Handle no data
      return Center(
        child: Text("No food items in list"),
      );
    } else {
      // Still loading
      return loadingWidget;
    }
  }

  // Opens a screen from the bottom up with the list of foods from the user's food shelf
  _openFoodShelf(){
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: primaryBackgroundColor,
          height: 600,
          child: Center(
            child: Column(
              children: <Widget>[
                _foodListFromFoodShelf(),
                ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // Shows list of foods in the user's food shelf
  Widget _foodListFromFoodShelf(){
  return Expanded(
      child: StreamBuilder(
        stream: dbUsersCollection
        .doc(myUID(context))
        .collection('foodShelf')
        .orderBy('foodName')
        .snapshots(),
        builder: buildFoodShelfList,
      ),
  );
}


Widget buildFoodShelfList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (BuildContext context, int index) {

    DocumentSnapshot food = snapshot.data!.docs[index];
    var foodId = food.get('foodId');
    var foodName = food.get('foodName');
    var brandName = food.get('brandName');
    var servingSize = food.get('servingSize');
    var calories = food.get('calories');
    var totalFat = food.get('totalFat');
    var saturatedFat = food.get('saturatedFat');
    var transFat = food.get('transFat');
    var cholesterol = food.get('cholesterol');
    var sodium = food.get('sodium');
    var totalCarbohydrate = food.get('totalCarbohydrate');
    var dietaryFiber = food.get('dietaryFiber');
    var sugars = food.get('sugars');
    var addedSugars = food.get('addedSugars');
    var protein = food.get('protein');
    var vitaminD = food.get('vitaminD');
    var calcium = food.get('calcium');
    var iron = food.get('iron');
    var potassium = food.get('potassium');
    var vitaminA = food.get('vitaminA');
    var vitaminC = food.get('vitaminC');
    var vitaminB6 = food.get('vitaminB6');
    var folate = food.get('folate');
    var thiamin = food.get('thiamin');
    var magnesium = food.get('magnesium');
    var zinc = food.get('zinc');
    var phosphorus = food.get('phosphorus');
    var riboflavin = food.get('riboflavin');
    var niacin = food.get('niacin');
    var pantothenicAcid = food.get('pantothenicAcid');
    var vitaminE = food.get('vitaminE');
    var timesAdded = food.get('timesAdded');
    


    return Padding(
      padding: const EdgeInsets.fromLTRB(12,6,12,0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white70
          ),
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          )
        ),
        child: Column(
          children: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: 260,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(foodName,
                          overflow: TextOverflow.ellipsis,
                          style: textColor.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        Text(brandName,
                          style: textColor.copyWith(fontSize: 14),
                        ),
                      ]
                    ),
                  ),
                  SizedBox(
                    width: 40,
                    child: RawMaterialButton(
                      onPressed: () async {
                        await Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => FoodDetailsForMeals(
                            foodNameValue: foodName,
                            brandNameValue: brandName,
                            servingSizeValue: servingSize,
                            caloriesValue: calories,
                            totalFatValue: totalFat,
                            saturatedFatValue: saturatedFat,
                            transFatValue: transFat,
                            cholesterolValue: cholesterol,
                            sodiumValue: sodium,
                            totalCarbohydrateValue: totalCarbohydrate,
                            dietaryFiberValue: dietaryFiber,
                            sugarsValue: sugars,
                            proteinValue: protein,
                            calciumValue: calcium,
                            ironValue: iron,
                            addedSugarsValue: addedSugars,
                            potassiumValue: potassium,
                            vitaminAValue: vitaminA,
                            vitaminCValue: vitaminC,
                            vitaminDValue: vitaminD,
                            vitaminB6Value: vitaminB6,
                            folateValue: folate,
                            thiaminValue: thiamin,
                            magnesiumValue: magnesium,
                            zincValue: zinc,
                            phosphorusValue: phosphorus,
                            riboflavinValue: riboflavin,
                            niacinValue: niacin,
                            pantothenicAcidValue: pantothenicAcid,
                            vitaminEValue: vitaminE,
                            timesAddedValue: timesAdded,
                            getFoodIdValue: foodId,
                            mealIdValue: widget.mealIdValue,
                          )
                        ));
                      },




                      child: Icon(
                        Icons.add_circle_outline_rounded,
                        color: Colors.white,
                        size: 30.0,
                      ),
                      padding: EdgeInsets.all(5.0),
                      shape: CircleBorder(),
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  } 
        
      );
    } else if (snapshot.connectionState == ConnectionState.done && !snapshot.hasData) {
      // Handle no data
      return Center(
        child: Text("No users found."),
      );
    } else {
      // Still loading
      return loadingWidget;
    }
  }


  void documentsLoopFromFirestore() {
    dbUsersCollection
    .doc(myUID(context))
    .collection('meals')
    .doc(widget.mealIdValue)
    .collection('foodItems')
    .get()
    .then(
      (value) {
        value.docs.forEach(
          (result) {
            dbUsersCollection
            .doc(myUID(context))
            .collection('foodEntries')
            .add(result.data());
          },
        );
      },
    );
  }

  // This updates the fields in all documents from the foodItems collection.
  // It's necessary so that the food items can be read by the .where() filter in lib/food_tracker/food_tracker.dart
  updateFieldsOnFoodItems() async {
    CollectionReference ref = 
      dbUsersCollection
      .doc(myUID(context))
      .collection('meals')
      .doc(widget.mealIdValue)
      .collection('foodItems');

    QuerySnapshot eventsQuery = await ref.where('mealId', isEqualTo: widget.mealIdValue).get();

    eventsQuery.docs.forEach((value) {
      value.reference.update({
        'mealType': selectedMealValue(),
        'weekNo': getWeekNumber(widget.selectedDateSecondStep!),
        'month': cleanMonthFormat(widget.selectedDateSecondStep.toString()),
        'year': cleanYearFormat(widget.selectedDateSecondStep.toString()),
        'dateAdded': widget.selectedDateSecondStep,
      });
    });
  }
}
