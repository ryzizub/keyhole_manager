import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:flutter/services.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/game/keyhole_manager_game.dart';

class StartMenuHud extends PositionComponent
    with KeyboardHandler, HasGameReference<KeyholeManagerGame> {
  static final _overlayPaint = Paint()..color = const Color(0xBB000000);
  static final _keyholePaint = Paint()..color = const Color(0xFF000000);
  static final _titlePaint = TextPaint(
    style: const TextStyle(fontSize: 14, color: Color(0xFFCC0000)),
  );
  static final _taglinePaint = TextPaint(
    style: const TextStyle(fontSize: 8, color: Color(0xFF999999)),
  );
  static final _promptPaint = TextPaint(
    style: const TextStyle(fontSize: 8, color: Color(0xFFFFCC00)),
  );

  double _blinkTimer = 0;
  bool _showPrompt = true;

  StartMenuHud()
      : super(
          size: Vector2(
            GameConstants.viewportWidth,
            GameConstants.viewportHeight,
          ),
          priority: 200,
        );

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is KeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.enter ||
          event.logicalKey == LogicalKeyboardKey.space) {
        game.startGame();
        return true;
      }
    }
    return true;
  }

  @override
  void update(double dt) {
    _blinkTimer += dt;
    if (_blinkTimer >= 0.5) {
      _blinkTimer = 0;
      _showPrompt = !_showPrompt;
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _overlayPaint);

    final cx = size.x / 2;
    final cy = size.y / 2;

    // Keyhole shape: circle + rectangle below
    const circleRadius = 14.0;
    final circleCenter = Offset(cx, cy - 30);
    canvas.drawCircle(circleCenter, circleRadius, _keyholePaint);
    const rectWidth = 10.0;
    const rectHeight = 18.0;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(cx, cy - 30 + circleRadius + rectHeight / 2 - 2),
          width: rectWidth,
          height: rectHeight,
        ),
        const Radius.circular(2),
      ),
      _keyholePaint,
    );

    // Inner glow (slightly lighter circle)
    final innerPaint = Paint()..color = const Color(0xFF1A1A2E);
    canvas.drawCircle(circleCenter, circleRadius - 2, innerPaint);

    var y = cy + 12;

    _titlePaint.render(
      canvas,
      'KEYHOLE MANAGER',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 18;

    _taglinePaint.render(
      canvas,
      'See everything. Trust no one.',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 20;

    if (_showPrompt) {
      _promptPaint.render(
        canvas,
        'PRESS ENTER TO START',
        Vector2(cx, y),
        anchor: Anchor.topCenter,
      );
    }
  }
}
