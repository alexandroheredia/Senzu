import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/meal.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/add_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_details.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/meal_details.dart';
import 'package:senzu_app/services/meal_repository.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/shared/theme.dart';
import 'package:senzu_app/shared/auth_scope.dart';

class FoodShelf extends StatefulWidget {
  final DateTime? selectedDateValue2;
  final String? breakfastMealValue;
  final String? lunchMealValue;
  final String? snacksMealValue;
  final String? dinnerMealValue;
  final String? mealIdValue;

  const FoodShelf({
    super.key, 
    this.selectedDateValue2, 
    this.breakfastMealValue, 
    this.lunchMealValue, 
    this.snacksMealValue,
    this.dinnerMealValue, 
    this.mealIdValue, 
    });

  @override
  _FoodShelfState createState() => _FoodShelfState();
}

class _FoodShelfState extends State<FoodShelf> {

  final mealNameController = TextEditingController();
  late final ShelfRepository _shelf;
  late final MealRepository _meals;

  @override
  void initState() {
    super.initState();
    _shelf = context.read<ShelfRepository>();
    _meals = context.read<MealRepository>();
  }

  // ElasticSearch search page

  //   Future<void> _showSearch() async {
  //   await showSearch(
  //     context: context,
  //     delegate: ElasticSearchDelegate(),
  //     query: "",
  //   );
  // }

  final _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
    )
  );

  String generateFoodId() {
    String foodId = getRandomString(20);
    return foodId;
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
        child: Center(
          child: Builder(
            builder: (context) {
              return loading ? loadingWidget : Icon(Icons.add, size: 35,);
            },
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
      child: StreamBuilder<List<ShelfFood>>(
        stream: _shelf.shelfStream(myUID(context)),
        builder: buildFoodList,
      ),
    );
  }


Widget buildFoodList(
  BuildContext context,
  AsyncSnapshot<List<ShelfFood>> snapshot,
) {
  if (snapshot.hasData) {
    final foods = snapshot.data!;
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: foods.length,
        itemBuilder: (BuildContext context, int index) {

    final food = foods[index];
    final foodName = food.foodName;
    final brandName = food.brandName;

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
                Text(foodName,
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
                  _shelf.deleteFood(myUID(context), food.foodId);
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
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Could not remove the food item. '
                    'Please try again.')));
          }
        }
      },
      onTap: () async {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => FoodDetails(
            food: food,
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
              Radius.circular(8.0),
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
      child: StreamBuilder<List<Meal>>(
        stream: _meals.mealsStream(myUID(context)),
        builder: buildMealList,
      ),
  );
}


Widget buildMealList(
  BuildContext context,
  AsyncSnapshot<List<Meal>> snapshot,
) {
  if (snapshot.hasData) {
    final meals = snapshot.data!;
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: meals.length,
        itemBuilder: (BuildContext context, int index) {

    final meal = meals[index];
    var mealName = meal.mealName;
    var mealId = meal.mealId;



    return GestureDetector(
      key: Key(meal.id),
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
              Radius.circular(8.0),
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
    _meals.createMeal(myUID(context), widget.mealIdValue!, mealNameController.text);
  }

}