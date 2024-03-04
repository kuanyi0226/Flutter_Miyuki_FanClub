import 'package:project5_miyuki/materials/InitData.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:project5_miyuki/widgets/Yuki_Sekai/players/player.dart';

enum PlayerState { idle, running, jumping, falling }

class PlayerInfo {
  String uid;
  String name;
  String costume;
  double x;
  double y;
  double velocityX;
  double velocityY;
  String state;

  PlayerInfo({
    required this.uid,
    required this.name,
    this.costume = 'Yakai_14_pink_dress',
    required this.x,
    required this.y,
    required this.velocityX,
    required this.velocityY,
    required this.state,
  });

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'costume': costume,
        'x': x,
        'y': y,
        'velocityX': velocityX,
        'velocityY': velocityY,
        'state': state,
      };

  static PlayerInfo fromJson(Map<String, dynamic> json) => PlayerInfo(
        uid: json['uid'],
        name: json['name'],
        costume: json['costume'],
        x: json['x'],
        y: json['y'],
        velocityX: json['velocityX'],
        velocityY: json['velocityY'],
        state: json['state'],
      );
  //create player(only create once)
  static Future createPlayer(
      {required Player player, required String costume}) async {
    PlayerInfo userInfo = PlayerInfo(
        uid: InitData.miyukiUser.uid!,
        costume: costume,
        name: InitData.miyukiUser.name!,
        x: player.position.x,
        y: player.position.y,
        velocityX: player.velocity.x,
        velocityY: player.velocity.y,
        state: PlayerState.idle.toString()); //default idle
    final data = userInfo.toJson();
    final DatabaseReference fireBaseDB = FirebaseDatabase.instance.reference();
    fireBaseDB
        .child("Yuki_Sekai")
        .child("World1")
        .child(userInfo.uid)
        .set(data)
        .whenComplete(() {
      print('Joined Yuki Sekai');
    }).catchError(
            (err) => print('Failed to update real time database: ' + err));
  }

  //update player position
  static Future updatePlayer(
      {required double x,
      required double y,
      required double velocityX,
      required double velocityY,
      required String state}) async {
    Map<String, dynamic> data = {
      'x': x,
      'y': y,
      'velocityX': velocityX,
      'velocityY': velocityY,
      'state': state,
    };
    final DatabaseReference fireBaseDB = FirebaseDatabase.instance.reference();
    fireBaseDB
        .child("Yuki_Sekai")
        .child("World1/${InitData.miyukiUser.uid}")
        .update(data)
        .whenComplete(() {})
        .catchError((err) => print(err));
  }

  //Delete player info
  static Future deletePlayer(String playerUid) async {
    final DatabaseReference fireBaseDB = FirebaseDatabase.instance.reference();
    fireBaseDB
        .child("Yuki_Sekai")
        .child("World1")
        .child(playerUid)
        .remove()
        .whenComplete(() {
      print('A Player Exit Yuki Sekai');
    }).catchError((err) => print(err));
  }

  static Future deleteAllPlayers() async {
    final DatabaseReference fireBaseDB = FirebaseDatabase.instance.reference();
    fireBaseDB.child("Yuki_Sekai").child("World1").remove().whenComplete(() {
      print('A Player Exit Yuki Sekai');
    }).catchError((err) => print(err));
  }
}
