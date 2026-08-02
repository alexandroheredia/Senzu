import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/food_entry.dart';
import 'package:senzu_app/models/meal.dart';
import 'package:senzu_app/models/shelf_food.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/services/user_repositories.dart';

/// Firestore-backed data providers derived from the signed-in user scope.
///
/// Every provider watches [userRepositoriesProvider], which is null while
/// signed out; they emit an empty stream in that case so they are safe to
/// read from anywhere (the UI below the auth gate never observes it).
///
/// These centralize the app's Firestore subscriptions: widgets `watch` them
/// instead of owning `StreamBuilder`s, the subscription lifecycle is managed
/// by Riverpod (auto-cancel when the scope or account changes), and tests can
/// override any of them with canned data.
final shelfStreamProvider = StreamProvider<List<ShelfFood>>((ref) {
  final repos = ref.watch(userRepositoriesProvider);
  return repos == null
      ? const Stream<List<ShelfFood>>.empty()
      : repos.shelf.shelfStream;
});

/// Live shelf sorted by times added (most-used first).
final topFoodsStreamProvider = StreamProvider<List<ShelfFood>>((ref) {
  final repos = ref.watch(userRepositoriesProvider);
  return repos == null
      ? const Stream<List<ShelfFood>>.empty()
      : repos.shelf.topFoodsStream;
});

/// Live list of the user's custom meals sorted by name.
final mealsStreamProvider = StreamProvider<List<Meal>>((ref) {
  final repos = ref.watch(userRepositoriesProvider);
  return repos == null
      ? const Stream<List<Meal>>.empty()
      : repos.meals.mealsStream;
});

/// Live list of food items inside one meal.
final foodItemsProvider =
    AutoDisposeStreamProviderFamily<List<MealFoodItem>, String>((ref, mealId) {
      final repos = ref.watch(userRepositoriesProvider);
      return repos == null
          ? const Stream<List<MealFoodItem>>.empty()
          : repos.meals.foodItemsStream(mealId);
    });

/// The signed-in user's profile document.
final userDataProvider = StreamProvider<AppUser>((ref) {
  final repos = ref.watch(userRepositoriesProvider);
  return repos == null ? const Stream<AppUser>.empty() : repos.user.userData;
});

/// Food entries logged on a given day.
final dayEntriesProvider =
    AutoDisposeStreamProviderFamily<List<FoodEntry>, DateTime>((ref, date) {
      final repos = ref.watch(userRepositoriesProvider);
      return repos == null
          ? const Stream<List<FoodEntry>>.empty()
          : repos.foodLog.dayEntries(date);
    });

/// Food entries added after a given instant.
final entriesSinceProvider =
    AutoDisposeStreamProviderFamily<List<FoodEntry>, DateTime>((ref, since) {
      final repos = ref.watch(userRepositoriesProvider);
      return repos == null
          ? const Stream<List<FoodEntry>>.empty()
          : repos.foodLog.entriesSince(since);
    });

/// Food entries logged for one meal type on a given day.
final mealEntriesProvider =
    AutoDisposeStreamProviderFamily<
      List<FoodEntry>,
      ({MealType meal, DateTime date})
    >((ref, key) {
      final repos = ref.watch(userRepositoriesProvider);
      return repos == null
          ? const Stream<List<FoodEntry>>.empty()
          : repos.foodLog.mealEntries(key.meal, key.date);
    });
