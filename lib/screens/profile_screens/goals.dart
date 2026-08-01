import 'package:flutter/material.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/firestore_db.dart';
import 'package:senzu_app/shared/theme.dart';

class NutritionGoals extends StatefulWidget {
  const NutritionGoals({super.key});

  @override
  State<NutritionGoals> createState() => _NutritionGoalsState();
}

class _NutritionGoalsState extends State<NutritionGoals> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nutrition Goals'),
        centerTitle: true,
        backgroundColor: primaryBackgroundColor,
      ),
      body: nutritionGoalsBody(),
      backgroundColor: primaryBackgroundColor,
    );
  }

Widget nutritionGoalsBody(){

    return StreamBuilder(
    stream: dbUsersCollection
      .doc(myUID(context))
      .snapshots(),
    builder: (context, snapshot){
      if (!snapshot.hasData) {
        return const Text('Loading');
      }

      final documents = snapshot.data!;
      final dailyCaloriesGoal = documents.get('dailyCaloriesGoal');
      final usernameController = TextEditingController(text: dailyCaloriesGoal.toString());
      // return Text(username.toString());
      return Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text('Daily Calories Goal: ',
                style: textColor.copyWith(fontSize: 20),),
                SizedBox(
                  width: 70,
                  height: 40,
                  child: TextFormField(
                    style: textColor.copyWith(fontSize: 18),
                    decoration: textInputDecoration,
                    controller: usernameController,
                  ),
                )
              ],
            ),
          ),
          Container(
            height: 40.0,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.0),
              color: primaryButtonColor
            ),
            child: MaterialButton(
              onPressed: () async {
                final scaffoldMessenger = ScaffoldMessenger.of(context);
                try {
                  await dbUsersCollection
                    .doc(myUID(context))
                    .update({'dailyCaloriesGoal': usernameController.text});
                  if (!mounted) return;
                  scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Daily calories intake goal updated successfully!')));
                } on Object {
                  if (context.mounted) {
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(content: Text('Failed to update goals.')),
                    );
                  }
                }
              },
              child: const Text('Update',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
              ),
            ),
          ),
        ],
      );
    }
  );
}

}
