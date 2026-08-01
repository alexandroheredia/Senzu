import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/meal.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_details.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/services/meal_repository.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/theme.dart';

class MealDetails extends StatefulWidget {
  final String? mealNameValue;
  final String? mealIdValue;
  final String? breakfastMealAdd;
  final String? lunchMealAdd;
  final String? snacksMealAdd;
  final String? dinnerMealAdd;
  final DateTime? selectedDateSecondStep;

  const MealDetails({
    super.key,
    this.mealNameValue,
    this.mealIdValue,
    this.breakfastMealAdd,
    this.lunchMealAdd,
    this.snacksMealAdd,
    this.dinnerMealAdd,
    this.selectedDateSecondStep,
  });

  @override
  State<MealDetails> createState() => _MealDetailsState();
}

class _MealDetailsState extends State<MealDetails> {
  bool isFoodAdded = false;

  bool loading = false;

  late final MealRepository _meals;
  late final ShelfRepository _shelf;

  @override
  void initState() {
    super.initState();
    _meals = context.read<MealRepository>();
    _shelf = context.read<ShelfRepository>();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: const Text(
          'Meal Details',
          style: titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: _mealDetailsBody(),
    );
  }

  Widget _mealDetailsBody() {
    return Column(
      children: <Widget>[
        mealDetailsHeader(),
        addFoodItemToMealButton(),
        _mealFoodItemsList(),
        _addMealFoodItemsButton(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget mealDetailsHeader() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '🍽 ',
                style: textColor.copyWith(fontSize: 25),
              ),
              Text(
                '${widget.mealNameValue}',
                style: textColor.copyWith(fontSize: 25),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 20,
          width: 10,
        ),
      ],
    );
  }

  // Pops the foods in the user's food shelf so they can add it to the specified meal
  Widget addFoodItemToMealButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: const Color(0xFF1e1f38),
            child: InkWell(
              splashColor: const Color(0xFF2b2c4a),
              borderRadius: BorderRadius.circular(15.0),
              onTap: _openFoodShelf,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'ADD TO MEAL ',
                          style: textColor.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const FaIcon(
                          FontAwesomeIcons.plus,
                          color: Colors.white,
                          size: 22,
                        ),
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
                await updateFieldsOnFoodItems();
                await documentsLoopFromFirestore();
                if (!mounted) return;
                navigator.pop();
              },
              child: const Text(
                'ADD THIS MEAL',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Displays the list of food items in the meal from firestore
  Widget _mealFoodItemsList() {
    return Expanded(
      child: StreamBuilder<List<MealFoodItem>>(
        stream: _meals.foodItemsStream(myUID(context), widget.mealIdValue!),
        builder: buildMealFoodItemsList,
      ),
    );
  }

  Widget buildMealFoodItemsList(
    BuildContext context,
    AsyncSnapshot<List<MealFoodItem>> snapshot,
  ) {
    if (snapshot.hasData) {
      final items = snapshot.data!;
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        // shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];

          final foodName = item.foodName;
          final calories = item.calories;
          final portionSize = item.portionSize;

          return GestureDetector(
            key: Key(item.id),
            onLongPress: () async {
              try {
                await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Column(
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            'Removing from your dinner:',
                            style: TextStyle(fontSize: 16),
                            textAlign: TextAlign.start,
                          ),
                        ),
                        Text(
                          foodName,
                          style: const TextStyle(
                            fontSize: 18,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent[400], // background
                          foregroundColor: Colors.white, // foreground
                        ),
                        child: const Text('DELETE'),
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await _meals.deleteFoodItem(
                            myUID(context),
                            widget.mealIdValue!,
                            item.id,
                          );
                          navigator.pop('ok');
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0.0,
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text(
                          'Nope',
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              } on Object {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Could not remove the food item. '
                        'Please try again.',
                      ),
                    ),
                  );
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white70),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
                child: Column(
                  children: [
                    ListTile(
                      // tileColor: Color(0xFF1e1f38),
                      title: Text(
                        foodName,
                        style: textColor.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      subtitle: Row(
                        children: <Widget>[
                          Text(
                            '🔥 $calories kcal      🍽 ${portionSize}g',
                            style: textColor.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    } else if (snapshot.connectionState == ConnectionState.done &&
        !snapshot.hasData) {
      // Handle no data
      return const Center(
        child: Text('No food items in list'),
      );
    } else {
      // Still loading
      return loadingWidget;
    }
  }

  // Opens a screen from the bottom up with the list of foods from the user's food shelf
  Future<void> _openFoodShelf() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (context) {
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Shows list of foods in the user's food shelf
  Widget _foodListFromFoodShelf() {
    return Expanded(
      child: StreamBuilder<List<ShelfFood>>(
        stream: _shelf.shelfStream(myUID(context)),
        builder: buildFoodShelfList,
      ),
    );
  }

  Widget buildFoodShelfList(
    BuildContext context,
    AsyncSnapshot<List<ShelfFood>> snapshot,
  ) {
    if (snapshot.hasData) {
      final foods = snapshot.data!;
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        // shrinkWrap: true,
        itemCount: foods.length,
        itemBuilder: (context, index) {
          final food = foods[index];
          final foodName = food.foodName;
          final brandName = food.brandName;

          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white70),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8.0),
                ),
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
                              Text(
                                foodName,
                                overflow: TextOverflow.ellipsis,
                                style: textColor.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                brandName,
                                style: textColor.copyWith(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 40,
                          child: RawMaterialButton(
                            onPressed: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute<Object>(
                                  builder: (context) => FoodDetails(
                                    food: food,
                                    mealIdValue: widget.mealIdValue,
                                  ),
                                ),
                              );
                            },
                            padding: const EdgeInsets.all(5.0),
                            shape: const CircleBorder(),

                            child: const Icon(
                              Icons.add_circle_outline_rounded,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    } else if (snapshot.connectionState == ConnectionState.done &&
        !snapshot.hasData) {
      // Handle no data
      return const Center(
        child: Text('No users found.'),
      );
    } else {
      // Still loading
      return loadingWidget;
    }
  }

  Future<void> documentsLoopFromFirestore() {
    return _meals.copyMealToFoodEntries(myUID(context), widget.mealIdValue!);
  }

  // This updates the fields in all documents from the foodItems collection.
  // It's necessary so that the food items can be read by the .where() filter in lib/food_tracker/food_tracker.dart
  Future<void> updateFieldsOnFoodItems() {
    return _meals.updateFoodItemsForDate(myUID(context), widget.mealIdValue!, {
      'mealType': selectedMealValue(),
      'weekNo': getWeekNumber(widget.selectedDateSecondStep!),
      'month': cleanMonthFormat(widget.selectedDateSecondStep.toString()),
      'year': cleanYearFormat(widget.selectedDateSecondStep.toString()),
      'dateAdded': widget.selectedDateSecondStep,
    });
  }
}
