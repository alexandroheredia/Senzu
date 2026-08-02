import 'package:flutter/material.dart';
import 'package:senzu_app/shared/design/app_colors.dart';

/// A compact glass list row: filled glass surface, 20dp radius, ripple, and
/// an optional long-press. Used for meal rows, shelf items, and stats lists.
class GlassRow extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry padding;

  const GlassRow({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.transparent,
        child: Ink(
          decoration: colors.glassDecoration(radius: 20),
          child: InkWell(
            onTap: onTap,
            onLongPress: onLongPress,
            borderRadius: BorderRadius.circular(20),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
