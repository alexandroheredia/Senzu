import 'package:flutter/material.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/services/user_repository.dart';
import 'package:senzu_app/shared/theme.dart';
import 'package:senzu_app/shared/auth_scope.dart';

StreamBuilder<AppUser>  dailyCalories(BuildContext context){

    return StreamBuilder<AppUser>(
    stream: UserRepository(uid: myUID(context)).userData,
    builder: (context, snapshot){
      if (!snapshot.hasData) {
        return const Text('Loading');
      }

      final dailyCaloriesGoal = snapshot.data!.dailyCaloriesGoal;
      return Text('$dailyCaloriesGoal Cal', style: textColor.copyWith(fontSize: 30));
      }
    );
}

StreamBuilder<AppUser>  getUsername(BuildContext context){

    return StreamBuilder<AppUser>(
    stream: UserRepository(uid: myUID(context)).userData,
    builder: (context, snapshot){
      if (!snapshot.hasData) {
        return const Text('Loading');
      }

      final username = snapshot.data!.username;
      return Text('Hey, $username!', style: textColor.copyWith(fontSize: 30, fontWeight: FontWeight.bold,));
      }
    );
}