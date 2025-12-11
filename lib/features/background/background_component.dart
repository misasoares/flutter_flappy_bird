import 'package:flame/components.dart';
import 'package:flame/game.dart';

class Background extends SpriteComponent with HasGameRef<FlameGame> {
  Background() : super(priority: 0);

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('background.png');
    size = gameRef.size;
    position = Vector2.zero();
    anchor = Anchor.topLeft;
  }
}
