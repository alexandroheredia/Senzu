import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/food_draft.dart';
import 'package:senzu_app/services/food_catalog_repository.dart';
import 'package:senzu_app/services/open_food_facts_api.dart';

/// Where a barcode lookup was resolved.
enum BarcodeLookupSource {
  /// Matched a food already in the app's global `foods` catalog.
  catalog,

  /// Not in the catalog; matched via the free Open Food Facts API.
  api,

  /// Unknown barcode — the user must create the food manually.
  notFound,
}

/// Result of a barcode lookup.
class BarcodeLookupResult {
  const BarcodeLookupResult(this.source, {this.draft});

  final BarcodeLookupSource source;

  /// The matched food when [source] is `catalog` or `api`.
  final FoodDraft? draft;
}

/// Orchestrates the barcode flow:
///
///  1. match against the app's own `foods` catalog (Firestore),
///  2. fall back to the free Open Food Facts API,
///  3. otherwise report [BarcodeLookupSource.notFound] so the caller opens
///     the manual `AddFood` flow (pre-filled with the scanned barcode).
class FoodLookupService {
  FoodLookupService({
    required FoodCatalogRepository catalog,
    required OpenFoodFactsApi api,
  }) : _catalog = catalog,
       _api = api;

  final FoodCatalogRepository _catalog;
  final OpenFoodFactsApi _api;

  Future<BarcodeLookupResult> lookupBarcode(String barcode) async {
    final existing = await _catalog.getByBarcode(barcode);
    if (existing != null) {
      return BarcodeLookupResult(
        BarcodeLookupSource.catalog,
        draft: FoodDraft.fromShelfFood(existing),
      );
    }

    final apiDraft = await _api.lookupByBarcode(barcode);
    if (apiDraft != null) {
      return BarcodeLookupResult(BarcodeLookupSource.api, draft: apiDraft);
    }

    return const BarcodeLookupResult(BarcodeLookupSource.notFound);
  }
}

/// The barcode lookup orchestrator. Override [openFoodFactsApiProvider] and
/// [foodCatalogRepositoryProvider] in tests.
final foodLookupServiceProvider = Provider<FoodLookupService>((ref) {
  return FoodLookupService(
    catalog: ref.watch(foodCatalogRepositoryProvider),
    api: ref.watch(openFoodFactsApiProvider),
  );
});
