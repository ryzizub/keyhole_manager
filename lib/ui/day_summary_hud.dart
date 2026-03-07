import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:keyhole_manager/config/game_constants.dart';

class DaySummaryHud extends PositionComponent {
  static final _bgPaint = Paint()..color = const Color(0xCC000000);
  static final _textPaint = TextPaint(
    style: const TextStyle(fontSize: 10, color: Color(0xFFFFFFFF)),
  );
  static final _titlePaint = TextPaint(
    style: const TextStyle(fontSize: 14, color: Color(0xFFFFCC00)),
  );

  final int day;
  final int missedCount;
  final int penaltyTotal;
  final int currentBalance;

  DaySummaryHud({
    required this.day,
    required this.missedCount,
    required this.penaltyTotal,
    required this.currentBalance,
  }) : super(
          size: Vector2(
            GameConstants.viewportWidth,
            GameConstants.viewportHeight,
          ),
          priority: 100,
        );

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _bgPaint);

    final cx = size.x / 2;
    var y = size.y / 2 - 30;

    _titlePaint.render(
      canvas,
      'Day $day Complete',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 20;

    _textPaint.render(
      canvas,
      'Missed violations: $missedCount',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 14;

    _textPaint.render(
      canvas,
      'Penalty: -\$$penaltyTotal',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 14;

    _textPaint.render(
      canvas,
      'Balance: \$$currentBalance',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
  }
}
