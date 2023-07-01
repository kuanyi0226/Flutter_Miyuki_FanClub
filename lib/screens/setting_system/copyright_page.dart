import 'package:flutter/material.dart';
import 'package:project5_miyuki/materials/MyText.dart';

class CopyrightPage extends StatelessWidget {
  const CopyrightPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('著作権 Copyright')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Text(
                'About copyright of this app',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Edited June 27, 2023\n\n' +
                    'TW miyukisama.fans.club has all the copyright of this app(${APPNAME_EN}) for the designing.\n' +
                    '※The only legal currency(Yuki Coin) in this app will only be used to buy some function in this app instead of music or photos of Yamaha Music Entertainment.' +
                    ' We only offer this platform to discuss みゆきさん with others.(The vip in this app can not be bought by Yuki Coin or Cash)\n\n'
                        'Because we are "Not" official fan club, all the song, lyrics, photos of 中島みゆきさん and her masterpieces all belong to Yamaha Music Entertainment Holdings, Inc.\n' +
                    'If there is any unacceptable illegal copyright infringement, please inform us.\n\n(All the profit-making behaviors will only be based on the App Functions instead of 中島みゆき\'s music.\n' +
                    'That is, the ads in this app is only to sustain this platform.)',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ));
  }
}
