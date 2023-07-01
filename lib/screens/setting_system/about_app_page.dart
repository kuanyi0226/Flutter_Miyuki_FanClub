import 'package:flutter/material.dart';
import 'package:project5_miyuki/materials/MyText.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('基本データ\nAbout App')),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              //What is the Privacy Policy
              Text(
                '1. About ${APPNAME_JP}(${APPNAME_EN})',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                '${APPNAME_EN} is an APP to gather all the 中島みゆき fans in the world holding by an "Non-official" fan club in TW.(You can also contact me via Instagram:@miyukisama.fans.club).\n\n' +
                    'Everyone can share their thoughts about any of her songs with other fans. Let\'s make this community greater! Let more people know 中島みゆきさん. ',
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 20),
              //What information do we collect?
              Text(
                '2. About 中島みゆき(Nakajima Miyuki)',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Miyuki Nakajima (中島 みゆき, Nakajima Miyuki)(born February 23, 1952, Sapporo, Hokkaidō, Japan)is a Japanese singer-songwriter and radio personality. She has released 44 studio albums, 46 singles, 6 live albums and multiple compilations as of January 2020. Her sales have been estimated at more than 21 million copies.' +
                    'In the mid-1970s, Nakajima signed to Canyon Records and launched her recording career with her debut single, "Azami Jō no Lullaby" (アザミ嬢のララバイ). Rising to fame with the hit "The Parting Song (Wakareuta)", released in 1977, she has since seen a successful career as a singer-songwriter, primarily in the early 1980s. Four of her singles have sold more than one million copies in the last two decades, including "Earthly Stars (Unsung Heroes)", a theme song for the Japanese television documentary series Project X.' +
                    'Nakajima performed in experimental theater ("Yakai") every year-end from 1989 through 2019. The idiosyncratic acts featured scripts and songs she wrote, and have continued irregularly in recent years.' +
                    'In addition to her work as a solo artist, Nakajima has written over 90 compositions for numerous other singers, and has produced several chart-toppers. Many cover versions of her songs have been performed by Asian (particularly Taiwan and Hong Kong) singers. She is the only musician to have participated in the National Language Council of Japan.\n\n',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
        ));
  }
}
