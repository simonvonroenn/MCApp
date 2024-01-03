import 'package:flutter/animation.dart';

class IncrementAnimation {
  final String value;
  final AnimationController controller;
  final Animation<double> fadeOutAnimation;
  final Offset position;

  IncrementAnimation({
    required this.value,
    required this.controller,
    required this.fadeOutAnimation,
    required this.position
  });
}