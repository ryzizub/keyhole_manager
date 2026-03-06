import 'dart:ui';

import 'package:flame/components.dart';
import 'package:keyhole_manager/components/door.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/models/room.dart';

class FloorComponent extends PositionComponent {
  static final _wallPaint = Paint()..color = const Color(0xFF4A4A5A);

  final int floorIndex;
  final List<Room> rooms;

  FloorComponent({
    required this.floorIndex,
    required this.rooms,
    super.position,
  }) : super(
          size: Vector2(
            GameConstants.roomsPerFloor * GameConstants.roomWidth,
            GameConstants.floorHeight,
          ),
        );

  @override
  Future<void> onLoad() async {
    for (var i = 0; i < GameConstants.roomsPerFloor; i++) {
      final x = i * GameConstants.roomWidth +
          GameConstants.roomWidth / 2 -
          GameConstants.doorWidth / 2;
      final door = Door(
        roomIndex: i,
        position: Vector2(
          x,
          GameConstants.floorHeight - GameConstants.doorHeight,
        ),
      );
      if (i < rooms.length) {
        door.room = rooms[i];
      }
      await add(door);
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _wallPaint);
  }
}
