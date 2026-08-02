import 'package:flutter/material.dart';
import 'package:senzu_app/shared/design/app_colors.dart';

/// A selectable option in [GlassSegmentedControl].
class GlassSegment<T> {
  final T value;
  final String label;

  const GlassSegment(this.value, this.label);
}

/// Glass segmented control for choosing between a small set of options
/// (e.g. time range, shelf tab, meal picker). [value] may be null when
/// nothing is selected.
class GlassSegmentedControl<T> extends StatelessWidget {
  final List<GlassSegment<T>> segments;
  final T? value;
  final ValueChanged<T> onChanged;

  const GlassSegmentedControl({
    super.key,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: colors.glassDecoration(radius: 24),
      child: Row(
        children: [
          for (var i = 0; i < segments.length; i++) ...[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: _SegmentButton<T>(
                segment: segments[i],
                selected: segments[i].value == value,
                onTap: () => onChanged(segments[i].value),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _SegmentButton<T> extends StatelessWidget {
  final GlassSegment<T> segment;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.segment,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    return AnimatedContainer(
      duration: reduceMotion
          ? Duration.zero
          : const Duration(milliseconds: 160),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected
            ? colors.textPrimary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 40,
            child: Center(
              child: Text(
                segment.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? colors.textPrimary : colors.textSecondary,
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
