import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:keyhole_manager/config/game_constants.dart';

class Manager extends PositionComponent with KeyboardHandler {
  static final _paint = Paint()..color = const Color(0xFF4488FF);

  final Set<LogicalKeyboardKey> _keysPressed = {};

  Manager({super.position})
      : super(
          size: Vector2(
            GameConstants.managerWidth,
            GameConstants.managerHeight,
          ),
        );

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    _keysPressed
      ..clear()
      ..addAll(keysPressed);
    return true;
  }

  @override
  void update(double dt) {
    var dx = 0.0;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        _keysPressed.contains(LogicalKeyboardKey.keyA)) {
      dx -= 1;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        _keysPressed.contains(LogicalKeyboardKey.keyD)) {
      dx += 1;
    }
    position.x += dx * GameConstants.managerSpeed * dt;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}
