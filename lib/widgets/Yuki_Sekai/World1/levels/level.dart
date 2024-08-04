import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/components/darkeffect.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/players/player.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/components/collision_block.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/players/other_player.dart';

import '../../components/spotlight.dart';

class Level extends World {
  late TiledComponent level;
  final String levelName;
  final Player player;
  late final Spotlight spotlight1;
  late final Spotlight spotlight2;
  late final DarkEffect darkEffect;
  List<CollisionBlock> collisionBlocks = [];
  List<String> otherplayers = []; //uid
  late SpriteComponent _background;

  Level({required this.levelName, required this.player});

  @override
  FutureOr<void> onLoad() async {
    otherplayers.clear();
    final image = await Flame.images.load('yuki_sekai/y2006/background.png');
    _background = SpriteComponent.fromImage(
      image,
    );

    level = await TiledComponent.load('$levelName.tmx', Vector2.all(16));

    add(level);
    add(_background);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('SpawnPoints');

    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            player.priority = 7;
            add(player);
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

    //dark effect
    darkEffect = DarkEffect();
    add(darkEffect);
    darkEffect.priority = 6;

    //spotlights
    spotlight1 = Spotlight(
        playerSize: player.size, source: Vector2(50, -150), following: true)
      ..size = Vector2(100, 100) // Set size to match the shadow size
      ..position = Vector2.zero();
    add(spotlight1);
    spotlight1.priority = 100;
    spotlight2 = Spotlight(
        playerSize: player.size, source: Vector2(650, -150), following: true)
      ..size = Vector2(100, 100) // Set size to match the shadow size
      ..position = Vector2.zero();
    add(spotlight2);
    spotlight2.priority = 100;

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
              costume: element.costume,
              name: element.name);
          new_player.priority = 5;
          otherplayers.add(new_player.uid);

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
        if (!stillInWorld) {
          otherplayers.removeAt(i);
          print('otherPlayers.length = ${otherplayers.length}');
        }
      }
    }
    //lights following player
    spotlight1.updateCharacterPosition(player.position, player.faceRight);
    spotlight2.updateCharacterPosition(player.position, player.faceRight);
    //turn on/off the effect
    if (InitData.turnOnEffect)
      turnOnEffect();
    else
      turnOffEffect();
    super.update(dt);
  }

  void turnOnEffect() {
    spotlight1.enable = true;
    spotlight2.enable = true;
    darkEffect.enable = true;
  }

  void turnOffEffect() {
    spotlight1.enable = false;
    spotlight2.enable = false;
    darkEffect.enable = false;
  }
}
