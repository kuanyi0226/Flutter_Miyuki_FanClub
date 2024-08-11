import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/experimental.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/levels/levels/level_2007_0.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/levels/levels/level_y2006.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/players/player.dart';

import '../../materials/InitData.dart';

class YukiSekaiService {
  bool checkCollision(Player player, block) {
    final hitbox = player.hitbox;
    final playerX = player.position.x + hitbox.offsetX;
    final playerY = player.position.y + hitbox.offsetY;
    final playerWidth = hitbox.width;
    final playerHeight = hitbox.height;

    final blockX = block.x;
    final blockY = block.y;
    final blockWidth = block.width;
    final blockHeight = block.height;

    final fixedX = player.scale.x < 0
        ? playerX - (hitbox.offsetX * 2) - playerWidth
        : playerX;
    final fixedY = block.isPlatform ? playerY + playerHeight : playerY;

    return (fixedY < blockY + blockHeight &&
        playerY + playerHeight > blockY &&
        fixedX < blockX + blockWidth &&
        fixedX + playerWidth > blockX);
  }

  World generateLevel(String levelName, Player player) {
    if (levelName == '2007_0')
      return Level_2007_0(levelName: levelName, player: player);
    else
      return Level_y2006(levelName: levelName, player: player);
  }

  CameraComponent generateCamera(World world, String levelName, Player player) {
    CameraComponent cam;
    if (levelName == '2007_0') {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 800, height: 350);
      cam.viewfinder.anchor = Anchor.centerLeft;
      cam.setBounds(Rectangle.fromLTRB(0, 0, 800, 300));
      cam.follow(player, verticalOnly: true);
      cam.priority = 0;
    } else {
      cam = CameraComponent.withFixedResolution(
          world: world, width: 640, height: 300);
      cam.viewfinder.anchor = Anchor.centerLeft;
      cam.follow(player, verticalOnly: true);
      cam.priority = 0;
    }
    return cam;
  }

  //GarmentAnimationInfo
  static List<int> getGarmentAnimationAmount(String costume) {
    //idle, running, jumping, falling
    switch (costume) {
      case 'y2006_pink_dress':
        return [11, 4, 1, 1];
      case 'y2006_black_dress':
        return [11, 4, 1, 1];
      case '2007_0_red_dress':
        return [8, 4, 1, 1];
      default:
        return [11, 4, 1, 1];
    }
  }

  static double getGarmentAnimationStepTime(String costume, String state) {
    //idle, running, jumping, falling
    int index = 0;
    List<double> stepTime = [];
    switch (state) {
      case 'Idle':
        index = 0;
        break;
      case 'Run':
        index = 1;
        break;
      case 'Jump':
        index = 2;
        break;
      default:
        index = 3;
        break;
    }
    switch (costume) {
      case 'y2006_pink_dress':
        stepTime = [0.05, 0.1, 0.05, 0.05];
        break;
      case 'y2006_black_dress':
        stepTime = [0.05, 0.1, 0.05, 0.05];
        break;
      case '2007_0_red_dress':
        stepTime = [1.5, 0.2, 0.05, 0.05];
        break;
      default:
        stepTime = [0.05, 0.1, 0.05, 0.05];
        break;
    }

    return stepTime[index];
  }

  static Vector2 getGarmentAnimationTextureSize(String costume) {
    //idle, running, jumping, falling
    switch (costume) {
      case 'y2006_pink_dress':
        return Vector2.all(64);
      default:
        return Vector2.all(64);
    }
  }
}
