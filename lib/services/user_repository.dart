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

  /// Writes the profile fields collected by onboarding / edit-profile.
  ///
  /// Merges into the existing document so unrelated fields (e.g. the daily
  /// goal or macro targets) are preserved.
  Future<void> updateProfile({
    required String username,
    required String sex,
    required String activityLevel,
    required double heightCm,
    required double weightKg,
    required int ageYears,
  }) async {
    return dbUsersCollection.doc(uid).set({
      'username': username,
      'sex': sex,
      'activityLevel': activityLevel,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'ageYears': ageYears,
    }, SetOptions(merge: true));
  }

  /// Marks the onboarding wizard as complete.
  Future<void> completeOnboarding() async {
    return dbUsersCollection.doc(uid).update({
      'onboardingComplete': true,
    });
  }

  /// Deletes every piece of this user's data: the profile document and all
  /// subcollections (food entries, shelf, weight entries, meals + their
  /// nested food items). Used by account deletion.
  Future<void> deleteAllUserData() async {
    final docRef = dbUsersCollection.doc(uid);

    for (final sub in ['foodEntries', 'foodShelf', 'weightEntries']) {
      final snapshot = await docRef.collection(sub).get();
      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    }

    // Meals each have a nested foodItems subcollection.
    final mealsSnapshot = await docRef.collection('meals').get();
    for (final meal in mealsSnapshot.docs) {
      final items = await meal.reference.collection('foodItems').get();
      for (final item in items.docs) {
        await item.reference.delete();
      }
      await meal.reference.delete();
    }

    await docRef.delete();
  }

  /// Sets the per-day macro targets (grams). Zero values are stored as-is so
  /// callers can intentionally clear a target.
  Future<void> updateMacroGoals({
    required int proteinGoalG,
    required int carbGoalG,
    required int fatGoalG,
  }) async {
    return dbUsersCollection.doc(uid).update({
      'proteinGoalG': proteinGoalG,
      'carbGoalG': carbGoalG,
      'fatGoalG': fatGoalG,
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
