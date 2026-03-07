import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:keyhole_manager/game/keyhole_manager_game.dart';

class BalanceHud extends PositionComponent
    with HasGameReference<KeyholeManagerGame> {
  static final _textPaint = TextPaint(
    style: const TextStyle(fontSize: 10, color: Color(0xFFFFFFFF)),
  );

  BalanceHud() : super(position: Vector2(4, 4), priority: 50);

  @override
  void render(Canvas canvas) {
    _textPaint.render(canvas, '\$${game.balance}', Vector2.zero());
  }
}
