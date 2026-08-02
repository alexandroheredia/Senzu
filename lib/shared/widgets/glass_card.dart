import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:senzu_app/shared/design/app_colors.dart';

/// Elevated glass surface per the design system's "Glass recipe":
/// a blurred, clipped, faintly-filled surface with a 1px border and an
/// optional top-edge highlight that sells the "catching light" look.
///
/// Glass is for elevated surfaces only — cards, sheets, nav. Never blur the
/// full screen background.
class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;
  final VoidCallback? onTap;
  final Color? borderColor;
  final bool highlight;

  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 28,
    this.onTap,
    this.borderColor,
    this.highlight = true,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    Widget surface = ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: colors.glassFill,
                borderRadius: BorderRadius.circular(radius),
                border: Border.all(color: borderColor ?? colors.glassBorder),
              ),
              child: onTap == null
                  ? Padding(padding: padding, child: child)
                  : Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: onTap,
                        borderRadius: BorderRadius.circular(radius),
                        child: Padding(padding: padding, child: child),
                      ),
                    ),
            ),
            if (highlight)
              Positioned(
                top: 0,
                left: 12,
                right: 12,
                child: IgnorePointer(
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          colors.glassHighlight,
                          Colors.transparent,
                          colors.glassHighlight,
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (onTap != null) {
      surface = GestureDetector(onTap: onTap, child: surface);
    }
    return surface;
  }
}
