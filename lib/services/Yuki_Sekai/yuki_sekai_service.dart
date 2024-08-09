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
}
