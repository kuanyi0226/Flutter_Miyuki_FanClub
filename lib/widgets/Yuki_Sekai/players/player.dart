import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:project5_miyuki/class/Yuki_Sekai/PlayerInfo.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/YukiSekai.dart';
import 'package:project5_miyuki/services/Yuki_Sekai/yuki_sekai_service.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/components/collision_block.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/components/player_hitbox.dart';

enum PlayerState { idle, running, jumping, falling }

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<YukiSekai>, KeyboardHandler {
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;
  late final SpriteAnimation fallingAnimation;
  final double stepTime = 0.05;

  String costume;
  double horizontalMovement = 0;
  double moveSpeed = 110;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = false;
  bool hasJumped = false;
  bool faceRight = true;
  final double _gravity = 9.8;
  final double _jumpForce = 260;
  final double _terminalVelocity = 300; //max falling speed

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

  Player({super.position, this.costume = 'Yakai_14_pink_dress'});

  @override
  FutureOr<void> onLoad() {
    isIdle = false;
    if (costume == null) {
      costume = 'Yakai_14_pink_dress';
    }
    _loadAllAnimations();
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
      _updatePlayerMovement(fixedDeltaTime);
      _checkHorizontalCollisions();
      _applyGravity(fixedDeltaTime);
      _checkVerticalCollisions();

      accumulatedTime -= fixedDeltaTime;
    }

    super.update(dt);
  }

  // @override
  // bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   horizontalMovement = 0;
  //   //left
  //   final isLeftKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyA) ||
  //       keysPressed.contains(LogicalKeyboardKey.arrowLeft);
  //   //right
  //   final isRightKeyPressed = keysPressed.contains(LogicalKeyboardKey.keyD) ||
  //       keysPressed.contains(LogicalKeyboardKey.arrowRight);
  //   //jump
  //   hasJumped = keysPressed.contains(LogicalKeyboardKey.space) ||
  //       keysPressed.contains(LogicalKeyboardKey.arrowUp);

  //   horizontalMovement += isLeftKeyPressed ? -1 : 0;
  //   horizontalMovement += isRightKeyPressed ? 1 : 0;

  //   return super.onKeyEvent(event, keysPressed);
  // }

  void _loadAllAnimations() {
    idleAnimation = _spriteAnimation('Idle', 11);
    runningAnimation = _spriteAnimation('Run', 4);
    jumpingAnimation = _spriteAnimation('Jump', 1);
    fallingAnimation = _spriteAnimation('Fall', 1);

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
    return SpriteAnimation.fromFrameData(
      game.images
          .fromCache('yuki_sekai/Main Characters/$costume/$state (32x32).png'),
      SpriteAnimationData.sequenced(
        amount: amount, //amount of pictures in the animation
        stepTime: (state == 'Run') ? stepTime * 2 : stepTime,
        textureSize: Vector2.all(64),
      ),
    );
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround) _playerJump(dt);

    if (velocity.y > _gravity) isOnGround = false;

    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;
  }

  void _playerJump(double dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    hasJumped = false;
    isOnGround = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;

    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
      faceRight = false;
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
      faceRight = true;
    }
    //check if moving, set running
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;
    //check if falling, set falling
    if (velocity.y > 0) playerState = PlayerState.falling;
    //check if jumping, set jumping
    if (velocity.y < 0) playerState = PlayerState.jumping;

    current = playerState;
    //update to realtime database
    _updateInfoToDatabase();
  }

  void _checkHorizontalCollisions() {
    for (final block in collisionBlocks) {
      if (!block.isPlatform) {
        if (YukiSekaiService().checkCollision(this, block)) {
          //right
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - hitbox.offsetX - hitbox.width;
            break;
          }
          //left
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + hitbox.width + hitbox.offsetX;
            break;
          }
        }
      }
    }
  }

  void _checkVerticalCollisions() {
    for (final block in collisionBlocks) {
      if (block.isPlatform) {
        //platform
        if (YukiSekaiService().checkCollision(this, block)) {
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
        }
      } else {
        //blocks
        if (YukiSekaiService().checkCollision(this, block)) {
          //down
          if (velocity.y > 0) {
            velocity.y = 0;
            position.y = block.y - hitbox.height - hitbox.offsetY;
            isOnGround = true;
            break;
          }
          //up
          if (velocity.y < 0) {
            velocity.y = 0;
            position.y = block.y + block.height - hitbox.offsetY;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += _gravity;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _updateInfoToDatabase() {
    if (InitData.isInSekai) {
      if (current == PlayerState.idle) {
        //init is falling
        if (!isIdle || velocity.y != 0) {
          isIdle = true;
          PlayerInfo.updatePlayer(
              //costume: costume,
              x: position.x,
              y: position.y,
              velocityX: velocity.x,
              velocityY: velocity.y,
              state: current.toString());
        }
      } else {
        isIdle = false;
        PlayerInfo.updatePlayer(
            //costume: costume,
            x: position.x,
            y: position.y,
            velocityX: velocity.x,
            velocityY: velocity.y,
            state: current.toString());
      }
    }
  }
}
