import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:senzu_app/screens/food_tracker/food_tracker.dart';
import 'package:senzu_app/screens/home/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:senzu_app/screens/nutrients_display/nutrients_display.dart';
import 'package:senzu_app/shared/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});


  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Senzu',
        style: titleTextStyle
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: primaryBackgroundColor,
        actions: [
          IconButton(
            onPressed: (){
              showModalBottomSheet(
                backgroundColor: primaryBackgroundColor,
                context: context,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text('Something is not working?', style: textColor.copyWith(fontSize: 18, fontWeight: FontWeight.bold),),
                          subtitle: Text('We beg you to please let us know and we will fix it as soon as possible. You can reach us here: \n  - Reddit: r/SenzuApp \n  - Email: nointrobusiness@gmail.com',
                            style: textColor.copyWith(),),
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  );
                });
            }, 
            icon: FaIcon(FontAwesomeIcons.screwdriverWrench)
          )
        ],
      ),
      body: HomeWidgets(),
      backgroundColor: primaryBackgroundColor,
      drawer: Theme(
        data: Theme.of(context).copyWith(
               canvasColor: primaryBackgroundColor,
            ),
        child: CustomDrawer()),
    );
  }
}

class HomeWidgets extends StatelessWidget {
  const HomeWidgets({super.key});


  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        NutrientsListPage(),
        FoodTrackerCard(),
        // Text('${myUID(context)}',
        //   style: TextStyle(
        //     color: Colors.white
        //   ),
        // ),
      ],
    );
  }
}

class NutrientsListPage extends StatelessWidget {
  const NutrientsListPage({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            // Navigator.pushNamed(context, '/nutrients_display');
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => NutrientsDisplay()));
          },
          child: const SizedBox(
            width: 450,
            height: 100,
            child: Center(
              child: Text('🏆 Top Nutrients List',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                )
              ),
            )
          ),
        ),
      ),
    );
  }
}


class FoodTrackerCard extends StatefulWidget {
  const FoodTrackerCard({super.key});

  @override
  _FoodTrackerCardState createState() => _FoodTrackerCardState();
}

class _FoodTrackerCardState extends State<FoodTrackerCard> {

  @override  
  void initState() {  
    super.initState();  
  } 



  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            // Navigator.pushNamed(context, '/food_tracker');
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => FoodTracker()));
          },
          child: SizedBox(
              width: 450,
              height: 100,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('🥗 Food Tracker',
                      style: TextStyle(
                        color: Color(0xFFE0E0E0),
                        fontWeight: FontWeight.bold,
                        fontSize: 30.0,
                      )
                      ),
                  ],
                ),
              )
            ),
          ),
        ),
      );
    }
}

