import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:keyhole_manager/game/keyhole_manager_game.dart';

void main() {
  runApp(
    const GameWidget.controlled(
      gameFactory: KeyholeManagerGame.new,
    ),
  );
}
