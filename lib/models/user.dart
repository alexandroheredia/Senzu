
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String username;
  final String sex;
  final String activityLevel;
  final int dailyCaloriesGoal;
  
  
  AppUser({
    this.uid = '',
    this.username = '',
    this.sex = '',
    this.activityLevel = '',
    this.dailyCaloriesGoal = 0,
  });


  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      username: doc['username'] ?? '',
    );
  }
}

// class UserData {

//   final String uid;
//   final String sex;
//   final String activityLevel;


//   UserData({ this.uid, this.sex, this.activityLevel });

// }
