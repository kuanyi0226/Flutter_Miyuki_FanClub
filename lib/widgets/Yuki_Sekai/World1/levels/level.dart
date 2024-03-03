import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/players/player.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/components/collision_block.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/players/other_player.dart';

class Level extends World {
  late TiledComponent level;
  final String levelName;
  final Player player;
  List<CollisionBlock> collisionBlocks = [];
  List<String> otherplayers = []; //uid
  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            // final nameTag = TextComponent(text: InitData.miyukiUser.name)
            //   ..anchor = Anchor.topLeft
            //   ..size = Vector2(1, 1)
            //   ..position = Vector2(-30 / 2, -32.0)
            //   ..priority = 300;
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
            //player.add(nameTag);
            break;
          default:
        }
      }
    }

    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Collisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        switch (collision.class_) {
          case 'Platform':
            final platform = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: true);
            collisionBlocks.add(platform);
            add(platform);
            break;
          default:
            final block = CollisionBlock(
                position: Vector2(collision.x, collision.y),
                size: Vector2(collision.width, collision.height),
                isPlatform: false);
            collisionBlocks.add(block);
            add(block);
            break;
        }
      }
    }
    player.collisionBlocks = collisionBlocks;
    return super.onLoad();
  }

  @override
  void update(double dt) {
    if (InitData.playersInfo.isNotEmpty) {
      InitData.playersInfo.forEach((element) {
        if (!otherplayers.contains(element.uid)) {
          OtherPlayer new_player = OtherPlayer(
              uid: element.uid,
              position: Vector2(element.x, element.y),
              costume: element.costume);
          new_player.priority = 100;
          otherplayers.add(new_player.uid);
          //name tag
          final nameTag = TextComponent(text: element.name)
            ..anchor = Anchor.topLeft
            ..size = Vector2(1, 1)
            ..position = Vector2(-30 / 2, -32.0)
            ..priority = 300;
          new_player.add(nameTag);
          this.add(new_player);
          print('Added new player to Level: ${element.uid}');
        }
      });
    }
    //delete non-exist otherPlayer
    if (otherplayers.isNotEmpty) {
      for (int i = 0; i < otherplayers.length; i++) {
        bool stillInWorld = false;
        InitData.playersInfo.forEach((element) {
          if (element.uid == otherplayers[i]) stillInWorld = true;
        });
        if (!stillInWorld) otherplayers.removeAt(i);
      }
    }
    super.update(dt);
  }
}
