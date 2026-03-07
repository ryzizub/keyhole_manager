import 'dart:ui';

import 'package:flame/components.dart';
import 'package:keyhole_manager/models/room.dart';

class RoomViolations extends PositionComponent {
  final Room? room;

  static const double _boxSize = 20;
  static const double _gap = 6;

  RoomViolations({
    required super.position,
    required super.size,
    this.room,
  });

  @override
  void render(Canvas canvas) {
    final active = room?.activeViolations ?? [];
    final cols = (size.x / (_boxSize + _gap)).floor();

    for (var i = 0; i < active.length; i++) {
      final col = i % cols;
      final row = i ~/ cols;
      final bx = col * (_boxSize + _gap);
      final by = row * (_boxSize + _gap);

      canvas.drawRect(
        Rect.fromLTWH(bx, by, _boxSize, _boxSize),
        Paint()..color = const Color(0xFF00AA00),
      );

      final pb = ParagraphBuilder(ParagraphStyle(fontSize: 6))
        ..pushStyle(TextStyle(color: const Color(0xFFFFFFFF)))
        ..addText(active[i].label);
      final p = pb.build()
        ..layout(const ParagraphConstraints(width: _boxSize - 2));
      canvas.drawParagraph(p, Offset(bx + 1, by + 1));
    }
  }
}
