import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;

class FeedbackText extends TextComponent {
  double _timer = 0;
  static const double _duration = 1.0;

  FeedbackText({
    required super.text,
    required Color color,
    required super.position,
  }) : super(
          textRenderer: TextPaint(
            style: TextStyle(fontSize: 10, color: color),
          ),
          anchor: Anchor.center,
          priority: 110,
        );

  factory FeedbackText.correct(int amount, {required Vector2 position}) {
    return FeedbackText(
      text: '+\$$amount',
      color: const Color(0xFF44FF44),
      position: position,
    );
  }

  factory FeedbackText.wrong(int amount, {required Vector2 position}) {
    return FeedbackText(
      text: '-\$$amount',
      color: const Color(0xFFFF4444),
      position: position,
    );
  }

  @override
  void update(double dt) {
    _timer += dt;
    if (_timer >= _duration) {
      removeFromParent();
    }
  }
}
