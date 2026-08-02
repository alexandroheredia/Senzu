import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:senzu_app/models/food_draft.dart';
import 'package:senzu_app/services/food_lookup_service.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/random_id.dart';

/// Full-screen barcode scanner.
///
/// On a successful scan it resolves the code against the app's catalog and
/// the Open Food Facts API, then pops with a [FoodDraft]:
///
///  * catalog / API hit → draft fully populated (plus the barcode),
///  * unknown code    → draft carrying only the barcode, so the caller opens
///    the manual `AddFood` form pre-filled and lets the user type the rest.
class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() =>
      _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  /// Guards against duplicate detections triggering double navigation.
  bool _resolved = false;

  bool _torchOn = false;

  @override
  void dispose() {
    unawaited(_controller.dispose());
    super.dispose();
  }

  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_resolved) return;
    final code = _firstCode(capture);
    if (code == null) return;

    _resolved = true;
    final messenger = ScaffoldMessenger.of(context);
    setState(() {});
    await _controller.stop();

    try {
      final result = await ref
          .read(foodLookupServiceProvider)
          .lookupBarcode(code);

      if (!mounted) return;
      final draft = switch (result.source) {
        BarcodeLookupSource.catalog || BarcodeLookupSource.api => result.draft!,
        BarcodeLookupSource.notFound => FoodDraft(barcode: code),
      };
      final resolved = draft.foodId.isEmpty
          ? draft.withFoodId(generateRandomId())
          : draft;
      Navigator.of(context).pop(resolved);
    } on Object {
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Could not look up that barcode. '
            'Check your connection and try again.',
          ),
        ),
      );
      _resolved = false;
      await _controller.start();
    }
  }

  /// Returns the first non-empty barcode value in the capture, or null.
  String? _firstCode(BarcodeCapture capture) {
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value != null && value.trim().isNotEmpty) return value.trim();
    }
    return null;
  }

  void _toggleTorch() {
    setState(() => _torchOn = !_torchOn);
    unawaited(_controller.toggleTorch());
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Scan a barcode'),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
            onDetectError: (error, stack) {
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Camera error: $error')),
              );
            },
          ),
          // Overlay guides.
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 240,
                  height: 240,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 2),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: _resolved
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 3,
                          ),
                        )
                      : null,
                ),
                const SizedBox(height: 28),
                Text(
                  _resolved ? 'Looking up…' : 'Point at the barcode',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
          // Bottom actions: flash toggle + manual entry fallback.
          Positioned(
            left: 0,
            right: 0,
            bottom: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton.filledTonal(
                  onPressed: _toggleTorch,
                  icon: Icon(
                    _torchOn ? Icons.flash_on : Icons.flash_off,
                    color: colors.textPrimary,
                  ),
                  tooltip: 'Flash',
                ),
                const SizedBox(width: 16),
                TextButton.icon(
                  onPressed: () => Navigator.of(context).pop(const FoodDraft()),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  icon: const Icon(Icons.edit_outlined),
                  label: const Text('Enter manually'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
