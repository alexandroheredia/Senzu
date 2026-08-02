import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:senzu_app/shared/design/app_colors.dart';

/// The app's signature glowing calorie ring.
///
/// Fills from 0 to [HeroRing.progress] over ~900ms (`easeOutCubic`) on load
/// or value change, and runs a one-time 100% → 115% → 100% glow pulse when
/// the daily target is hit. Both are skipped when reduced motion is enabled.
class HeroRing extends StatefulWidget {
  /// Ring fill, 0..1.
  final double progress;

  /// Kcal left to the goal (shown in the center).
  final int remaining;

  /// Kcal consumed today.
  final int intake;

  /// Daily calorie goal (0 when unknown).
  final int goal;

  const HeroRing({
    super.key,
    required this.progress,
    required this.remaining,
    required this.intake,
    required this.goal,
  });

  @override
  State<HeroRing> createState() => _HeroRingState();
}

class _HeroRingState extends State<HeroRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  bool _goalMetWas = false;

  @override
  void didUpdateWidget(HeroRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    final goalMet = widget.goal > 0 && widget.intake >= widget.goal;
    if (goalMet &&
        !_goalMetWas &&
        !MediaQuery.of(context).disableAnimations) {
      unawaited(_pulse.forward(from: 0));
    }
    _goalMetWas = goalMet;
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    final pulseScale = reduceMotion
        ? 1.0
        : 1 + 0.15 * math.sin(math.pi * _pulse.value);

    final fillDuration =
        reduceMotion ? Duration.zero : const Duration(milliseconds: 900);
    final fillCurve = reduceMotion ? Curves.linear : Curves.easeOutCubic;

    return AnimatedBuilder(
      animation: _pulse,
      builder: (context, child) {
        return Transform.scale(scale: pulseScale, child: child);
      },
      child: SizedBox.square(
        dimension: 240,
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: widget.progress.clamp(0.0, 1.0)),
          duration: fillDuration,
          curve: fillCurve,
          builder: (context, value, child) {
            return CustomPaint(
              painter: _RingPainter(progress: value, colors: colors),
              child: child,
            );
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${widget.remaining}',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.goal > 0 ? 'kcal left' : 'kcal consumed',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final AppColors colors;

  _RingPainter({required this.progress, required this.colors});

  static const double _stroke = 14;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.shortestSide - _stroke) / 2 - 6;
    final rect = Rect.fromCircle(center: center, radius: radius);
    const startAngle = -math.pi / 2;
    final sweep = 2 * math.pi * progress;

    // Track: white at 8% opacity.
    final track = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..color = colors.trackStroke;
    canvas.drawArc(rect, 0, 2 * math.pi, false, track);

    if (progress <= 0) return;

    // Soft glow behind the arc: energy.start at ~30% opacity, blur ~40.
    final glow = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..color = colors.energyStart.withValues(alpha: 0.30)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40);
    canvas.drawArc(rect, startAngle, sweep, false, glow);

    // The arc itself: energy gradient sweep, round cap.
    final arc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _stroke
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        startAngle: startAngle,
        endAngle: -startAngle,
        colors: [colors.energyStart, colors.energyEnd],
      ).createShader(rect);
    canvas.drawArc(rect, startAngle, sweep, false, arc);
  }

  @override
  bool shouldRepaint(_RingPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.colors != colors;
}
