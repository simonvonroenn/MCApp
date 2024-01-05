import 'package:flutter/animation.dart';

/// Represents an increment animation,
/// i.e. the number representing the cookies earned that pops up after clicking the cookie
class IncrementAnimation {
  final String value;
  final AnimationController controller;
  final Animation<double> fadeOutAnimation;
  final Offset position;

  /// Creates an increment animation with
  /// a [value] i.e. the number of cookies earned,
  /// a [controller] i.e. an [AnimationController] that controls the animation,
  /// a [fadeOutAnimation] to fade out the number from the screen
  /// and a [position] where the number should appear.
  IncrementAnimation({
    required this.value,
    required this.controller,
    required this.fadeOutAnimation,
    required this.position
  });
}