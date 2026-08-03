import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:senzu_app/models/food_draft.dart';

/// Free barcode food-data lookup via the Open Food Facts public API.
///
/// No API key required. Groundwork for the barcode-scanning flow: when a
/// scanned barcode is not in the app's own `foods` catalog, this service is
/// queried before falling back to manual entry.
class OpenFoodFactsApi {
  OpenFoodFactsApi({http.Client? client, this.baseUrl = _defaultBase})
    : _client = client ?? http.Client();

  static const String _defaultBase = 'https://world.openfoodfacts.org';
  static const String _fields =
      'code,status,status_verbose,product_name,brands,serving_size,nutriments';

  final http.Client _client;
  final String baseUrl;

  /// Looks up a product by UPC/EAN barcode, normalized into the app's food
  /// schema. Returns null when the code is unknown or the product has no
  /// usable nutrition data.
  Future<FoodDraft?> lookupByBarcode(String barcode) async {
    if (barcode.isEmpty) return null;
    final uri = Uri.parse('$baseUrl/api/v2/product/$barcode.json').replace(
      queryParameters: {'fields': _fields},
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) return null;

    final json = jsonDecode(response.body);
    if (json is! Map<String, dynamic>) return null;
    if (json['status'] != 1) return null;

    final draft = openFoodFactsDraftFromJson(json, barcode: barcode);
    return draft.isEmpty ? null : draft;
  }

  /// Searches the Open Food Facts database by product name.
  ///
  /// Returns up to [limit] results as drafts, in the app's food schema.
  /// Results without a product name are dropped (sparse or placeholder
  /// entries). Best-effort: any failure (network, parsing) returns an empty
  /// list so the caller can fall back to manual entry.
  Future<List<FoodDraft>> searchByName(String query, {int limit = 20}) async {
    if (query.trim().length < 3) return const [];
    final uri = Uri.parse('$baseUrl/api/v2/search').replace(
      queryParameters: {
        'query': query.trim(),
        'fields': _fields,
        'page_size': '$limit',
      },
    );

    final http.Response response;
    try {
      response = await _client.get(uri);
    } on Object {
      return const [];
    }
    if (response.statusCode != 200) return const [];

    final Object? decoded;
    try {
      decoded = jsonDecode(response.body);
    } on Object {
      return const [];
    }
    if (decoded is! Map<String, dynamic>) return const [];

    final products = decoded['products'];
    if (products is! List) return const [];

    final drafts = <FoodDraft>[];
    for (final item in products) {
      if (item is! Map<String, dynamic>) continue;
      final code = item['code']?.toString() ?? '';
      final draft = openFoodFactsDraftFromJson({'product': item}, barcode: code);
      // Keep anything with a name; nutrition may be partial, which the user
      // can fill in when logging.
      if (draft.foodName.trim().isNotEmpty) drafts.add(draft);
    }
    return drafts;
  }

  void dispose() => _client.close();
}

/// The Open Food Facts API client. Override in tests.
final openFoodFactsApiProvider = Provider<OpenFoodFactsApi>((ref) {
  return OpenFoodFactsApi();
});

// ---------------------------------------------------------------------------
// Normalization (pure, unit-testable)
// ---------------------------------------------------------------------------

/// Normalizes an Open Food Facts v2 product response into a [FoodDraft].
///
/// OFF reports nutrients per 100 g by default and per serving when the
/// product declares one. The draft uses the app's own serving size with
/// per-serving amounts, so when a serving is declared we scale the per-100 g
/// values to it.
FoodDraft openFoodFactsDraftFromJson(
  Map<String, dynamic> json, {
  String barcode = '',
}) {
  final product = json['product'];
  if (product is! Map<String, dynamic>) return const FoodDraft();

  final nutriments = product['nutriments'];
  final nutrients = nutriments is Map<String, dynamic>
      ? nutriments
      : const <String, dynamic>{};

  final serving = _parseServing(product['serving_size']?.toString() ?? '');
  final servingSize = serving ?? 100.0;

  double amount(String appKey, String offKey) {
    if (serving != null) {
      final perServing = _num(nutrients['${offKey}_serving']);
      if (perServing != null) return perServing;
    }
    final per100g = _num(nutrients['${offKey}_100g']);
    if (per100g != null) {
      return serving != null ? per100g * serving / 100 : per100g;
    }
    return _num(nutrients[offKey]) ?? 0;
  }

  final draft = FoodDraft(
    barcode: barcode,
    foodName: _string(product['product_name']),
    brandName: _string(product['brands']),
    servingSize: servingSize,
    calories: amount('calories', 'energy-kcal'),
    totalFat: amount('totalFat', 'fat'),
    saturatedFat: amount('saturatedFat', 'saturated-fat'),
    transFat: amount('transFat', 'trans-fat'),
    cholesterol: amount('cholesterol', 'cholesterol'),
    sodium: amount('sodium', 'sodium'),
    totalCarbohydrate: amount('totalCarbohydrate', 'carbohydrates'),
    dietaryFiber: amount('dietaryFiber', 'fiber'),
    sugars: amount('sugars', 'sugars'),
    addedSugars: amount('addedSugars', 'added-sugars'),
    protein: amount('protein', 'proteins'),
    vitaminD: amount('vitaminD', 'vitamin-d'),
    calcium: amount('calcium', 'calcium'),
    iron: amount('iron', 'iron'),
    potassium: amount('potassium', 'potassium'),
    vitaminA: amount('vitaminA', 'vitamin-a'),
    vitaminC: amount('vitaminC', 'vitamin-c'),
    vitaminB6: amount('vitaminB6', 'vitamin-b6'),
    folate: amount('folate', 'folate'),
    thiamin: amount('thiamin', 'thiamin'),
    magnesium: amount('magnesium', 'magnesium'),
    zinc: amount('zinc', 'zinc'),
    phosphorus: amount('phosphorus', 'phosphorus'),
    riboflavin: amount('riboflavin', 'riboflavin'),
    niacin: amount('niacin', 'niacin'),
    pantothenicAcid: amount('pantothenicAcid', 'pantothenic-acid'),
    vitaminE: amount('vitaminE', 'vitamin-e'),
  );

  return draft;
}

/// Parses an OFF serving size string like "15 g" or "240 ml" into a double
/// (grams/millilitres). Returns null when absent or unparseable.
double? _parseServing(String raw) {
  if (raw.trim().isEmpty) return null;
  final match = RegExp(r'([\d]+(?:[.,]\d+)?)').firstMatch(raw);
  if (match == null) return null;
  return double.parse(match.group(1)!.replaceAll(',', '.'));
}

double? _num(Object? value) => value is num ? value.toDouble() : null;

String _string(Object? value) => value is String ? value : '';
