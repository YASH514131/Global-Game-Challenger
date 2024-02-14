import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_first/pixel_adventure.dart';

class AttachSaw extends SpriteAnimationComponent with HasGameRef<PixelAdventure> {
  AttachSaw({
    position,
    size,
  }) : super(
          position: position,
          size: size,
        );

  static const double sawSpeed = 0.03;
  static const moveSpeed = 50;
  static const tileSize = 16;
  double moveDirection = 1;
  double rangeNeg = 0;
  double rangePos = 0;

  @override
  FutureOr<void> onLoad() {
    priority = -1;
    debugMode;
    add(CircleHitbox());

    animation = SpriteAnimation.fromFrameData(
        game.images.fromCache('Traps/Saw/On (38x38).png'),
        SpriteAnimationData.sequenced(
          amount: 8,
          stepTime: sawSpeed,
          textureSize: Vector2.all(38),
        ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    
    super.update(dt);
  }

 
}