import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senzu_app/screens/food_tracker/ui/add_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_details.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/meal_details.dart';
import 'package:senzu_app/shared/constants.dart';

class FoodShelf extends StatefulWidget {
  final DateTime? selectedDateValue2;
  final String? breakfastMealValue;
  final String? lunchMealValue;
  final String? snacksMealValue;
  final String? dinnerMealValue;
  final String? mealIdValue;

  FoodShelf({
    Key? key, 
    this.selectedDateValue2, 
    this.breakfastMealValue, 
    this.lunchMealValue, 
    this.snacksMealValue,
    this.dinnerMealValue, 
    this.mealIdValue, 
    }) : super(key: key);

  @override
  _FoodShelfState createState() => _FoodShelfState();
}

class _FoodShelfState extends State<FoodShelf> {

    final mealNameController = TextEditingController();

  // ElasticSearch search page

  //   Future<void> _showSearch() async {
  //   await showSearch(
  //     context: context,
  //     delegate: ElasticSearchDelegate(),
  //     query: "",
  //   );
  // }

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
    )
  );

  String generateFoodId() {
    String foodId = getRandomString(20);
    return foodId;
  }


  @override
  void initState() {
    super.initState();
  }

  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Food Shelf',
          style: titleTextStyle,),
          centerTitle: true,
          backgroundColor: primaryBackgroundColor,
          bottom: TabBar(
            tabs: [
              Tab(text: 'Food',),
              Tab(text: 'Meals',),
            ]),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Color(0xFF1e1f38),
          notchMargin: 8.0,
          shape: CircularNotchedRectangle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(height: 40,)
            // _searchButton(FontAwesomeIcons.search, () {}),
            // _barcodeButton(FontAwesomeIcons.barcode, () {}),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryButtonColor,
        onPressed: () async {
          setState(() => loading = true);

          await Navigator.push(context, MaterialPageRoute(
            builder: (context) => AddFood(
              foodIdValue: generateFoodId(),
            )
          ));
          if (mounted) {
            setState(() => loading = false);
          }
        },
        child: Container(
          child: Center(
            child: Builder(
              builder: (context) {
                return loading ? loadingWidget : Icon(Icons.add, size: 35,);
              },
            ),
          ),
        ),
      ),
      body: TabBarView(
            children: [
              _foodShelfBody(),
              mealsListBody(),
            ],
      ),
        backgroundColor: primaryBackgroundColor,
      ),
    );
  }


  Widget _foodShelfBody(){
    return Column(
      children: <Widget>[
      _foodList(),
      // _addManuallyButton(),
      ]
    );
  }

  Widget _foodList(){
    return Expanded(
      child: StreamBuilder(
        stream: dbUsersCollection
        .doc(myUID(context))
        .collection('foodShelf')
        .orderBy('foodName')
        .snapshots(),
        builder: buildFoodList,
      ),
    );
  }


