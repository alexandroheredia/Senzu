import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:senzu_app/models/recipe.dart';

/// Data access for the `users/{uid}/recipes` collection.
///
/// Bound to a single authenticated user's [uid] at construction; obtain from
/// `UserRepositories.recipes`.
class RecipeRepository {
  RecipeRepository({required this.uid, FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance {
    if (uid.isEmpty) {
      throw ArgumentError.value(uid, 'uid', 'must be a non-empty string');
    }
  }

  /// The uid of the user this repository reads and writes.
  final String uid;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _recipes =>
      _db.collection('users').doc(uid).collection('recipes');

  /// Live list of the user's recipes sorted by name.
  Stream<List<Recipe>> get recipesStream => _recipes
      .orderBy('name')
      .snapshots()
      .map(
        (s) => s.docs
            .map((doc) => Recipe.fromMap(doc.id, doc.data()))
            .toList(),
      );

  /// Creates a new recipe (doc id = the recipe's own id, which should be a
  /// fresh generated id so it doubles as the food id when logging a serving).
  Future<void> create(Recipe recipe) {
    return _recipes.doc(recipe.id).set(recipe.toMap());
  }

  /// Replaces a recipe's contents. Recipes are small, so a full overwrite is
  /// simpler and safer than array surgery.
  Future<void> update(Recipe recipe) {
    return _recipes.doc(recipe.id).set(recipe.toMap());
  }

  /// Removes a recipe.
  Future<void> delete(String recipeId) {
    return _recipes.doc(recipeId).delete();
  }
}
