import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:senzu_app/shared/design/app_colors.dart';

/// A destination in the [GlassNavBar].
class GlassNavItem {
  final IconData icon;
  final String label;

  const GlassNavItem(this.icon, this.label);
}

/// Floating glass pill bottom navigation, not edge-to-edge, max 4 icons.
///
/// The active item gets a small glow dot in the energy gradient.
class GlassNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelected;
  final List<GlassNavItem> items;

  const GlassNavBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              color: colors.glassFill,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: colors.glassBorder),
            ),
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(
                    child: _NavButton(
                      item: items[i],
                      selected: i == currentIndex,
                      onTap: () => onSelected(i),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final GlassNavItem item;
  final bool selected;
  final VoidCallback onTap;

  const _NavButton({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final icon = selected
        ? ShaderMask(
            shaderCallback: (rect) => colors.energyGradient.createShader(rect),
            child: Icon(item.icon, color: Colors.white, size: 24),
          )
        : Icon(item.icon, color: colors.textSecondary, size: 24);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 4),
          Text(
            item.label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: selected ? colors.textPrimary : colors.textSecondary,
              fontSize: 10,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 3),
          if (selected)
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: colors.energyGradient,
                boxShadow: [
                  BoxShadow(
                    color: colors.energyStart.withValues(alpha: 0.7),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            )
          else
            const SizedBox(height: 5),
        ],
      ),
    );
  }
}
