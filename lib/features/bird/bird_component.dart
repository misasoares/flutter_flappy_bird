import 'dart:ui';
import 'package:flame/components.dart';

class Bird extends SpriteComponent {
  Bird() {
    width = 50;
    height = 50;
    x = 100;
    y = 300;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('bird.png');
  }

  Rect getCollisionRect() {
    return toRect().deflate(5);
  }
}
