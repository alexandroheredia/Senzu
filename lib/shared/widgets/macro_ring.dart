import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:senzu_app/shared/design/app_colors.dart';

/// A small macro ring (72dp, 8dp stroke) used inside glass cards.
///
/// The ring is animated from 0 → [progress] over ~900ms `easeOutCubic`, and
/// fills instantly when reduced motion is enabled.
class MacroRing extends StatelessWidget {
  /// The macro's token color (protein / carbs / fat).
  final Color color;

  /// Ring fill, 0..1.
  final double progress;

  /// Text shown in the ring center (usually a percent).
  final String percentLabel;

  /// Macro name shown under the ring.
  final String label;

  /// Gram count shown under the label.
  final String amount;

  const MacroRing({
    super.key,
    required this.color,
    required this.progress,
    required this.percentLabel,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox.square(
          dimension: 72,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress.clamp(0.0, 1.0)),
            duration: reduceMotion
                ? Duration.zero
                : const Duration(milliseconds: 900),
            curve: reduceMotion ? Curves.linear : Curves.easeOutCubic,
            builder: (context, value, _) {
              return CustomPaint(
                painter: _MacroRingPainter(
                  progress: value,
                  color: color,
                  trackColor: colors.trackStroke,
                ),
                child: Center(
                  child: Text(
                    percentLabel,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 2),
        Text(
          amount,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}

class _MacroRingPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color trackColor;

  _MacroRingPainter({
    required this.progress,
    required this.color,
    required this.trackColor,
  });

  static const double _stroke = 8;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - _stroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;

    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..color = trackColor;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    if (progress <= 0) return;

    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..color = color;
    canvas.drawArc(rect, startAngle, 2 * math.pi * progress, false, arc);
  }

  @override
  bool shouldRepaint(_MacroRingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor;
}
