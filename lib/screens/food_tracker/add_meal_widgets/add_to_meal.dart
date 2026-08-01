import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/screens/food_tracker/ui/food_shelf/food_shelf.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/theme.dart';

class AddToMeal extends StatefulWidget {
  final DateTime selectedDateValue;
  final MealType mealType;

  const AddToMeal({
    super.key,
    required this.selectedDateValue,
    required this.mealType,
  });

  @override
  State<AddToMeal> createState() => _AddToMealState();
}

class _AddToMealState extends State<AddToMeal> {
  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length)),
    ),
  );

  String generateMealId() {
    final foodId = getRandomString(20);
    return foodId;
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryBackgroundColor,
        title: Text(
          widget.mealType.title,
          style: titleTextStyle,
        ),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        _header(),
        addFoodButton(),
        _mealList(),
        _doneButton(),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget _header() {
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
                image: AssetImage(widget.mealType.assetPath),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget addFoodButton() {
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
              onTap: () async {
                await Future<void>.delayed(
                  const Duration(milliseconds: 200),
                  () async {
                    setState(() => loading = true);
                    final meal = mealTypeToString(widget.mealType)!;
                    if (!mounted) return;
                    await Navigator.push<Object>(
                      context,
                      MaterialPageRoute<Object>(
                        builder: (context) => FoodShelf(
                          selectedDateValue2: widget.selectedDateValue,
                          mealIdValue: generateMealId(),
                          breakfastMealValue: meal == 'breakfast' ? meal : null,
                          lunchMealValue: meal == 'lunch' ? meal : null,
                          snacksMealValue: meal == 'snacks' ? meal : null,
                          dinnerMealValue: meal == 'dinner' ? meal : null,
                        ),
                      ),
                    );
                    setState(() => loading = false);
                  },
                );
              },
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Add Food ',
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

  Widget _doneButton() {
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
                Future<void>.delayed(const Duration(milliseconds: 200), () {
                  if (!mounted) return;
                  navigator.pop();
                });
              },
              child: const Text(
                'Done',
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

  Widget _mealList() {
    return Expanded(
      child: StreamBuilder<List<FoodEntry>>(
        stream: context.read<FoodLogRepository>().mealEntries(
          myUID(context),
          widget.mealType,
          widget.selectedDateValue,
        ),
        builder: buildUserList,
      ),
    );
  }

  Widget buildUserList(
    BuildContext context,
    AsyncSnapshot<List<FoodEntry>> snapshot,
  ) {
    if (snapshot.hasData) {
      final entries = snapshot.data!;
      return ListView.builder(
        physics: const BouncingScrollPhysics(),
        // shrinkWrap: true,
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final food = entries[index];

          final foodName = food.foodName;
          final calories = food.calories;
          final portionSize = food.portionSize;

          return GestureDetector(
            key: Key(food.id),
            onLongPress: () async {
              try {
                await showDialog<String>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            'Removing from your ${widget.mealType.name}:',
                            style: const TextStyle(fontSize: 16),
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
                        child: const Text('Remove'),
                        onPressed: () async {
                          final navigator = Navigator.of(context);
                          await context.read<FoodLogRepository>().deleteEntry(
                            myUID(context),
                            food.id,
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
}
