import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/game/keyhole_manager_game.dart';

class DayTimerHud extends PositionComponent
    with HasGameReference<KeyholeManagerGame> {
  DayTimerHud()
      : super(
          position: Vector2(GameConstants.viewportWidth / 2, 4),
          anchor: Anchor.topCenter,
          priority: 50,
        );

  @override
  void render(Canvas canvas) {
    final seconds = game.dayTimeRemaining.ceil();
    final text = 'Day ${game.currentDay}  ${seconds}s';

    Color color;
    if (game.dayTimeRemaining < 5) {
      color = const Color(0xFFFF4444);
    } else if (game.dayTimeRemaining < 15) {
      color = const Color(0xFFFFCC00);
    } else {
      color = const Color(0xFFFFFFFF);
    }

    final paint = TextPaint(
      style: TextStyle(fontSize: 10, color: color),
    );
    paint.render(canvas, text, Vector2.zero(), anchor: Anchor.topCenter);
  }
}
