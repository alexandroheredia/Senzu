import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/services/auth_controller.dart';
import 'package:senzu_app/services/food_log_repository.dart';
import 'package:senzu_app/services/meal_repository.dart';
import 'package:senzu_app/services/shelf_repository.dart';
import 'package:senzu_app/services/user_repository.dart';

/// The signed-in user's data scope, or null while unknown/signed out.
///
/// Derived from the auth state: created only when a non-empty uid exists and
/// rebuilt automatically when the account changes. Widgets below the auth
/// gate read it through `context.repos`.
final userRepositoriesProvider = Provider<UserRepositories?>((ref) {
  final uid = ref.watch(authControllerProvider.select((state) => state.uid));
  if (uid == null) return null;
  return UserRepositories(uid: uid);
});

/// Everything the app needs to read and write one user's data.
///
/// Constructed ONLY for an authenticated user (see `AuthGate`); the
/// non-empty [uid] is captured at construction time and every repository is
/// bound to it, so no widget can ever query Firestore with a missing uid.
class UserRepositories {
  UserRepositories({required this.uid, FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance {
    if (uid.isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'must be a non-empty string');
    }
  }

  /// The uid of the signed-in user this scope belongs to.
  final String uid;

  final FirebaseFirestore _db;

  late final ShelfRepository shelf = ShelfRepository(uid: uid, db: _db);
  late final MealRepository meals = MealRepository(uid: uid, db: _db);
  late final FoodLogRepository foodLog = FoodLogRepository(uid: uid, db: _db);
  late final UserRepository user = UserRepository(uid: uid);
}
