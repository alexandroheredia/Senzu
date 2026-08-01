import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/screens/food_tracker/add_meal_widgets/add_to_meal.dart';
import 'package:senzu_app/screens/food_tracker/ui/nutrient_stats.dart';
import 'package:senzu_app/screens/food_tracker/widgets/date_calculator.dart';
import 'package:senzu_app/screens/food_tracker/widgets/meal_card.dart';
import 'package:senzu_app/screens/top_foods/top_foods_list.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/daily_values_constants.dart';
import 'package:senzu_app/shared/theme.dart';
import 'package:senzu_app/shared/widgets/user_goals.dart';

class FoodTracker extends StatefulWidget {
  const FoodTracker({super.key});

  @override
  State<FoodTracker> createState() => _FoodTrackerState();
}

class _FoodTrackerState extends State<FoodTracker> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;

  // static const TextStyle optionStyle =
  //   TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const FoodOverview(),
    const NutrientStats(),
    const TopFoodsList(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Food', style: titleTextStyle),
          centerTitle: true,
          elevation: 0,
          backgroundColor: primaryBackgroundColor,
        ),
        bottomNavigationBar: Theme(
          data: ThemeData(unselectedWidgetColor: Colors.white),
          child: BottomNavigationBar(
            backgroundColor: const Color(0xFF1e1f38),
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: FaIcon(FontAwesomeIcons.utensils),
                label: 'Food',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.chartPie),
                label: 'Stats',
              ),
              BottomNavigationBarItem(
                icon: FaIcon(FontAwesomeIcons.trophy),
                label: 'Top Foods',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: primaryButtonColor,
            onTap: _onItemTapped,
          ),
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        // body: FoodOverview(),
        backgroundColor: primaryBackgroundColor,
      ),
    );
  }
}

class FoodOverview extends StatefulWidget {
  const FoodOverview({super.key});

  @override
  State<FoodOverview> createState() => _FoodOverviewState();
}

class _FoodOverviewState extends State<FoodOverview> {
  DateTime _value = DateTime.now();
  DateTime today = DateTime.now();

  late final FoodLogRepository _foodLog;

  @override
  void initState() {
    super.initState();
    _foodLog = context.read<FoodLogRepository>();
  }

  Color _rightArrowColour = const Color(0xffC1C1C1);

  /// The selected day normalized to midnight; used for queries and saving.
  DateTime get _selectedDate => startOfDay(_value);

