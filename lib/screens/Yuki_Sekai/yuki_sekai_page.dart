import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/Yuki_Sekai/PlayerInfo.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/Yuki_Sekai/YukiSekai.dart';

class YukiSekaiPage extends StatefulWidget {
  late final String title;
  YukiSekaiPage({required this.title});

  @override
  State<YukiSekaiPage> createState() => _YukiSekaiPageState(title: title);
}

class _YukiSekaiPageState extends State<YukiSekaiPage> {
  late final String title;
  _YukiSekaiPageState({required this.title});

  @override
  void initState() {
    Flame.device.fullScreen();
    Flame.device.setLandscape();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            //Quit Yuki Sekai
            InitData.isInSekai = false;
            Navigator.of(context).popUntil((route) => route.isFirst);
            Flame.device.setPortrait();

            //InitData.yukiSekai = YukiSekai();
            InitData.playersInfo.clear();
            PlayerInfo.deletePlayer(InitData.miyukiUser.uid!);
          },
        ),
        title: Text(title),
        actions: [
          Icon(Icons.light),
          LightSwitch(),
          SizedBox(width: 25),
        ],
      ),
      body: Stack(
        children: [
          GameWidget(game: YukiSekai()),
        ],
      ),
    );
  }
}

//separate the button in case that setState method rebuild YukiSekai
class LightSwitch extends StatefulWidget {
  const LightSwitch({super.key});

  @override
  State<LightSwitch> createState() => _LightSwitchState();
}

class _LightSwitchState extends State<LightSwitch> {
  @override
  Widget build(BuildContext context) {
    return Switch(
        value: InitData.turnOnEffect,
        onChanged: (val) {
          setState(() {
            InitData.turnOnEffect = !InitData.turnOnEffect;
          });
        });
  }
}
