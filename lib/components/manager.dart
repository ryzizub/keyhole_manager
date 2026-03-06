import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:keyhole_manager/config/game_constants.dart';

class Manager extends PositionComponent with KeyboardHandler {
  static final _paint = Paint()..color = const Color(0xFF4488FF);

  final Set<LogicalKeyboardKey> _keysPressed = {};
  final int floorCount;
  int currentFloor = 0;
  int? _targetFloor;

  Manager({required this.floorCount, super.position})
      : super(
          size: Vector2(
            GameConstants.managerWidth,
            GameConstants.managerHeight,
          ),
        );

  bool get _inStairwell => position.x < GameConstants.stairsWidth;
  bool get _isClimbing => _targetFloor != null;

  double _floorY(int floor) =>
      (floorCount - 1 - floor + 1) * GameConstants.floorHeight -
      GameConstants.managerHeight;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent && _inStairwell && !_isClimbing) {
      final dir = _verticalDir(event.logicalKey);
      final next = currentFloor + dir;
      if (dir != 0 && next >= 0 && next < floorCount) {
        _targetFloor = next;
      }
    }
    _keysPressed
      ..clear()
      ..addAll(keysPressed);
    return true;
  }

  int _verticalDir(LogicalKeyboardKey key) {
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      return 1;
    }
    if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.keyS) {
      return -1;
    }
    return 0;
  }

  @override
  void update(double dt) {
    if (_isClimbing) {
      _animateClimb(dt);
    } else {
      _moveHorizontally(dt);
    }
  }

  void _moveHorizontally(double dt) {
    var dx = 0.0;
    if (_keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
        _keysPressed.contains(LogicalKeyboardKey.keyA)) {
      dx -= 1;
    }
    if (_keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
        _keysPressed.contains(LogicalKeyboardKey.keyD)) {
      dx += 1;
    }

    const buildingWidth = GameConstants.stairsWidth +
        GameConstants.roomsPerFloor * GameConstants.roomWidth;
    position.x = (position.x + dx * GameConstants.managerSpeed * dt)
        .clamp(0, buildingWidth - size.x);
  }

  void _animateClimb(double dt) {
    final targetY = _floorY(_targetFloor!);
    final diff = targetY - position.y;
    final step = GameConstants.managerClimbSpeed * dt;

    if (diff.abs() <= step) {
      position.y = targetY;
      currentFloor = _targetFloor!;
      _targetFloor = null;
    } else {
      position.y += diff.sign * step;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _paint);
  }
}
