import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/Yuki_Sekai/PlayerInfo.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/Yuki_Sekai/yuki_sekai_service.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/levels/levels/level_y2006.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/players/player.dart';
import 'package:flame/experimental.dart'; // Gives you the Rectangle

enum PlayerState { idle, running, jumping, falling }

class YukiSekai extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  late final DatabaseReference? fireBaseDB;

  Player player = Player();

  @override
  Color backgroundColor() => Color.fromARGB(255, 0, 0, 0);
  late final CameraComponent cam;
  late JoystickComponent joystick;
  bool showControl = true;

  @override
  FutureOr<void> onLoad() async {
    fireBaseDB = await FirebaseDatabase.instance
        .ref('Yuki_Sekai/${InitData.curr_worldName}');
    InitData.playersInfo.clear();
    player.costume = InitData.curr_garment;
    //load all images into cache
    await images.loadAllImages();

    final world =
        YukiSekaiService().generateLevel(InitData.curr_worldName, player);
    await PlayerInfo.createPlayer(player: player, costume: player.costume);
    //create other players
    readPlayerInfo();
    cam = YukiSekaiService()
        .generateCamera(world, InitData.curr_worldName, player);
    addAll([cam, world]);

    if (showControl) {
      addJoystick();
    }

    return super.onLoad();
  }

  @override
  void onRemove() {
    fireBaseDB!.onDisconnect();
    super.onRemove();
  }

  @override
  void update(double dt) {
    updateJoystick();
    super.update(dt);
  }

  void addJoystick() {
    joystick = JoystickComponent(
      priority: 20,
      background: CircleComponent(
        radius: 48,
        paint: Paint()..color = Color.fromARGB(30, 0, 0, 0),
      ),
      knob: CircleComponent(
        radius: 25,
        paint: Paint()..color = Color.fromARGB(76, 255, 255, 255),
      ),
      position: Vector2(65, 247),
      //margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    cam.viewport.add(joystick);
  }

  void updateJoystick() {
    //horizontal
    switch (joystick.direction) {
      case JoystickDirection.upLeft:
      case JoystickDirection.downLeft:
      case JoystickDirection.left:
        player.horizontalMovement = -1;
        break;
      case JoystickDirection.upRight:
      case JoystickDirection.right:
      case JoystickDirection.downRight:
        player.horizontalMovement = 1;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
    //jump
    if (player.isOnGround) {
      if (joystick.direction == JoystickDirection.up ||
          joystick.direction == JoystickDirection.upLeft ||
          joystick.direction == JoystickDirection.upRight) {
        player.hasJumped = true;
      }
    }
  }

  void readPlayerInfo() {
    //read other players' info
    //delete
    fireBaseDB!.onChildRemoved.listen((event) {
      final data = event.snapshot;
      if (InitData.playersInfo.isNotEmpty) {
        for (int i = 0; i < InitData.playersInfo.length; i++) {
          if (data.child('uid').value.toString() ==
              InitData.playersInfo[i].uid) {
            InitData.playersInfo.removeAt(i);
            print(
                'player info removed: ${data.child('uid').value.toString()}\nthere are ${InitData.playersInfo.length} otherPlayers');
            break;
          }
        }
      }
    });
    //add
    fireBaseDB!.onChildAdded.listen((event) {
      final data = event.snapshot;
      PlayerInfo new_info = PlayerInfo(
          costume: data.child('costume').value.toString(),
          uid: data.child('uid').value.toString(),
          name: data.child('name').value.toString(),
          x: double.parse(data.child('x').value.toString()),
          y: double.parse(data.child('y').value.toString()),
          velocityX: double.parse(data.child('velocityX').value.toString()),
          velocityY: double.parse(data.child('velocityY').value.toString()),
          //form: 'PlayerState.running'
          state: data.child('state').value.toString());

      if (new_info.uid != InitData.miyukiUser.uid) {
        if (InitData.playersInfo
            .every((element) => element.uid != new_info.uid)) {
          //add new player
          InitData.playersInfo.add(new_info);
          print(
              'player info added: there are ${InitData.playersInfo.length} otherPlayers');
        }
      }
    });
    //onchanged
    final snapshot = fireBaseDB!.onChildChanged.listen((event) {
      final data = event.snapshot;
      PlayerInfo new_info = PlayerInfo(
          costume: data.child('costume').value.toString(),
          uid: data.child('uid').value.toString(),
          name: data.child('name').value.toString(),
          x: double.parse(data.child('x').value.toString()),
          y: double.parse(data.child('y').value.toString()),
          velocityX: double.parse(data.child('velocityX').value.toString()),
          velocityY: double.parse(data.child('velocityY').value.toString()),
          //form: 'PlayerState.running'
          state: data.child('state').value.toString());

      //print('player_info: + ${new_info.x}');
      //not the self
      if (new_info.uid != InitData.miyukiUser.uid) {
        if (InitData.playersInfo
            .every((element) => element.uid != new_info.uid)) {
          //add new player
          InitData.playersInfo.add(new_info);
          print(
              'player info added: there are ${InitData.playersInfo.length} otherPlayers');
        } else {
          for (int i = 0; i < InitData.playersInfo.length; i++) {
            if (InitData.playersInfo[i].uid == new_info.uid) {
              InitData.playersInfo[i] = new_info;
              break;
            }
          }
        }
      }
      // InitData.playersInfo.forEach((element) {
      //   print('player list: ${element.velocityX}');
      // });
    });
  }
}
