import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:flutter/services.dart';
import 'package:keyhole_manager/components/peek_view/room_violations.dart';
import 'package:keyhole_manager/components/peek_view/violation_list.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/game/keyhole_manager_game.dart';
import 'package:keyhole_manager/models/room.dart';

class PeekView extends PositionComponent
    with KeyboardHandler, HasGameReference<KeyholeManagerGame> {
  final Room room;

  late final ViolationList _violationList;

  static const double _padding = 8;
  static const double _columnGap = 6;
  static const double _violationListWidth = 80;
  static const double _textSize = 8;
  static const double _headerY = 10;
  static const double _listY = 24;

  static final _bgPaint = Paint()..color = const Color(0xDD000000);

  PeekView({required this.room})
      : super(
          size: Vector2(
            GameConstants.viewportWidth,
            GameConstants.viewportHeight,
          ),
          anchor: Anchor.topLeft,
          priority: 100,
        );

  double get _roomWidth =>
      size.x - _padding * 2 - _violationListWidth - _columnGap;

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is! KeyDownEvent) {
      return true;
    }

    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      _violationList.moveCursor(-1);
    } else if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.keyS) {
      _violationList.moveCursor(1);
    } else if (key == LogicalKeyboardKey.keyE ||
        key == LogicalKeyboardKey.space) {
      if (!room.reported) {
        game.reportViolation(room, _violationList.selectedOption);
      } else {
        game.stopPeek();
      }
    } else if (key == LogicalKeyboardKey.escape) {
      game.stopPeek();
    }
    return true;
  }

  @override
  Future<void> onLoad() async {
    final listX = _padding + _roomWidth + _columnGap;

    _violationList = ViolationList(
      activeRules: game.activeRules,
      position: Vector2(listX, _listY),
      size: Vector2(_violationListWidth, size.y - _listY),
    );

    final roomViolations = RoomViolations(
      room: room,
      position: Vector2(_padding, _listY),
      size: Vector2(_roomWidth, size.y - _listY),
    );

    const headerStyle =
        TextStyle(fontSize: _textSize, color: Color(0xFF888888));
    final headerRenderer = TextPaint(style: headerStyle);

    final roomHeader = TextComponent(
      text: 'ROOM',
      position: Vector2(_padding, _headerY),
      textRenderer: headerRenderer,
    );

    final violationsHeader = TextComponent(
      text: 'VIOLATIONS',
      position: Vector2(listX, _headerY),
      textRenderer: headerRenderer,
    );

    addAll([_violationList, roomViolations, roomHeader, violationsHeader]);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _bgPaint);
  }
}
