import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/MyDecoder.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/screens/yakai/yakai_songlist_page.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../songlist_page.dart';

import '../../widgets/VideoPlayerWidget.dart';
import '../../widgets/NetworkVideoPlayer.dart';
import '../../class/Concert.dart';

class YakaiPage extends StatefulWidget {
  @override
  State<YakaiPage> createState() => _PageState();
}

class _PageState extends State<YakaiPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text('夜会 Yakai'),
        ]),
      ),
      body: ListView.builder(
          itemCount: InitData.YAKAIS.length,
          itemBuilder: (context, index) {
            String curr_yakai_year = InitData.YAKAIS.elementAt(index);
            return ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => YakaiSonglistPage(
                        yakai_year: curr_yakai_year,
                      ))),
              leading: Image.network(
                'https://github.com/kuanyi0226/Yuki_DataBase/raw/main/Image/Yakai/${curr_yakai_year.substring(1)}_0/poster.jpg',
                scale: 2.5,
              ),
              title: Text(
                MyDecoder.yearToConcertName(curr_yakai_year),
                style: TextStyle(fontSize: 21),
              ),
              subtitle: Text(curr_yakai_year.substring(1)),
            );
          }));
}
