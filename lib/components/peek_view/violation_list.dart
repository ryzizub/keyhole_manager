import 'dart:ui';

import 'package:flame/components.dart';
import 'package:keyhole_manager/models/violation.dart';

class ViolationList extends PositionComponent {
  int _cursorIndex = 0;

  static const double _boxHeight = 14;
  static const double _boxGap = 4;
  static const double _textSize = 8;
  static const double _textPadding = 4;

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

      final bgColor =
          isSelected ? const Color(0xFFFFFFFF) : const Color(0xFF333333);

      canvas.drawRect(
        Rect.fromLTWH(0, y, size.x, _boxHeight),
        Paint()..color = bgColor,
      );

      if (isSelected) {
        canvas.drawRect(
          Rect.fromLTWH(-5, y + 2, 3, _boxHeight - 4),
          Paint()..color = const Color(0xFFFFFF00),
        );
      }

      final textColor =
          isSelected ? const Color(0xFF000000) : const Color(0xFFCCCCCC);

      final pb = ParagraphBuilder(ParagraphStyle(fontSize: _textSize))
        ..pushStyle(TextStyle(color: textColor))
        ..addText(violations[i].label);
      final p = pb.build()
        ..layout(ParagraphConstraints(width: size.x - _textPadding * 2));
      canvas.drawParagraph(
        p,
        Offset(_textPadding, y + (_boxHeight - _textSize) / 2),
      );
    }
  }
}
