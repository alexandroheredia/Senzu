import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:senzu_app/models/nutrition_facts.dart';

/// A label-extraction failure with the real reason attached, so a single-user
/// dev build can show exactly what went wrong instead of a generic message.
class NutritionExtractionException implements Exception {
  const NutritionExtractionException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// An image of a nutrition facts panel, ready to send to the vision model.
class NutritionFactsImage {
  const NutritionFactsImage({required this.bytes, required this.mimeType});

  /// Raw image bytes (JPEG, PNG or WebP).
  final Uint8List bytes;

  /// MIME type of [bytes], e.g. `image/jpeg`.
  final String mimeType;
}

/// Reads a nutrition facts panel from a photo and returns it structured.
///
/// Implementations parse the image into a `NutritionFactsPanel`, which the
/// rest of the app converts into a `FoodDraft` for form autofill. The
/// interface is a single method on purpose so fakes are trivial in tests.
class NutritionFactsExtractor {
  /// Extracts structured nutrition data from a picture of the label.
  /// Returns null when the image does not contain a readable panel.
  Future<NutritionFactsPanel?> extract(NutritionFactsImage image) {
    throw UnimplementedError('Use GeminiNutritionFactsExtractor');
  }
}

/// Gemini (vision) implementation.
///
/// The model is instructed to return strict JSON that maps 1:1 to
/// [NutritionFactsPanel]. Amounts are reported as printed on the label
/// (with units, or `%` for daily values); conversion to absolute amounts
/// happens client-side in [NutritionFactsPanel.toFoodDraft].
class GeminiNutritionFactsExtractor implements NutritionFactsExtractor {
  GeminiNutritionFactsExtractor({
    required this.apiKey,
    this.modelName = defaultModel,
  });

  /// The vision model used by default. `gemini-2.0-flash` is retired for new
  /// keys (returns 429 quota-limit-0 / 404); preview models have quota.
  static const String defaultModel = 'gemini-3-flash-preview';

  final String apiKey;
  final String modelName;

  static const String _schema = '''
{
  "productName": string | null,
  "brandName": string | null,
  "servingSize": number | null,
  "servingUnit": "g" | "ml" | "oz" | null,
  "nutrients": {
    "calories": { "amount": number, "unit": "kcal" },
    "totalFat": { "amount": number, "unit": "g" },
    "saturatedFat": { "amount": number, "unit": "g" },
    "transFat": { "amount": number, "unit": "g" },
    "cholesterol": { "amount": number, "unit": "mg" },
    "sodium": { "amount": number, "unit": "mg" },
    "totalCarbohydrate": { "amount": number, "unit": "g" },
    "dietaryFiber": { "amount": number, "unit": "g" },
    "sugars": { "amount": number, "unit": "g" },
    "addedSugars": { "amount": number, "unit": "g" },
    "protein": { "amount": number, "unit": "g" },
    "vitaminD": { "amount": number, "unit": "mcg" | "%" },
    "calcium": { "amount": number, "unit": "mg" | "%" },
    "iron": { "amount": number, "unit": "mg" | "%" },
    "potassium": { "amount": number, "unit": "mg" | "%" },
    "vitaminA": { "amount": number, "unit": "mcg" | "%" },
    "vitaminC": { "amount": number, "unit": "mg" | "%" },
    "vitaminB6": { "amount": number, "unit": "mg" | "%" },
    "folate": { "amount": number, "unit": "mcg" | "%" },
    "thiamin": { "amount": number, "unit": "mg" | "%" },
    "magnesium": { "amount": number, "unit": "mg" | "%" },
    "zinc": { "amount": number, "unit": "mg" | "%" },
    "phosphorus": { "amount": number, "unit": "mg" | "%" },
    "riboflavin": { "amount": number, "unit": "mg" | "%" },
    "niacin": { "amount": number, "unit": "mg" | "%" },
    "pantothenicAcid": { "amount": number, "unit": "mg" | "%" },
    "vitaminE": { "amount": number, "unit": "mg" | "%" }
  }
}
''';

