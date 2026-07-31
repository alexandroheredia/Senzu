import 'package:senzu_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/shared/constants.dart';

class DatabaseService {

  final String uid;
  DatabaseService({ required this.uid });

  Future<void> updateUserData(String sex, String activityLevel, int dailyCaloriesGoal) async {
    return await dbUsersCollection.doc(uid).set({
      'sex': sex,
      'activityLevel': activityLevel,
      'dailyCaloriesGoal': dailyCaloriesGoal,
    });
  }

  // users list from snapshot
  List<AppUser> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return AppUser(
        sex: doc.get('sex') ?? '',
        activityLevel: doc.get('activityLevel') ?? '',
        dailyCaloriesGoal: doc.get('dailyCaloriesGoal') ?? 0, uid: '', username: ''
      );
    }).toList();
  }

  // user data from snapshots
  AppUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return AppUser(
      uid: uid,
      sex: snapshot.get('sex'),
      activityLevel: snapshot.get('activityLevel'),
      dailyCaloriesGoal: snapshot.get('dailyCaloriesGoal'),
    );
  }

  Stream<List<AppUser>> get users {
    return dbUsersCollection.snapshots()
      .map(_usersListFromSnapshot);
  }

  Stream<AppUser> get userData {
    return dbUsersCollection.doc(uid).snapshots()
      .map(_userDataFromSnapshot);
  }

}