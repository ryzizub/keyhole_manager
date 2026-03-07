import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:keyhole_manager/components/building/building.dart';
import 'package:keyhole_manager/components/peek_view/peek_view.dart';
import 'package:keyhole_manager/components/player/manager.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/models/room.dart';
import 'package:keyhole_manager/models/tenant.dart';

class KeyholeManagerGame extends FlameGame with HasKeyboardHandlerComponents {
  late final Building building;
  late Manager manager;

  List<Room> rooms = [];
  int floorCount = GameConstants.startingFloors;
  PeekView? peekOverlay;
  bool get isPeeking => peekOverlay != null;

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

    _updateCamera();
  }

  @override
  void update(double dt) {
    super.update(dt);
    _updateCamera();
  }

  void _updateCamera() {
    final buildingHeight = floorCount * GameConstants.floorHeight;
    final buildingBottom = building.position.y;
    final buildingTop = buildingBottom - buildingHeight;

    final managerWorldY = buildingBottom -
        buildingHeight +
        manager.position.y +
        manager.size.y / 2;

    const halfView = GameConstants.viewportHeight / 2;
    final cameraY = managerWorldY.clamp(
      buildingTop + halfView,
      buildingBottom - halfView,
    );

    camera.viewfinder.position = Vector2(0, cameraY);
  }

  void startPeek(Room room) {
    room.randomizeViolations();
    final overlay = PeekView(room: room);
    peekOverlay = overlay;
    camera.viewport.add(overlay);
  }

  void stopPeek() {
    peekOverlay?.removeFromParent();
    peekOverlay = null;
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
