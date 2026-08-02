import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/shared/firestore_db.dart';

class UserRepository {
  final String uid;
  UserRepository({required this.uid});

  /// Creates the user document with default profile values if it does not
  /// exist yet. Idempotent: safe to call on every auth change.
  Future<void> ensureExists() async {
    final doc = dbUsersCollection.doc(uid);
    final snapshot = await doc.get();
    if (snapshot.exists) return;
    await doc.set({
      'sex': 'male',
      'activityLevel': 'sedentary',
      'dailyCaloriesGoal': 2400,
    });
  }

  Future<void> updateUserData(
    String sex,
    String activityLevel,
    int dailyCaloriesGoal,
  ) async {
    return dbUsersCollection.doc(uid).set({
      'sex': sex,
      'activityLevel': activityLevel,
      'dailyCaloriesGoal': dailyCaloriesGoal,
    });
  }

  /// Updates only the daily calories goal of the user document.
  Future<void> updateDailyCaloriesGoal(dynamic dailyCaloriesGoal) async {
    return dbUsersCollection.doc(uid).update({
      'dailyCaloriesGoal': dailyCaloriesGoal,
    });
  }

  // users list from snapshot
  List<AppUser> _usersListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return AppUser.fromMap(doc.data()! as Map<String, dynamic>, uid: doc.id);
    }).toList();
  }

  // user data from snapshots
  AppUser _userDataFromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data();
    return AppUser.fromMap(
      data is Map<String, dynamic> ? data : const {},
      uid: uid,
    );
  }

  Stream<List<AppUser>> get users {
    return dbUsersCollection.snapshots().map(_usersListFromSnapshot);
  }

  Stream<AppUser> get userData {
    return dbUsersCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
