import 'package:flutter/material.dart';

/// Disposes the given [controllers] when this widget is removed from the tree.
///
/// This bridges the gap between a controller created by a caller (e.g. for a
/// modal bottom sheet) and the route's exit animation: after `Navigator.pop`
/// the route's future resolves immediately, but the sheet stays in the tree —
/// and its text fields keep rebuilding (keyboard insets change, MediaQuery
/// fires, etc.) — until the exit animation finishes. Disposing from the caller
/// right after `await showModalBottomSheet(...)` therefore hits live fields
/// with a dead controller.
///
/// Wrap the sheet content with this widget and drop the manual `dispose()`
/// calls: the controllers are freed exactly when the sheet is unmounted.
class DisposeOnUnmount extends StatefulWidget {
  const DisposeOnUnmount({
    super.key,
    required this.controllers,
    required this.child,
  });

  final List<TextEditingController> controllers;
  final Widget child;

  @override
  State<DisposeOnUnmount> createState() => _DisposeOnUnmountState();
}

class _DisposeOnUnmountState extends State<DisposeOnUnmount> {
  @override
  void dispose() {
    for (final controller in widget.controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
