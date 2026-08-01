import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_shelf.dart';
import 'package:senzu_app/shared/constants.dart';

/// Per-meal presentation details.
extension MealTypePresentation on MealType {
  /// 'Log Your Breakfast' / 'Log Your Lunch' / ...
  String get title => 'Log Your ${name[0].toUpperCase()}${name.substring(1)}';

  /// Asset key of the meal icon.
  String get assetPath => 'assets/meal_icons/${name}_medium.png';
}

class AddToMeal extends StatefulWidget {
  final DateTime selectedDateValue;
  final MealType mealType;

  AddToMeal({
    Key? key,
    required this.selectedDateValue,
    required this.mealType,
  }) : super(key: key);

  @override
  _AddToMealState createState() => _AddToMealState();
}

class _AddToMealState extends State<AddToMeal> {

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
        title: Text(widget.mealType.title,
        style: titleTextStyle,),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body(){
    return Column(
      children: <Widget>[
        _header(),
        addFoodButton(),
        _mealList(),
        _doneButton(),
        SizedBox(height: 20,),
      ],
    );
  }

  Widget _header(){
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
                image: AssetImage(widget.mealType.assetPath)),
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
                  final meal = mealTypeToString(widget.mealType)!;
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => FoodShelf(
                      selectedDateValue2: widget.selectedDateValue,
                      mealIdValue: generateMealId(),
                      breakfastMealValue: meal == 'breakfast' ? meal : null,
                      lunchMealValue: meal == 'lunch' ? meal : null,
                      snacksMealValue: meal == 'snacks' ? meal : null,
                      dinnerMealValue: meal == 'dinner' ? meal : null,
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



  Widget _mealList(){
    return Expanded(
      child: StreamBuilder(
        stream: dbUsersCollection
        .doc(myUID(context))
        .collection('foodEntries')
        .where("mealType", isEqualTo: mealTypeToString(widget.mealType))
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
                  child: Text('Removing from your ${widget.mealType.name}:',
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
