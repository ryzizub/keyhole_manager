import 'package:flame/components.dart';
import 'package:keyhole_manager/config/game_constants.dart';
import 'package:keyhole_manager/game/keyhole_manager_game.dart';

class DayCycleController extends Component
    with HasGameReference<KeyholeManagerGame> {
  double _pauseTimer = 0;

  @override
  void update(double dt) {
    if (game.isDayActive) {
      game.dayTimeRemaining -= dt;
      if (game.dayTimeRemaining <= 0) {
        game.dayTimeRemaining = 0;
        game.endDay();
      }
    } else {
      _pauseTimer += dt;
      if (_pauseTimer >= GameConstants.dayEndPauseDuration) {
        _pauseTimer = 0;
        game.startNewDay();
      }
    }
  }
}
