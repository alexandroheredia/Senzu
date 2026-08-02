import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/food_draft.dart';
import 'package:senzu_app/models/shelf_food.dart';

/// The global `foods` catalog repository. Not bound to a uid: the catalog is
/// shared by every user.
///
/// Used by the barcode flow to match a scanned barcode against foods the app
/// already knows, and to persist newly created foods so future scans hit the
/// catalog before any external API.
class FoodCatalogRepository {
  FoodCatalogRepository({FirebaseFirestore? db})
    : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _catalog =>
      _db.collection('foods');

  /// Looks up a food by UPC/EAN barcode. Returns null when unknown.
  Future<ShelfFood?> getByBarcode(String barcode) async {
    if (barcode.isEmpty) return null;
    final snapshot = await _catalog
        .where('barcode', isEqualTo: barcode)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) return null;
    final doc = snapshot.docs.first;
    return ShelfFood.fromMap(doc.id, doc.data());
  }

  /// Looks up a food by its catalog document id.
  Future<ShelfFood?> getById(String foodId) async {
    if (foodId.isEmpty) return null;
    final doc = await _catalog.doc(foodId).get();
    if (!doc.exists) return null;
    return ShelfFood.fromMap(doc.id, doc.data() ?? const {});
  }

  /// Persists (or merges) a food into the catalog. Idempotent.
  Future<void> upsert(FoodDraft draft) {
    if (draft.foodId.isEmpty) {
      throw ArgumentError.value(
        draft.foodId,
        'foodId',
        'a foodId is required to upsert into the catalog',
      );
    }
    return _catalog
        .doc(draft.foodId)
        .set(
          draft.toFoodMap(),
          SetOptions(merge: true),
        );
  }
}

/// The shared catalog repository. Global (not user-scoped).
final foodCatalogRepositoryProvider = Provider<FoodCatalogRepository>(
  (ref) => FoodCatalogRepository(),
);
