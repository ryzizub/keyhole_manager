import 'dart:ui';

import 'package:flame/components.dart';
import 'package:keyhole_manager/components/peek_view/room_violations.dart';
import 'package:keyhole_manager/components/peek_view/violation_list.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/models/room.dart';
import 'package:keyhole_manager/models/violation.dart';

class PeekView extends PositionComponent {
  final Room? room;

  late final ViolationList _violationList;

  static const double _padding = 8;
  static const double _columnGap = 6;
  static const double _violationListWidth = 80;
  static const double _textSize = 8;
  static const double _headerY = 10;
  static const double _listY = 24;

  PeekView({this.room})
      : super(
          size: Vector2(
            GameConstants.viewportWidth,
            GameConstants.viewportHeight,
          ),
          anchor: Anchor.topLeft,
        );

  double get _roomWidth =>
      size.x - _padding * 2 - _violationListWidth - _columnGap;

  void moveCursor(int dir) => _violationList.moveCursor(dir);

  Violation get selectedViolation => _violationList.selectedViolation;

  @override
  Future<void> onLoad() async {
    final listX = _padding + _roomWidth + _columnGap;

    _violationList = ViolationList(
      position: Vector2(listX, _listY),
      size: Vector2(_violationListWidth, size.y - _listY),
    );

    final roomViolations = RoomViolations(
      room: room,
      position: Vector2(_padding, _listY),
      size: Vector2(_roomWidth, size.y - _listY),
    );

    addAll([_violationList, roomViolations]);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color(0xDD000000),
    );

    const roomX = _padding;
    final listX = _padding + _roomWidth + _columnGap;

    _renderHeader(canvas, roomX, _roomWidth, 'ROOM');
    _renderHeader(canvas, listX, _violationListWidth, 'VIOLATIONS');
  }

  void _renderHeader(Canvas canvas, double x, double width, String text) {
    final pb = ParagraphBuilder(ParagraphStyle(fontSize: _textSize))
      ..pushStyle(TextStyle(color: const Color(0xFF888888)))
      ..addText(text);
    final p = pb.build()..layout(ParagraphConstraints(width: width));
    canvas.drawParagraph(p, Offset(x, _headerY));
  }
}
