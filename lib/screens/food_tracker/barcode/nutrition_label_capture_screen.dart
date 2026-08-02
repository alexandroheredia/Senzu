import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:senzu_app/models/food_draft.dart';
import 'package:senzu_app/services/nutrition_facts_extractor.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/random_id.dart';

/// Capture a photo of a nutrition facts panel and have the AI read it.
///
/// Pops with a fully populated [FoodDraft] on success so the caller can
/// pre-fill the `AddFood` form. The user always gets to review/edit before
/// saving.
class NutritionLabelCaptureScreen extends ConsumerStatefulWidget {
  const NutritionLabelCaptureScreen({super.key});

  @override
  ConsumerState<NutritionLabelCaptureScreen> createState() =>
      _NutritionLabelCaptureScreenState();
}

class _NutritionLabelCaptureScreenState
    extends ConsumerState<NutritionLabelCaptureScreen> {
  bool _working = false;

  Future<void> _pick(ImageSource source) async {
    if (_working) return;
    final messenger = ScaffoldMessenger.of(context);

    final XFile? file;
    try {
      file = await ImagePicker().pickImage(
        source: source,
        maxWidth: 1600,
        maxHeight: 1600,
        imageQuality: 90,
      );
    } on Object catch (e, stack) {
      if (!mounted) return;
      debugPrint('Image pick failed:\n$e\n$stack');
      messenger.showSnackBar(
        SnackBar(content: Text('Could not open the camera: $e')),
      );
      return;
    }
    if (file == null) return;

    final bytes = await file.readAsBytes();
    await _extract(
      NutritionFactsImage(
        bytes: bytes,
        mimeType: _mimeTypeOf(file),
      ),
    );
  }

  Future<void> _extract(NutritionFactsImage image) async {
    setState(() => _working = true);
    final messenger = ScaffoldMessenger.of(context);

    try {
      final panel = await ref
          .read(nutritionFactsExtractorProvider)
          .extract(image);
      if (!mounted) return;

      if (panel == null || panel.productName == null) {
        setState(() => _working = false);
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'No nutrition facts panel detected. '
              'Try again with better lighting and framing.',
            ),
          ),
        );
        return;
      }

      var draft = panel.toFoodDraft();
      if (draft.foodId.isEmpty) draft = draft.withFoodId(generateRandomId());
      Navigator.of(context).pop(draft);
    } on Object catch (e, stack) {
      if (!mounted) return;
      setState(() => _working = false);
      debugPrint('Label extraction failed:\n$e\n$stack');
      messenger.showSnackBar(
        SnackBar(content: Text('Label read failed: $e')),
      );
    }
  }

  String _mimeTypeOf(XFile file) {
    final mime = file.mimeType;
    if (mime != null && mime.isNotEmpty) return mime;
    final ext = file.name.split('.').last.toLowerCase();
    return switch (ext) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan nutrition label')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.document_scanner_outlined,
                size: 72,
                color: colors.textSecondary,
              ),
              const SizedBox(height: 16),
              Text(
                'Take a clear photo of the nutrition facts panel',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'AI reads the panel and fills the form for you. '
                'You can review and edit everything before saving.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              if (_working)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 12),
                      Text('Reading the label…'),
                    ],
                  ),
                )
              else ...[
                FilledButton.icon(
                  onPressed: () => _pick(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: const Text('Take photo'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _pick(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Choose from gallery'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
