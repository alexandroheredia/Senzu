import 'package:flutter/material.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/calcium.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/fiber.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/iron.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/potassium.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/protein.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/vitamin_a.dart';
import 'package:senzu_app/screens/nutrients_display/nutrient_pages/vitamin_c.dart';
import 'package:senzu_app/shared/theme.dart';

class NutrientsDisplay extends StatelessWidget {
  const NutrientsDisplay({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nutrients List',
        style: titleTextStyle,),
        centerTitle: true,
        backgroundColor: primaryBackgroundColor,
        elevation: 0,
      ),
      body: NutrientList(),
      backgroundColor: primaryBackgroundColor,
    );
  }
}

class NutrientList extends StatelessWidget {
  const NutrientList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        FiberCard(),
        ProteinCard(),
        PotassiumCard(),
        VitaminACard(),
        VitaminCCard(),
        IronCard(),
        CalciumCard(),
      ],
    );
  }
}

// TODO: REMOVE ALL OF THESE... It's insane to have all these stateless widgets for this.
class FiberCard extends StatelessWidget {
  const FiberCard({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Fiber()));
          },
          child: const SizedBox(
              width: 450,
              height: 100,
              child: Center(
                child: Text('Fiber',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),
              )),
        ),
      ),
    );
  }
}

// Card widget that takes you to the top foods for Protein datatable
class ProteinCard extends StatelessWidget {
  const ProteinCard({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Protein()));
          },
          child: const SizedBox(
              width: 450,
              height: 100,
              child: Center(
                child: Text('Protein',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),
              )),
        ),
      ),
    );
  }
}

// Card widget that takes you to the top foods for Potassium datatable
class PotassiumCard extends StatelessWidget {
  const PotassiumCard({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Potassium()));
          },
          child: const SizedBox(
              width: 450,
              height: 100,
              child: Center(
                child: Text('Potassium',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),
              )),
        ),
      ),
    );
  }
}

// Card widget that takes you to the top foods for Vitamin A datatable
class VitaminACard extends StatelessWidget {
  const VitaminACard({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => VitaminA()));
          },
          child: const SizedBox(
              width: 450,
              height: 100,
              child: Center(
                child: Text('Vitamin A',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),
              )),
        ),
      ),
    );
  }
}

// Card widget that takes you to the top foods for Vitamin C datatable
class VitaminCCard extends StatelessWidget {
  const VitaminCCard({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => VitaminC()));
          },
          child: const SizedBox(
              width: 450,
              height: 100,
              child: Center(
                child: Text('Vitamin C',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),
              )),
        ),
      ),
    );
  }
}

// Card widget that takes you to the top foods for Iron datatable
class IronCard extends StatelessWidget {
  const IronCard({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Iron()));
          },
          child: const SizedBox(
              width: 450,
              height: 100,
              child: Center(
                child: Text('Iron',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),
              )),
        ),
      ),
    );
  }
}

// Card widget that takes you to the top foods for Calcium datatable
class CalciumCard extends StatelessWidget {
  const CalciumCard({super.key});


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        color: Color(0xFF1e1f38),
        child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => Calcium()));
          },
          child: const SizedBox(
              width: 450,
              height: 100,
              child: Center(
                child: Text('Calcium',
                    style: TextStyle(
                      color: Color(0xFFE0E0E0),
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                    )),
              )),
        ),
      ),
    );
  }
}