  Future<void> _openMeal(MealType mealType) async {
    await Future<void>.delayed(const Duration(milliseconds: 200), () async {
      if (!mounted) return;
      await Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (context) =>
              AddToMeal(mealType: mealType, selectedDateValue: _selectedDate),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FoodLogSummary>(
      stream: _foodLog.daySummary(myUID(context), _selectedDate),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const Center(child: loadingWidget);
        final summary = snapshot.data!;
        final totalCaloriesSum = summary.totalCalories;
        final breakfastCaloriesSum = summary.breakfastCalories;
        final lunchCaloriesSum = summary.lunchCalories;
        final snacksCaloriesSum = summary.snacksCalories;
        final dinnerCaloriesSum = summary.dinnerCalories;
        final carbsSum = summary.totalCarbohydrate;
        final fatSum = summary.totalFat;
        final proteinSum = summary.protein;

        double fatPercentage() {
          final fatPercentage = fatSum / totalFatDailyValue;
          return fatPercentage;
        }

        double carbsPercentage() {
          final carbsPercentage = carbsSum / totalCarbohydrateDailyValue;
          return carbsPercentage;
        }

        double proteinPercentage() {
          final proteinPercentage = proteinSum / proteinDailyValue;
          return proteinPercentage;
        }

        return Scaffold(
          backgroundColor: primaryBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
                    child: Column(
                      children: <Widget>[
                        // Date picker
                        Row(
                          children: <Widget>[
                            // Left edge box
                            const SizedBox(height: 10, width: 10),

                            // Back 1 day arrow
                            IconButton(
                              icon: const Icon(Icons.arrow_back_ios, size: 25.0),
                              color: Colors.grey,
                              onPressed: () {
                                setState(() {
                                  _value = _value.subtract(const Duration(days: 1));
                                  _rightArrowColour = Colors.grey;
                                });
                              },
                            ),

                            // Date picker pill shape
                            Expanded(
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                        primaryButtonColor,
                                      ),
                                  foregroundColor:
                                      WidgetStateProperty.all<Color>(
                                        Colors.white,
                                      ),
                                  shape:
                                      WidgetStateProperty.all<
                                        RoundedRectangleBorder
                                      >(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18.0,
                                          ),
                                        ),
                                      ),
                                ),
                                onPressed: _selectDate,
                                child: Text(
                                  _dateFormatter(_value),
                                  style: const TextStyle(
                                    fontFamily: 'Open Sans',
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                            // forward 1 day arrow (disabled if date picker is on current date)
                            IconButton(
                              icon: const Icon(Icons.arrow_forward_ios, size: 25.0),
                              color: _rightArrowColour,
                              onPressed: () {
                                if (today
                                        .difference(_value)
                                        .compareTo(const Duration(days: 1)) ==
                                    -1) {
                                  setState(() {
                                    _rightArrowColour = Colors.grey.shade900;
                                  });
                                } else {
                                  setState(() {
                                    _value = _value.add(const Duration(days: 1));
                                  });
                                  if (today
                                          .difference(_value)
                                          .compareTo(const Duration(days: 1)) ==
                                      -1) {
                                    setState(() {
                                      _rightArrowColour = Colors.grey.shade900;
                                    });
                                  }
                                }
                              },
                            ),

                            // Right edge box
                            const SizedBox(height: 10, width: 20),
                          ],
                        ),
                        // Intake vs Target totals
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            // Total intake for that day
                            Text(
                              '$totalCaloriesSum',
                              style: textColor.copyWith(
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '/',
                              style: textColor.copyWith(fontSize: 30),
                            ),

                            // Calorie target from Firestore
                            dailyCalories(context),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 'Add meals' overview panel
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              MealCard(
                                mealType: MealType.breakfast,
                                calories: breakfastCaloriesSum,
                                onTap: () => _openMeal(MealType.breakfast),
                              ),
                              MealCard(
                                mealType: MealType.lunch,
                                calories: lunchCaloriesSum,
                                onTap: () => _openMeal(MealType.lunch),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              MealCard(
                                mealType: MealType.snacks,
                                calories: snacksCaloriesSum,
                                onTap: () => _openMeal(MealType.snacks),
                              ),
                              MealCard(
                                mealType: MealType.dinner,
                                calories: dinnerCaloriesSum,
                                onTap: () => _openMeal(MealType.dinner),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Nutrient intake summary panel
                  Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 10.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Detailed Nutrients',
                              style: textColor.copyWith(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // 3 circular indicators (2 * radius each) + 2 x 10px
                      // spacers must fit within the available width.
                      final radius = ((constraints.maxWidth - 20) / 6)
                          .clamp(30.0, 80.0);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 10),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (carbsPercentage() > 1) {
                                  return Column(
                                    children: [
                                      CircularPercentIndicator(
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        radius: radius,
                                        lineWidth: 13.0,
                                        percent: 1.0,
                                        center: Text(
                                          '${(carbsPercentage() * 100).toStringAsFixed(0)}%',
                                          style: textColor.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        progressColor: Colors.red,
                                      ),
                                      Text(
                                        'Carbs',
                                        style: textColor.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      CircularPercentIndicator(
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        radius: radius,
                                        lineWidth: 13.0,
                                        percent: carbsPercentage(),
                                        center: Text(
                                          '${(carbsPercentage() * 100).toStringAsFixed(0)}%',
                                          style: textColor.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        progressColor: Colors.green,
                                      ),
                                      Text(
                                        'Carbs',
                                        style: textColor.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (proteinPercentage() > 1) {
                                  return Column(
                                    children: [
                                      CircularPercentIndicator(
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        radius: radius,
                                        lineWidth: 13.0,
                                        percent: 1.0,
                                        center: Text(
                                          '${(proteinPercentage() * 100).toStringAsFixed(0)}%',
                                          style: textColor.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        progressColor: Colors.green,
                                      ),
                                      Text(
                                        'Protein',
                                        style: textColor.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      CircularPercentIndicator(
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        radius: radius,
                                        lineWidth: 13.0,
                                        percent: proteinPercentage(),
                                        center: Text(
                                          '${(proteinPercentage() * 100).toStringAsFixed(0)}%',
                                          style: textColor.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        progressColor: Colors.green,
                                      ),
                                      Text(
                                        'Protein',
                                        style: textColor.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          Expanded(
                            child: Builder(
                              builder: (context) {
                                if (fatPercentage() > 1) {
                                  return Column(
                                    children: [
                                      CircularPercentIndicator(
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        radius: radius,
                                        lineWidth: 13.0,
                                        percent: 1.0,
                                        center: Text(
                                          '${(fatPercentage() * 100).toStringAsFixed(0)}%',
                                          style: textColor.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        progressColor: Colors.red,
                                      ),
                                      Text(
                                        'Fat',
                                        style: textColor.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Column(
                                    children: [
                                      CircularPercentIndicator(
                                        circularStrokeCap:
                                            CircularStrokeCap.round,
                                        radius: radius,
                                        lineWidth: 13.0,
                                        percent: fatPercentage(),
                                        center: Text(
                                          '${(fatPercentage() * 100).toStringAsFixed(0)}%',
                                          style: textColor.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        progressColor: Colors.green,
                                      ),
                                      Text(
                                        'Fat',
                                        style: textColor.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 6),

                  // Nutrients intake values
                  _nutrientsTotal(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _value,
      firstDate: DateTime(2015),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData().copyWith(
            primaryColor: Colors.black,
            shadowColor: Colors.black,
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
            colorScheme: ColorScheme.light(
              primary: Colors.grey.shade900,
            ).copyWith(surface: Colors.yellow),
          ),
          child: child ?? const SizedBox(),
        );
      },
    );
    setState(() => _value = picked!);
    _stateSetter();
  }

  void _stateSetter() {
    if (today.difference(_value).compareTo(const Duration(days: 1)) == -1) {
      setState(() => _rightArrowColour = Colors.grey);
    } else {
      setState(() => _rightArrowColour = Colors.grey);
    }
  }

  String _dateFormatter(DateTime tm) {
    final today = DateTime.now();
    const oneDay = Duration(days: 1);
    const twoDay = Duration(days: 2);
    var month = '';
    switch (tm.month) {
      case 1:
        month = 'Jan';
      case 2:
        month = 'Feb';
      case 3:
        month = 'Mar';
      case 4:
        month = 'Apr';
      case 5:
        month = 'May';
      case 6:
        month = 'Jun';
      case 7:
        month = 'Jul';
      case 8:
        month = 'Aug';
      case 9:
        month = 'Sep';
      case 10:
        month = 'Oct';
      case 11:
        month = 'Nov';
      case 12:
        month = 'Dec';
    }

    final difference = today.difference(tm);

    if (difference.compareTo(oneDay) < 1) {
      return 'Today';
    } else if (difference.compareTo(twoDay) < 1) {
      return 'Yesterday';
    } else {
      return '${tm.day} $month ${tm.year}';
    }
  }

  Widget _nutrientsTotal() {
    return StreamBuilder<FoodLogSummary>(
      stream: _foodLog.daySummary(myUID(context), _selectedDate),
      builder: _buildNutrientsTotal,
    );
  }

  Widget _buildNutrientsTotal(
    BuildContext context,
    AsyncSnapshot<FoodLogSummary> snapshot,
  ) {
    if (!snapshot.hasData) return loadingWidget;

    final summary = snapshot.data!;
    final proteinSum = summary.protein;
    final dietaryFiberSum = summary.dietaryFiber;
    final potassiumSum = summary.potassium;
    final vitaminASum = summary.vitaminA;
    final vitaminCSum = summary.vitaminC;
    final vitaminDSum = summary.vitaminD;
    final calciumSum = summary.calcium;
    final ironSum = summary.iron;
    final saturatedFatSum = summary.saturatedFat;
    final sodiumSum = summary.sodium;
    final magnesiumSum = summary.magnesium;
    final zincSum = summary.zinc;


    return Container(
      padding: const EdgeInsets.fromLTRB(30.0, 0, 30.0, 30.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (proteinSum > proteinDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Protein', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                proteinSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${proteinDailyValue}g',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (dietaryFiberSum > dietaryFiberDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Dietary Fiber', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                dietaryFiberSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${dietaryFiberDailyValue}g',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (potassiumSum > potassiumDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Potassium', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                potassiumSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${potassiumDailyValue}mg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (vitaminASum > vitaminADailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Vitamin A', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                vitaminASum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${vitaminADailyValue}mcg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (vitaminCSum > vitaminCDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Vitamin C', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                vitaminCSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${vitaminCDailyValue}mg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (vitaminDSum > vitaminDDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Vitamin D', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                vitaminDSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${vitaminDDailyValue}mg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (calciumSum > calciumDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Calcium', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                calciumSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${calciumDailyValue}mg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (ironSum > ironDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Iron', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                ironSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${ironDailyValue}mg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (saturatedFatSum == 0 ||
                        saturatedFatSum < saturatedFatDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return highIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Saturated Fat', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                saturatedFatSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${saturatedFatDailyValue}g',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (sodiumSum == 0) {
                      return lowIntakeIcon;
                    }
                    if (sodiumSum < sodiumDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return highIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Sodium', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                sodiumSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${sodiumDailyValue}mg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (magnesiumSum > magnesiumDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Magnesium', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                magnesiumSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${magnesiumDailyValue}mg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Builder(
                  builder: (context) {
                    if (zincSum > zincDailyValue) {
                      return goodIntakeIcon;
                    } else {
                      return lowIntakeIcon;
                    }
                  },
                ),
              ),
              Text('Zinc', style: textColor.copyWith(fontSize: 15)),
              const Expanded(child: nutrientsDivider),
              Text(
                zincSum.toStringAsFixed(0),
                style: textColor.copyWith(fontSize: 15),
              ),
              Text(
                '/${zincDailyValue}mg',
                style: textColor.copyWith(fontSize: 15),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(child: lowIntakeIcon),
                const Text(' Low intake', style: textColor),
                const SizedBox(height: 10, width: 15),
                Container(child: goodIntakeIcon),
                const Text(' Average', style: textColor),
                const SizedBox(height: 10, width: 15),
                Container(child: highIntakeIcon),
                const Text(' High intake', style: textColor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
