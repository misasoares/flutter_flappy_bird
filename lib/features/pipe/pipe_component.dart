import 'dart:ui';
import 'package:flame/components.dart';

class Pipe extends SpriteComponent {
  bool isInverted;

  Pipe({required this.isInverted, required double height}) {
    size = Vector2(60, height);
    anchor = Anchor.topLeft;
  }

  @override
  Future<void> onLoad() async {
    sprite = await Sprite.load('pipe.png');
    _updateOrientation();
  }

  void updateDimensions(bool inverted, double height) {
    isInverted = inverted;
    size = Vector2(60, height);
    _updateOrientation();
  }

  void _updateOrientation() {
    if (isInverted) {
      scale.y = -1;
    } else {
      scale.y = 1;
    }
  }

  Rect getCollisionRect() {
    return toRect().deflate(2);
  }
}
