import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/meal_details.dart';
import 'package:senzu_app/shared/constants.dart';


class MealsList extends StatefulWidget {
  final DateTime? selectedDateValue2;
  final String? breakfastMealValue;
  final String? lunchMealValue;
  final String? snacksMealValue;
  final String? dinnerMealValue;

  MealsList({
    Key? key, 
    this.selectedDateValue2, 
    this.breakfastMealValue, 
    this.lunchMealValue, 
    this.snacksMealValue,
    this.dinnerMealValue, 
    }) : super(key: key);

  @override
  _MealsListState createState() => _MealsListState();
}

class _MealsListState extends State<MealsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      body: mealsListBody(),
    );
  }


  // This is body of the Meals screen
  mealsListBody(){
    return Column(
      children: <Widget>[
      _createMealButton(),
      _mealsList(),
      ]
    );
  }


  // Displays the list of meals recorded on Firestore
  Widget _mealsList(){
    return Expanded(
      child: StreamBuilder(
        stream: dbUsersCollection
        .doc(myUID(context))
        .collection('meals')
        .orderBy('foodName')
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
        Navigator.pushReplacement(context, MaterialPageRoute(
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
              ListTile(
                leading: Text('🍽',
                style: textColor.copyWith(fontSize: 25),),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(mealName,
                      style: textColor.copyWith(
                        fontWeight: FontWeight.bold, fontSize: 18
                      ),
                    ),
                    Icon(Icons.add_circle_outline_rounded,
                      size: 35,
                      color: Color(0xFFc5c5c5),
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
        child: Text("No users found."),
      );
    } else {
      // Still loading
      return loadingWidget;
    }
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

}