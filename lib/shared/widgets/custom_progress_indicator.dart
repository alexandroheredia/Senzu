import 'dart:async';

import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatefulWidget {
  const CustomProgressIndicator({super.key});

  @override
  State<CustomProgressIndicator> createState() => _CustomProgressIndicatorState();
}

class _CustomProgressIndicatorState extends State<CustomProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (3 * 0.5 * 2222).toInt()),
    );
    unawaited(_animationController.repeat());
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: TweenSequence(
        <TweenSequenceItem<Color>>[
          TweenSequenceItem<Color>(
            tween: ConstantTween<Color>(const Color.fromARGB(255, 0, 60, 192)),
            weight: 33.33,
          ),
          TweenSequenceItem<Color>(
            tween: ConstantTween<Color>(const Color.fromARGB(255, 0, 140, 238)),
            weight: 33.33,
          ),
          TweenSequenceItem<Color>(
            tween: ConstantTween<Color>(const Color.fromARGB(255,11, 209, 252)),
            weight: 33.33,
          ),
        ],
      ).animate(_animationController),
    );
  }
}
