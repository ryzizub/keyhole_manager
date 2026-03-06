import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:keyhole_manager/game/keyhole_manager_game.dart';
import 'package:keyhole_manager/ui/peek_overlay.dart';

void main() {
  runApp(
    GameWidget.controlled(
      gameFactory: KeyholeManagerGame.new,
      overlayBuilderMap: {
        'peek': (context, game) =>
            PeekOverlay(room: (game! as KeyholeManagerGame).peekedRoom),
      },
    ),
  );
}
