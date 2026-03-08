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
import 'package:keyhole_manager/models/violation.dart';
import 'package:keyhole_manager/systems/day_cycle_controller.dart';
import 'package:keyhole_manager/ui/balance_hud.dart';
import 'package:keyhole_manager/ui/day_summary_hud.dart';
import 'package:keyhole_manager/ui/day_timer_hud.dart';
import 'package:keyhole_manager/ui/feedback_text.dart';

class KeyholeManagerGame extends FlameGame with HasKeyboardHandlerComponents {
  late final Building building;
  late Manager manager;
  final Map<DayPhase, List<_BgLayer>> _bgPhases = {};

  List<Room> rooms = [];
  int floorCount = GameConstants.startingFloors;
  int balance = GameConstants.startingBalance;
  PeekView? peekOverlay;
  bool get isPeeking => peekOverlay != null;

  int currentDay = 1;
  double dayTimeRemaining = GameConstants.dayDurationSeconds;
  bool isDayActive = true;
  DaySummaryHud? _summaryHud;

  @override
  Color backgroundColor() => const Color(0xFF000000);

  // Phase boundaries (elapsed seconds): daytime 0-45, sunset 45-55, night 55-60
  static const _sunsetStart = 45.0;
  static const _nightStart = 55.0;
  static const _transitionDuration = 3.0;

  @override
  void render(Canvas canvas) {
    final elapsed = GameConstants.dayDurationSeconds - dayTimeRemaining;
    final cw = canvasSize.x;
    final ch = canvasSize.y;

    if (elapsed < _sunsetStart - _transitionDuration) {
      // Pure daytime
      _renderPhase(canvas, DayPhase.daytime, cw, ch, 255);
    } else if (elapsed < _sunsetStart + _transitionDuration) {
      // Crossfade daytime -> sunset
      final t = (elapsed - (_sunsetStart - _transitionDuration)) /
          (_transitionDuration * 2);
      final alpha = (t * 255).round().clamp(0, 255);
      _renderPhase(canvas, DayPhase.daytime, cw, ch, 255);
      _renderPhase(canvas, DayPhase.sunset, cw, ch, alpha);
    } else if (elapsed < _nightStart - _transitionDuration) {
      // Pure sunset
      _renderPhase(canvas, DayPhase.sunset, cw, ch, 255);
    } else if (elapsed < _nightStart + _transitionDuration) {
      // Crossfade sunset -> night
      final t = (elapsed - (_nightStart - _transitionDuration)) /
          (_transitionDuration * 2);
      final alpha = (t * 255).round().clamp(0, 255);
      _renderPhase(canvas, DayPhase.sunset, cw, ch, 255);
      _renderPhase(canvas, DayPhase.night, cw, ch, alpha);
    } else {
      // Pure night
      _renderPhase(canvas, DayPhase.night, cw, ch, 255);
    }

    super.render(canvas);
  }

  void _renderPhase(
    Canvas canvas,
    DayPhase phase,
    double cw,
    double ch,
    int alpha,
  ) {
    final layers = _bgPhases[phase];
    if (layers == null) {
      return;
    }
    final paint = Paint()
      ..color = Color.fromARGB(alpha, 255, 255, 255);
    for (final layer in layers) {
      final img = layer.image;
      final src = Rect.fromLTWH(
        0,
        0,
        img.width.toDouble(),
        img.height.toDouble(),
      );
      final Rect dst;
      if (layer.align == _BgLayerAlign.fill) {
        dst = Rect.fromLTWH(0, 0, cw, ch);
      } else {
        final aspect = img.width / img.height;
        final h = cw / aspect;
        dst = Rect.fromLTWH(0, ch - h, cw, h);
      }
      canvas.drawImageRect(img, src, dst, paint);
    }
  }

  @override
  Future<void> onLoad() async {
    camera = CameraComponent.withFixedResolution(
      width: GameConstants.viewportWidth,
      height: GameConstants.viewportHeight,
    );

    await _loadAllBackgrounds();

    _buildRooms();

    building = Building();
    await world.add(building);

    await building.loaded;
    manager = building.manager;

    camera.viewport.add(BalanceHud());
    camera.viewport.add(DayTimerHud());
    world.add(DayCycleController());

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
    if (!isDayActive) {
      return;
    }
    final overlay = PeekView(room: room);
    peekOverlay = overlay;
    camera.viewport.add(overlay);
  }

  void stopPeek() {
    peekOverlay?.removeFromParent();
    peekOverlay = null;
  }

