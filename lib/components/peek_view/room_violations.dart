import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:keyhole_manager/models/room.dart';

class RoomViolations extends PositionComponent {
  final Room room;

  static const double _boxSize = 20;
  static const double _gap = 6;

  static final _boxPaint = Paint()..color = const Color(0xFF00AA00);
  static final _textPaint = TextPaint(
    style: const TextStyle(fontSize: 6, color: Color(0xFFFFFFFF)),
  );

  RoomViolations({
    required this.room,
    required super.position,
    required super.size,
  });

  @override
  void render(Canvas canvas) {
    final active = room.activeViolations;
    final cols = (size.x / (_boxSize + _gap)).floor();

    for (var i = 0; i < active.length; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final bx = col * (_boxSize + _gap);
      final by = row * (_boxSize + _gap);

      canvas.drawRect(
        Rect.fromLTWH(bx, by, _boxSize, _boxSize),
        _boxPaint,
      );

      _textPaint.render(
        canvas,
        active[i].label,
        Vector2(bx + 1, by + 1),
      );
    }
  }
}