  @override
  Future<NutritionFactsPanel?> extract(NutritionFactsImage image) async {
    final model = GenerativeModel(model: modelName, apiKey: apiKey);

    final GenerateContentResponse response;
    try {
      response = await model.generateContent([
        Content.multi([
          TextPart(_prompt),
          DataPart(image.mimeType, image.bytes),
        ]),
      ]);
    } on Object catch (e) {
      // The Gemini SDK throws here for invalid/expired keys, quota limits,
      // unsupported mime types, etc. — surface the real message.
      throw NutritionExtractionException('Gemini API call failed: $e');
    }

    final text = response.text;
    if (text == null || text.trim().isEmpty) {
      throw const NutritionExtractionException(
        'Gemini returned an empty response.',
      );
    }

    // The model may wrap the JSON in a fenced code block or add prose
    // before/after it; extract the first {...} block.
    final jsonText = _extractJsonBlock(text);

    final Object? decoded;
    try {
      decoded = jsonDecode(jsonText);
    } on FormatException catch (e) {
      throw NutritionExtractionException(
        'AI output was not valid JSON: ${e.message}\n'
        'Raw response: ${_preview(text)}',
      );
    }

    if (decoded is! Map<String, dynamic>) {
      throw NutritionExtractionException(
        'AI response was not a JSON object: ${_preview(text)}',
      );
    }

    try {
      return NutritionFactsPanel.fromJson(decoded);
    } on Object catch (e) {
      throw NutritionExtractionException(
        'Could not parse AI response into a nutrition panel: $e\n'
        'Raw response: ${_preview(text)}',
      );
    }
  }

  /// Returns the first balanced JSON object found in [text], or the whole
  /// trimmed text when none is found.
  static String _extractJsonBlock(String text) {
    final start = text.indexOf('{');
    final end = text.lastIndexOf('}');
    if (start >= 0 && end > start) {
      return text.substring(start, end + 1);
    }
    return text.trim();
  }

  /// First 300 chars of a model response, for debugging.
  static String _preview(String text) {
    final trimmed = text.trim();
    return trimmed.length <= 300 ? trimmed : '${trimmed.substring(0, 300)}…';
  }

  static const String _prompt =
      '''
You are an expert at reading US nutrition facts panels. Analyze the nutrition
facts image and return ONLY strict JSON matching this schema (no markdown,
no commentary):

$_schema

Rules:
- Report every value exactly as printed for ONE serving. If the panel is
  per-100g/per-100ml, set servingSize to 100 and servingUnit accordingly.
- For vitamins/minerals printed as a percentage of Daily Value, report the
  percentage with unit "%". For amounts printed with units (mg, mcg, g),
  report the amount with that unit.
- calories uses unit "kcal". Set omitted nutrients to {"amount": 0, "unit": "g"}.
- If the panel is unreadable or not a nutrition facts panel, return
  {"productName": null, "nutrients": {}}.
''';
}

/// The AI nutrition-facts extractor.
///
/// Requires a Google AI Studio API key in `.env` (`GEMINI_API_KEY=...`). The
/// model can be overridden with `GEMINI_MODEL` (defaults to
/// [GeminiNutritionFactsExtractor.defaultModel]). Override this provider in
/// tests with a fake extractor.
final nutritionFactsExtractorProvider = Provider<NutritionFactsExtractor>((
  ref,
) {
  final apiKey = dotenv.maybeGet('GEMINI_API_KEY') ?? '';
  if (apiKey.isEmpty) {
    throw StateError(
      'GEMINI_API_KEY is not set. Add it to your .env file '
      '(see .env.example) or override nutritionFactsExtractorProvider '
      'in tests.',
    );
  }
  final model =
      dotenv.maybeGet('GEMINI_MODEL') ??
      GeminiNutritionFactsExtractor.defaultModel;
  return GeminiNutritionFactsExtractor(apiKey: apiKey, modelName: model);
});
