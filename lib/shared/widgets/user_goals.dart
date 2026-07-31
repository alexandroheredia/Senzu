import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:senzu_app/shared/constants.dart';

dailyCalories(BuildContext context){

    return StreamBuilder(
    stream: dbUsersCollection
      .doc(myUID(context))
      .snapshots(),
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
      if (!snapshot.hasData) {
        return Text("Loading");
      }

      final documents = snapshot.data!;
      final dailyCaloriesGoal = documents.get('dailyCaloriesGoal');
      return Text('$dailyCaloriesGoal Cal', style: textColor.copyWith(fontSize: 30));
      }
    );
}

getUsername(BuildContext context){

    return StreamBuilder(
    stream: dbUsersCollection
      .doc(myUID(context))
      .snapshots(),
    builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
      if (!snapshot.hasData) {
        return Text("Loading");
      }

      final documents = snapshot.data!;
      final username = documents.get('username');
      return Text('Hey, $username!', style: textColor.copyWith(fontSize: 30, fontWeight: FontWeight.bold,));
      }
    );
}