  void reportViolation(Room room, Violation? violation) {
    if (!isDayActive) {
      return;
    }
    if (room.reported) {
      return;
    }

    room.reported = true;
    room.reportedViolation = violation;

    final center = Vector2(
      GameConstants.viewportWidth / 2,
      GameConstants.viewportHeight / 2,
    );

    if (violation != null && room.activeViolations.contains(violation)) {
      balance += GameConstants.correctReportReward;
      camera.viewport.add(
        FeedbackText.correct(
          GameConstants.correctReportReward,
          position: center,
        ),
      );
    } else if (violation != null &&
        !room.activeViolations.contains(violation)) {
      balance -= GameConstants.wrongReportPenalty;
      camera.viewport.add(
        FeedbackText.wrong(
          GameConstants.wrongReportPenalty,
          position: center,
        ),
      );
    } else if (violation == null && room.hasViolations) {
      balance -= GameConstants.wrongReportPenalty;
      camera.viewport.add(
        FeedbackText.wrong(
          GameConstants.wrongReportPenalty,
          position: center,
        ),
      );
    } else if (violation == null && !room.hasViolations) {
      balance += GameConstants.correctReportReward;
      camera.viewport.add(
        FeedbackText.correct(
          GameConstants.correctReportReward,
          position: center,
        ),
      );
    }

    stopPeek();
  }

  void endDay() {
    if (!isDayActive) {
      return;
    }
    stopPeek();
    isDayActive = false;

    var missedCount = 0;
    for (final room in rooms) {
      if (!room.reported && room.hasViolations) {
        missedCount++;
      }
    }

    final penaltyTotal = missedCount * GameConstants.missedViolationPenalty;
    balance -= penaltyTotal;

    final summary = DaySummaryHud(
      day: currentDay,
      missedCount: missedCount,
      penaltyTotal: penaltyTotal,
      currentBalance: balance,
    );
    _summaryHud = summary;
    camera.viewport.add(summary);
  }

  void startNewDay() {
    currentDay++;
    dayTimeRemaining = GameConstants.dayDurationSeconds;
    isDayActive = true;

    for (final room in rooms) {
      room.reported = false;
      room.reportedViolation = null;
      room.randomizeViolations();
    }

    _summaryHud?.removeFromParent();
    _summaryHud = null;
  }

  Future<void> _loadAllBackgrounds() async {
    for (final phase in DayPhase.values) {
      final name = phase.name;
      final layers = <_BgLayer>[];

      layers.add(
        _BgLayer(
          await images.load('background/$name/background.png'),
          _BgLayerAlign.fill,
        ),
      );

      if (phase == DayPhase.night) {
        layers.add(
          _BgLayer(
            await images.load('background/$name/stars01.png'),
            _BgLayerAlign.fill,
          ),
        );
        layers.add(
          _BgLayer(
            await images.load('background/$name/stars02.png'),
            _BgLayerAlign.fill,
          ),
        );
        layers.add(
          _BgLayer(
            await images.load('background/$name/cloudstripes.png'),
            _BgLayerAlign.fill,
          ),
        );
      } else if (phase == DayPhase.sunset) {
        layers.add(
          _BgLayer(
            await images.load('background/$name/sun.png'),
            _BgLayerAlign.fill,
          ),
        );
        layers.add(
          _BgLayer(
            await images.load('background/$name/cloudstripes.png'),
            _BgLayerAlign.fill,
          ),
        );
      }

      layers.add(
        _BgLayer(
          await images.load('background/$name/buildingsback.png'),
          _BgLayerAlign.bottom,
        ),
      );
      layers.add(
        _BgLayer(
          await images.load('background/$name/buildingsfront.png'),
          _BgLayerAlign.bottom,
        ),
      );

      _bgPhases[phase] = layers;
    }
  }

  void _buildRooms() {
    rooms.clear();
    for (var f = 0; f < floorCount; f++) {
      for (var r = 0; r < GameConstants.roomsPerFloor; r++) {
        final room = Room(
          floorIndex: f,
          roomIndex: r,
          tenant: Tenant(
            name: 'Tenant ${f * GameConstants.roomsPerFloor + r + 1}',
          ),
        );
        room.randomizeViolations();
        rooms.add(room);
      }
    }
  }
}

enum DayPhase { daytime, sunset, night }

enum _BgLayerAlign { fill, bottom }

class _BgLayer {
  _BgLayer(this.image, this.align);
  final Image image;
  final _BgLayerAlign align;
}
