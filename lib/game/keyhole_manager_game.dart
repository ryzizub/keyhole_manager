import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:keyhole_manager/components/building.dart';
import 'package:keyhole_manager/components/manager.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/models/room.dart';
import 'package:keyhole_manager/models/tenant.dart';

class KeyholeManagerGame extends FlameGame with HasKeyboardHandlerComponents {
  late final Building building;
  late Manager manager;

  List<Room> rooms = [];
  int floorCount = GameConstants.startingFloors;

  @override
  Color backgroundColor() => const Color(0xFF0D0D1A);

  @override
  Future<void> onLoad() async {
    camera = CameraComponent.withFixedResolution(
      width: GameConstants.viewportWidth,
      height: GameConstants.viewportHeight,
    );

    _buildRooms();

    building = Building();
    await world.add(building);

    await building.loaded;
    manager = building.manager;
  }

  void _buildRooms() {
    rooms.clear();
    for (var f = 0; f < floorCount; f++) {
      for (var r = 0; r < GameConstants.roomsPerFloor; r++) {
        rooms.add(
          Room(
            floorIndex: f,
            roomIndex: r,
            tenant: Tenant(
              name: 'Tenant ${f * GameConstants.roomsPerFloor + r + 1}',
            ),
          ),
        );
      }
    }
  }
}
