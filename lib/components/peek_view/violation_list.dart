import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:keyhole_manager/models/violation.dart';

class ViolationList extends PositionComponent {
  int _cursorIndex = 0;

  static const double _boxHeight = 14;
  static const double _boxGap = 4;
  static const double _textSize = 8;
  static const double _textPadding = 4;

  static final _selectedBgPaint = Paint()..color = const Color(0xFFFFFFFF);
  static final _unselectedBgPaint = Paint()..color = const Color(0xFF333333);
  static final _cursorPaint = Paint()..color = const Color(0xFFFFFF00);

  static final _selectedTextPaint = TextPaint(
    style: const TextStyle(fontSize: _textSize, color: Color(0xFF000000)),
  );
  static final _unselectedTextPaint = TextPaint(
    style: const TextStyle(fontSize: _textSize, color: Color(0xFFCCCCCC)),
  );

  ViolationList({
    required super.position,
    required super.size,
  });

  void moveCursor(int dir) {
    final count = Violation.values.length;
    _cursorIndex = ((_cursorIndex + dir) % count + count) % count;
  }

  Violation get selectedViolation => Violation.values[_cursorIndex];

  @override
  void render(Canvas canvas) {
    const violations = Violation.values;
    for (var i = 0; i < violations.length; i++) {
      final y = i * (_boxHeight + _boxGap);
      final isSelected = i == _cursorIndex;

      canvas.drawRect(
        Rect.fromLTWH(0, y, size.x, _boxHeight),
        isSelected ? _selectedBgPaint : _unselectedBgPaint,
      );

      if (isSelected) {
        canvas.drawRect(
          Rect.fromLTWH(0, y + 2, 3, _boxHeight - 4),
          _cursorPaint,
        );
      }

      final textPaint = isSelected ? _selectedTextPaint : _unselectedTextPaint;
      textPaint.render(
        canvas,
        violations[i].label,
        Vector2(_textPadding, y + (_boxHeight - _textSize) / 2),
      );
    }
  }
}
