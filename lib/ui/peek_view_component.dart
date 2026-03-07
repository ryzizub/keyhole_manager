import 'package:flame/components.dart';
import 'package:flutter/painting.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/models/room.dart';

class PeekViewComponent extends PositionComponent {
  final Room? room;

  PeekViewComponent({this.room})
      : super(
          size: Vector2(
            GameConstants.viewportWidth,
            GameConstants.viewportHeight,
          ),
          anchor: Anchor.topLeft,
        );

  @override
  Future<void> onLoad() async {
    final tenantName = room?.tenant?.name ?? 'Empty';
    final roomLabel = room != null
        ? 'Floor ${room!.floorIndex + 1}, Room ${room!.roomIndex + 1}'
        : 'Unknown';

    var y = GameConstants.viewportHeight / 2 - 40;
    y = _addLabel('[ Keyhole View ]', y, 12, const Color(0xB3FFFFFF), 28);
    y = _addLabel(roomLabel, y, 16, const Color(0xFFFFFFFF), 22);
    y = _addLabel(tenantName, y, 14, const Color(0xFFFFD740), 32);
    _addLabel(
      'Press E / Space / Escape to close',
      y,
      10,
      const Color(0x8AFFFFFF),
      0,
    );
  }

  double _addLabel(
    String text,
    double y,
    double fontSize,
    Color color,
    double spacing,
  ) {
    add(
      TextComponent(
        text: text,
        anchor: Anchor.topCenter,
        position: Vector2(GameConstants.viewportWidth / 2, y),
        textRenderer: TextPaint(
          style: TextStyle(
            color: color,
            fontSize: fontSize,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
    return y + spacing;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      size.toRect(),
      Paint()..color = const Color(0xDD000000),
    );
    super.render(canvas);
  }
}
