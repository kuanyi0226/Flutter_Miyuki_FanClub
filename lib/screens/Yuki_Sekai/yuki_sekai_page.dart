import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/Yuki_Sekai/PlayerInfo.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/YukiSekai.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class YukiSekaiPage extends StatefulWidget {
  const YukiSekaiPage({super.key});

  @override
  State<YukiSekaiPage> createState() => _YukiSekaiPageState();
}

class _YukiSekaiPageState extends State<YukiSekaiPage> {
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

            InitData.yukiSekai = YukiSekai();
            InitData.playersInfo.clear();
            PlayerInfo.deletePlayer(InitData.miyukiUser.uid!);
          },
        ),
        title: Text(AppLocalizations.of(context)!.mirage_hotel),
        actions: [
          Icon(Icons.light_mode),
          Switch(
              value: InitData.turnOnEffect,
              onChanged: (val) {
                setState(() {
                  InitData.turnOnEffect = !InitData.turnOnEffect;
                });
              }),
          SizedBox(width: 25),
        ],
      ),
      body: Stack(
        children: [
          GameWidget(game: InitData.yukiSekai),
        ],
      ),
    );
  }
}