Widget buildFoodList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (BuildContext context, int index) {

    DocumentSnapshot food = snapshot.data!.docs[index];
    var foodName = food.get('foodName');
    var brandName = food.get('brandName');
    var servingSize = food.get('servingSize');
    // var calories = food.get('calories');
    var calories = food.data().toString().contains('calories') ? food.get('calories') : 0;
    // var totalFat = food.get('totalFat');
    var totalFat = food.data().toString().contains('totalFat') ? food.get('totalFat') : 0;
    // var saturatedFat = food.get('saturatedFat');
    var saturatedFat = food.data().toString().contains('saturatedFat') ? food.get('saturatedFat') : 0;
    // var transFat = food.get('transFat');
    var transFat = food.data().toString().contains('transFat') ? food.get('transFat') : 0;
    // var cholesterol = food.get('cholesterol');
    var cholesterol = food.data().toString().contains('cholesterol') ? food.get('cholesterol') : 0;
    // var sodium = food.get('sodium');
    var sodium = food.data().toString().contains('sodium') ? food.get('sodium') : 0;
    // var totalCarbohydrate = food.get('totalCarbohydrate');
    var totalCarbohydrate = food.data().toString().contains('totalCarbohydrate') ? food.get('totalCarbohydrate') : 0;
    // var dietaryFiber = food.get('dietaryFiber');
    var dietaryFiber = food.data().toString().contains('dietaryFiber') ? food.get('dietaryFiber') : 0;
    // var sugars = food.get('sugars');
    var sugars = food.data().toString().contains('sugars') ? food.get('sugars') : 0;
    // var protein = food.get('protein');
    var protein = food.data().toString().contains('protein') ? food.get('protein') : 0;
    // var calcium = food.get('calcium');
    var calcium = food.data().toString().contains('calcium') ? food.get('calcium') : 0;
    // var iron = food.get('iron');
    var iron = food.data().toString().contains('iron') ? food.get('iron') : 0;
    // var potassium = food.get('potassium');
    var potassium = food.data().toString().contains('potassium') ? food.get('potassium') : 0;
    // var vitaminA = food.get('vitaminA');
    var vitaminA = food.data().toString().contains('vitaminA') ? food.get('vitaminA') : 0;
    // var vitaminC = food.get('vitaminC');
    var vitaminC = food.data().toString().contains('vitaminC') ? food.get('vitaminC') : 0;
    // var vitaminD = food.get('vitaminD');
    var vitaminD = food.data().toString().contains('vitaminD') ? food.get('vitaminD') : 0;
    // var magnesium = food.get('magnesium');
    var magnesium = food.data().toString().contains('magnesium') ? food.get('magnesium') : 0;
    // var zinc = food.get('zinc');
    var zinc = food.data().toString().contains('zinc') ? food.get('zinc') : 0;
    // var addedSugars = food.get('addedSugars');
    var addedSugars = food.data().toString().contains('addedSugars') ? food.get('addedSugars') : 0;
    // var timesAdded = food.get('timesAdded');
    var timesAdded = food.data().toString().contains('timesAdded') ? food.get('timesAdded') : 0;
    var getFoodId = food.get('foodId');


    return GestureDetector(
      key: Key(food.id),
      onLongPress: () async {
        try {
          showDialog<String>(
          context: context, 
          builder: (BuildContext context) => AlertDialog(
            title: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(0,0,0,10),
                  child: Text('Removing from your shelf:',
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
                child: Text('Remove'),
                onPressed: () {
                  // Deletes entry from Firestore database
                  dbUsersCollection
                    .doc(myUID(context))
                    .collection('foodShelf')
                    .doc(getFoodId)
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
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => FoodDetails(
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
            magnesiumValue: magnesium,
            zincValue: zinc,
            selectedDateSecondStep: widget.selectedDateValue2,
            breakfastMealAdd: widget.breakfastMealValue,
            lunchMealAdd: widget.lunchMealValue,
            snacksMealAdd: widget.snacksMealValue,
            dinnerMealAdd: widget.dinnerMealValue,
            timesAddedValue: timesAdded,
            getFoodIdValue: getFoodId,
          )
        ));
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
                title: Text(foodName,
                  style: textColor.copyWith(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Text(brandName,
                style: textColor.copyWith(fontSize: 14),
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
        child: Text("No users found."),
      );
    } else {
      // Still loading
      return loadingWidget;
    }
  }

  mealsListBody(){
    return Column(
      children: <Widget>[
      _createMealButton(),
      _mealsList(),
      ]
    );
  }

      // Button to create a new meal
    Widget _createMealButton() {
    return Builder(builder: (BuildContext context){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 45.0,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: primaryButtonColor
          ),
          child: MaterialButton(
            onPressed: () async {
              _openCreateMealForm();
            },
            child: Text('CREATE NEW MEAL',
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

  _openCreateMealForm(){
    return showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: primaryBackgroundColor,
          height: MediaQuery.of(context).size.height * 0.6,
          child: Center(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: mealNameController,
                    style: textColor.copyWith(fontSize: 18),
                    decoration: textInputDecoration.copyWith(hintText: 'Meal Name'),
                    keyboardType: TextInputType.name,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('CANCEL'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    ElevatedButton(
                      child: const Text('SAVE MEAL'),
                      onPressed: () {
                        saveMeal();
                        Navigator.pop(context);
                        }
                    ),
                  ]
                )
              ],
            ),
          ),
        );
      },
    );
  }


  // Displays the list of meals recorded on Firestore
  Widget _mealsList(){
  return Expanded(
      child: StreamBuilder(
        stream: dbUsersCollection
        .doc(myUID(context))
        .collection('meals')
        .orderBy('mealName')
        .snapshots(),
        builder: buildMealList,
      ),
  );
}


Widget buildMealList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (BuildContext context, int index) {

    DocumentSnapshot user = snapshot.data!.docs[index];
    var mealName = user.get('mealName');
    var mealId = user.get('mealId');



    return GestureDetector(
      key: Key(user.id),
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => MealDetails(
            mealNameValue: mealName,
            mealIdValue: mealId,
            selectedDateSecondStep: widget.selectedDateValue2,
            breakfastMealAdd: widget.breakfastMealValue,
            lunchMealAdd: widget.lunchMealValue,
            snacksMealAdd: widget.snacksMealValue,
            dinnerMealAdd: widget.dinnerMealValue,

          )
        ));
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('🍽',
                              style: textColor.copyWith(fontSize: 25),
                            ),
                          ),
                          Expanded(
                            child: Text(mealName,
                                style: textColor.copyWith(
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 18,
                                  overflow: TextOverflow.ellipsis
                                  
                                ),
                              ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Icon(Icons.add_circle_outline_rounded,
                    size: 35,
                    color: Color(0xFFc5c5c5),
                  ),

                ],
              ),
              // ListTile(
              //   leading: Text('🍽',
              //   style: textColor.copyWith(fontSize: 25),),
              //   title: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: <Widget>[
              //       Text(mealName,
              //         style: textColor.copyWith(
              //           fontWeight: FontWeight.bold, 
              //           fontSize: 18,
              //         ),
              //       ),
              //       Icon(Icons.add_circle_outline_rounded,
              //         size: 35,
              //         color: Color(0xFFc5c5c5),
              //       ),
              //     ]
              //   ),
              // )
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
        child: Text("No users found."),
      );
    } else {
      // Still loading
      return loadingWidget;
    }
  }


  void saveMeal() {
    dbUsersCollection
      .doc(myUID(context))
      .collection('meals')
      .doc(widget.mealIdValue)
      .set({
      "mealName": mealNameController.text,
      "mealId": widget.mealIdValue,

    });
  }

}