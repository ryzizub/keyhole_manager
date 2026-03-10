import 'dart:ui' hide TextStyle;

import 'package:flame/components.dart';
import 'package:flutter/painting.dart' show TextStyle;
import 'package:flutter/services.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/game/keyhole_manager_game.dart';

class GameOverHud extends PositionComponent
    with KeyboardHandler, HasGameReference<KeyholeManagerGame> {
  static final _overlayPaint = Paint()..color = const Color(0xDD000000);
  static final _titlePaint = TextPaint(
    style: const TextStyle(fontSize: 14, color: Color(0xFFCC0000)),
  );
  static final _subtitlePaint = TextPaint(
    style: const TextStyle(fontSize: 8, color: Color(0xFF999999)),
  );
  static final _statsPaint = TextPaint(
    style: const TextStyle(fontSize: 8, color: Color(0xFFFFFFFF)),
  );
  static final _selectedPaint = TextPaint(
    style: const TextStyle(fontSize: 10, color: Color(0xFFFFCC00)),
  );
  static final _unselectedPaint = TextPaint(
    style: const TextStyle(fontSize: 10, color: Color(0xFF888888)),
  );

  final int daysSurvived;
  final int finalBalance;
  int _selectedOption = 0; // 0 = TRY AGAIN, 1 = MAIN MENU

  GameOverHud({required this.daysSurvived, required this.finalBalance})
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
      final key = event.logicalKey;
      if (key == LogicalKeyboardKey.arrowUp ||
          key == LogicalKeyboardKey.keyW) {
        _selectedOption = 0;
      } else if (key == LogicalKeyboardKey.arrowDown ||
          key == LogicalKeyboardKey.keyS) {
        _selectedOption = 1;
      } else if (key == LogicalKeyboardKey.enter ||
          key == LogicalKeyboardKey.space) {
        if (_selectedOption == 0) {
          game.restartGame();
        } else {
          game.returnToMenu();
        }
      }
    }
    return true;
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _overlayPaint);

    final cx = size.x / 2;
    var y = size.y / 2 - 40;

    _titlePaint.render(
      canvas,
      'CONDEMNED',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 18;

    _subtitlePaint.render(
      canvas,
      'Building shut down due to bankruptcy',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 18;

    _statsPaint.render(
      canvas,
      'Days survived: $daysSurvived',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 12;

    _statsPaint.render(
      canvas,
      'Final balance: \$$finalBalance',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 22;

    final tryAgainPaint =
        _selectedOption == 0 ? _selectedPaint : _unselectedPaint;
    final menuPaint =
        _selectedOption == 1 ? _selectedPaint : _unselectedPaint;

    final prefix0 = _selectedOption == 0 ? '> ' : '  ';
    final prefix1 = _selectedOption == 1 ? '> ' : '  ';

    tryAgainPaint.render(
      canvas,
      '${prefix0}TRY AGAIN',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
    y += 14;

    menuPaint.render(
      canvas,
      '${prefix1}MAIN MENU',
      Vector2(cx, y),
      anchor: Anchor.topCenter,
    );
  }
}
