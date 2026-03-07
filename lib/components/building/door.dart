import 'dart:ui';

import 'package:flame/components.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/models/room.dart';

class Door extends PositionComponent {
  static final _doorPaint = Paint()..color = const Color(0xFF8B5E3C);
  static final _reportedDotPaint = Paint()..color = const Color(0xFF44FF44);

  final int roomIndex;
  Room? room;

  Door({
    required this.roomIndex,
    super.position,
  }) : super(
          size: Vector2(
            GameConstants.doorWidth,
            GameConstants.doorHeight,
          ),
        );

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _doorPaint);

    if (room != null && room!.reported) {
      canvas.drawCircle(
        Offset(size.x / 2, 4),
        2,
        _reportedDotPaint,
      );
    }
  }
}
