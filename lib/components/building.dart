import 'package:flame/components.dart';
import 'package:keyhole_manager/components/door.dart';
import 'package:keyhole_manager/components/floor_component.dart';
import 'package:keyhole_manager/components/manager.dart';
import 'package:keyhole_manager/components/stairs_component.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/game/keyhole_manager_game.dart';

class Building extends PositionComponent
    with HasGameReference<KeyholeManagerGame> {
  Building()
      : super(
          anchor: Anchor.bottomCenter,
          position: Vector2(0, GameConstants.viewportHeight / 2),
        );

  late Manager manager;

  @override
  Future<void> onLoad() async {
    await rebuild();
  }

  Future<void> rebuild() async {
    removeAll(children);

    final rooms = game.rooms;
    final floorCount = game.floorCount;

    size = Vector2(
      GameConstants.stairsWidth +
          GameConstants.roomsPerFloor * GameConstants.roomWidth,
      floorCount * GameConstants.floorHeight,
    );

    await add(StairsComponent(floorCount: floorCount));

    for (var i = 0; i < floorCount; i++) {
      final floorRooms = rooms.where((r) => r.floorIndex == i).toList();
      await add(
        FloorComponent(
          floorIndex: i,
          rooms: floorRooms,
          position: Vector2(
            GameConstants.stairsWidth,
            (floorCount - 1 - i) * GameConstants.floorHeight,
          ),
        ),
      );
    }

    manager = Manager(
      floorCount: floorCount,
      position: Vector2(
        GameConstants.stairsWidth + GameConstants.roomWidth / 2,
        (floorCount - 1) * GameConstants.floorHeight +
            GameConstants.floorHeight -
            GameConstants.managerHeight,
      ),
    );
    await add(manager);
  }

  Door? findNearestDoor() {
    final floor = children
        .whereType<FloorComponent>()
        .where(
          (f) => f.floorIndex == manager.currentFloor,
        )
        .firstOrNull;
    if (floor == null) {
      return null;
    }

    final managerCenterX = manager.position.x + manager.size.x / 2;

    for (final door in floor.children.whereType<Door>()) {
      final doorCenterX = floor.position.x + door.position.x + door.size.x / 2;
      if ((managerCenterX - doorCenterX).abs() <=
          GameConstants.peekProximityThreshold) {
        return door;
      }
    }
    return null;
  }
}
