import 'dart:ui';

import 'package:flame/components.dart';
import 'package:keyhole_manager/config/game_constants.dart';

class StairsComponent extends PositionComponent {
  static final _bgPaint = Paint()..color = const Color(0xFF2A2A3A);
  static final _stepPaint = Paint()
    ..color = const Color(0xFF3A3A4A)
    ..strokeWidth = 1;

  final int floorCount;

  StairsComponent({required this.floorCount})
      : super(
          position: Vector2.zero(),
          size: Vector2(
            GameConstants.stairsWidth,
            floorCount * GameConstants.floorHeight,
          ),
        );

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _bgPaint);

    // Draw step lines within each floor section
    const stepsPerFloor = 6;
    const stepHeight = GameConstants.floorHeight / stepsPerFloor;
    for (var f = 0; f < floorCount; f++) {
      final floorTop = f * GameConstants.floorHeight;
      for (var s = 1; s < stepsPerFloor; s++) {
        final y = floorTop + s * stepHeight;
        canvas.drawLine(
          Offset(4, y),
          Offset(size.x - 4, y),
          _stepPaint,
        );
      }
    }
  }
}
