import 'dart:async';
import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/Yuki_Sekai/YukiSekai.dart';
import 'package:project5_miyuki/services/Yuki_Sekai/yuki_sekai_service.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/components/collision_block.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/components/player_hitbox.dart';

enum PlayerState { idle, running, jumping, falling }

class OtherPlayer extends SpriteAnimationGroupComponent
    with HasGameRef<YukiSekai>, KeyboardHandler {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;

  String name;
  TextComponent nameTag = TextBoxComponent();

  String uid;
  String costume;
  double horizontalMovement = 0;
  double moveSpeed = 110;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;

  List<CollisionBlock> collisionBlocks = [];
  PlayerHitbox hitbox = PlayerHitbox(
    offsetX: 20,
    offsetY: 4,
    width: 28,
    height: 55,
  );
  double fixedDeltaTime = 1 / 60;
  double accumulatedTime = 0;
  bool isIdle = false;

  OtherPlayer(
      {super.position,
      required this.uid,
      this.costume = 'y2006_pink_dress',
      this.name = 'No Name'});

  @override
  FutureOr<void> onLoad() {
    //init animation
    _loadAllAnimations();
    //init name tag
    nameTag = TextComponent(text: name)
      ..textRenderer =
          TextPaint(style: TextStyle(fontSize: 13, color: Colors.white))
      ..anchor = Anchor.topCenter
      ..position = Vector2(sqrt((75 - name.length.toDouble()) * 15), -16.0)
      ..priority = 300;
    add(nameTag);
    add(RectangleHitbox(
      position: Vector2(hitbox.offsetX, hitbox.offsetY),
      size: Vector2(hitbox.width, hitbox.height),
    ));
    return super.onLoad();
  }

  @override
  void update(double dt) {
    accumulatedTime += dt;
    while (accumulatedTime >= fixedDeltaTime) {
      _updatePlayerState();
      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  void _loadAllAnimations() {
    List<int> amountInfo = YukiSekaiService.getGarmentAnimationAmount(costume);
    idleAnimation = _spriteAnimation('Idle', amountInfo[0]);
    runningAnimation = _spriteAnimation('Run', amountInfo[1]);
    jumpingAnimation = _spriteAnimation('Jump', amountInfo[2]);
    fallingAnimation = _spriteAnimation('Fall', amountInfo[3]);

    //List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.jumping: jumpingAnimation,
      PlayerState.falling: fallingAnimation,
    };
    //Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _spriteAnimation(String state, int amount) {
    try {
      return SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'yuki_sekai/Main Characters/$costume/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount, //amount of pictures in the animation
          stepTime:
              YukiSekaiService.getGarmentAnimationStepTime(costume, state),
          textureSize: YukiSekaiService.getGarmentAnimationTextureSize(costume),
        ),
      );
    } catch (e) {
      //error handling
      return SpriteAnimation.fromFrameData(
        game.images.fromCache(
            'yuki_sekai/Main Characters/y2006_pink_dress/$state (32x32).png'),
        SpriteAnimationData.sequenced(
          amount: amount, //amount of pictures in the animation
          stepTime:
              YukiSekaiService.getGarmentAnimationStepTime(costume, state),
          textureSize: YukiSekaiService.getGarmentAnimationTextureSize(costume),
        ),
      );
    }
  }

  void _updatePlayerState() {
    bool stillInWorld = false;
    InitData.playersInfo.forEach((element) {
      if (uid == element.uid) {
        position.x = element.x;
        position.y = element.y;
        velocity.x = element.velocityX;
        velocity.y = element.velocityY;
        switch (element.state) {
          case 'PlayerState.running':
            current = PlayerState.running;
            break;
          case 'PlayerState.jumping':
            current = PlayerState.jumping;
            break;
          case 'PlayerState.falling':
            current = PlayerState.falling;
            break;
          default:
            current = PlayerState.idle;
        }
        stillInWorld = true;
      }
    });
    //Been deleted
    if (!stillInWorld) {
      print('A other player removed from parent');
      removeFromParent();
    }

    if ((velocity.x < 0 && scale.x > 0) || (velocity.x > 0 && scale.x < 0)) {
      flipHorizontallyAroundCenter();
      nameTag.flipHorizontallyAroundCenter();
    }
  }
}
