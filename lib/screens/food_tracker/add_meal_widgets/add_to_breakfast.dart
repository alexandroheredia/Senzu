import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_shelf.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/meals.dart';
import 'package:senzu_app/shared/constants.dart';

class AddToBreakfast extends StatefulWidget {
  final DateTime selectedDateValue;

  AddToBreakfast({
    Key? key, required this.selectedDateValue, 
    }) : super(key: key);

  @override
  _AddToBreakfastState createState() => _AddToBreakfastState();
}

class _AddToBreakfastState extends State<AddToBreakfast> {

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))
    )
  );

  String generateMealId() {
    String foodId = getRandomString(20);
    return foodId;
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: Text('Log Your Breakfast',
        style: titleTextStyle,),
        centerTitle: true,
      ),
      body: _addToBreakFastBody(),
    );
  }

  Widget _addToBreakFastBody(){
    return Column(
      children: <Widget>[
        breakfastHeader(),
        addFoodButton(),
        _breakfastList(),
        _doneButton(),
        SizedBox(height: 20,),
      ],
    );
  }

  Widget breakfastHeader(){
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                height: 180,
                fit: BoxFit.fitHeight,
                image: const AssetImage('assets/meal_icons/breakfast_medium.png')),
              ],
            ),
          ),
      ],
    );
  }

  Widget addFoodButton(){
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
                Future.delayed(Duration(milliseconds: 200), () {
                  setState(() => loading = true);
                  String breakfastMeal = 'breakfast';
                  MaterialPageRoute(
                    builder: (context) => MealsList(
                      selectedDateValue2: widget.selectedDateValue,
                      breakfastMealValue: breakfastMeal,
                    )
                  );
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FoodShelf(
                      selectedDateValue2: widget.selectedDateValue,
                      breakfastMealValue: breakfastMeal,
                      mealIdValue: generateMealId(),
                      )
                  ));
                  setState(() => loading = false);
                });
              },
              child: Column(
                children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text('Add Food ',
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

  Widget _doneButton() {
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
              Future.delayed(Duration(milliseconds: 200), () {
                Navigator.of(context).pop();
              });
            },
            child: Text('Done',
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



  Widget _breakfastList(){
    return Expanded(
      child: StreamBuilder(
        stream: dbUsersCollection
        .doc(myUID(context))
        .collection('foodEntries')
        .where("mealType", isEqualTo: 'breakfast')
        .where("dateAdded", isEqualTo: widget.selectedDateValue)
        .snapshots(),
        builder: buildUserList,
      ),
    );
  }


Widget buildUserList(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  if (snapshot.hasData) {
    return ListView.builder(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.vertical,
        // shrinkWrap: true,
        itemCount: snapshot.data!.docs.length,
        itemBuilder: (BuildContext context, int index) {

    DocumentSnapshot food = snapshot.data!.docs[index];
    
    var foodName = food.get('foodName');
    var calories = food.get('calories');
    var portionSize = food.get('portionSize');

    return GestureDetector(
      key: Key(food.id),
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
                  child: Text('Removing from your breakfast:',
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
                    .collection('foodEntries')
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






}
