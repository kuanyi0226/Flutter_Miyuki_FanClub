import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import '../services/string_service.dart';
import '../class/Song.dart';

import '../class/Concert.dart';
import '../materials/colors.dart';

import './song_page.dart';
import '../class/MyDecoder.dart';

class SonglistPage extends StatefulWidget {
  Concert? concert;
  String? concert_type;
  SonglistPage({this.concert, required this.concert_type});

  @override
  State<SonglistPage> createState() =>
      _PageState(concert: concert, concert_type: concert_type);
}

class _PageState extends State<SonglistPage> {
  Concert? concert;
  String? concert_type;
  _PageState({this.concert, required this.concert_type});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("コンサート Concert"),
          ]),
        ),
        body: Column(
          children: [
            Container(
              height: 125,
              //Top display Card
              child: Card(
                color: theme_dark_grey,
                elevation: 15.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Image
                        Container(
                          width: 85,
                          height: 85,
                          child: FastCachedImage(
                            url:
                                'https://raw.githubusercontent.com//kuanyi0226/Yuki_DataBase/main/Image/${concert_type}/${concert!.year}_${concert!.year_index}/poster.png',
                            // errorBuilder: (context, exception, stacktrace) {
                            //   return Text(stacktrace.toString());
                            // },
                            fit: BoxFit.contain,
                          ),
                        ),
                        //Text(Introductions)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, bottom: 5),
                          child: Center(
                            child: SizedBox(
                              width: 220,
                              child: Text(
                                "${concert!.year}年\n${concert!.name}",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
            //Songs Lists
            Expanded(
              child: ListView.builder(
                  itemCount: concert!.songs!.length,
                  itemBuilder: (BuildContext context, int index) {
                    String songName = MyDecoder.songNameToPure(
                        concert!.songs!.elementAt(index));
                    //ListTile
                    return (songName.trim().startsWith('[text]'))
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 5, bottom: 5),
                            child: Text(
                              songName.trim().substring(6),
                              style: TextStyle(color: theme_purple),
                            ),
                          )
                        : ListTile(
                            //leading: const Icon(Icons.music_note),
                            title: Text(StringService.dashToSpace(
                                concert!.songs![index])),
                            visualDensity: VisualDensity(vertical: -2),
                            onTap: () async {
                              Song curr_song = await Song.readSong(
                                  songName); //search the song
                              print('$index ${songName}');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SongPage(
                                        concert: concert,
                                        song_index: index + 1,
                                        song: Song(
                                          name: songName,
                                          author: (curr_song.author != '')
                                              ? curr_song.author
                                              : '中島みゆき',
                                          composer: (curr_song.composer != '')
                                              ? curr_song.composer
                                              : '中島みゆき',
                                          live: curr_song.live,
                                          lyrics_jp: curr_song.lyrics_jp,
                                          lyrics_cn: curr_song.lyrics_cn,
                                          lyrics_en: curr_song.lyrics_en,
                                          comment: curr_song.comment,
                                          review_cn: curr_song.review_cn,
                                          review_en: curr_song.review_en,
                                        ),
                                      )));
                            },
                          );
                  }),
            ),
          ],
        ),
      );
}
