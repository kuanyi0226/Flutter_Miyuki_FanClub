import 'package:project5_miyuki/widgets/ClubCachedImage.dart';
import 'package:project5_miyuki/widgets/web_page_shell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/string_service.dart';
import '../../class/Concert.dart';
import '../../class/MyDecoder.dart';
import '../../class/Song.dart';
import '../../materials/colors.dart';
import '../../screens/song_page.dart';

class YakaiSonglistPage extends StatefulWidget {
  String yakai_year;
  YakaiSonglistPage({required this.yakai_year});
  @override
  State<YakaiSonglistPage> createState() =>
      _YakaiSonglistPageState(yakai_year: yakai_year);
}

class _YakaiSonglistPageState extends State<YakaiSonglistPage> {
  String yakai_year;
  String yakaiName = '';
  List<String> songlist = [];
  _YakaiSonglistPageState({required this.yakai_year});

  @override
  void initState() {
    super.initState();
    // get the certain yakai song list
    songlist = MyDecoder.getYakaiSongList(yakai: yakai_year);
    yakaiName = MyDecoder.yearToConcertName(yakai_year);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("夜会 Yakai"),
          ]),
        ),
        body: WebPageShell(
          maxWidth: 1100,
          child: Column(
            children: [
            Container(
              height: kIsWeb ? 160 : 125,
              //Top display Card
              child: Card(
                color: kIsWeb ? null : theme_dark_grey,
                elevation: kIsWeb ? 0 : 15.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //Image
                        Container(
                          width: kIsWeb ? 126 : 85,
                          height: kIsWeb ? 126 : 85,
                          child: ClubCachedImage(
                            url:
                                'https://raw.githubusercontent.com//kuanyi0226/Yuki_DataBase/main/Image/Yakai/${yakai_year.substring(1)}_0/poster.jpg',
                            // errorBuilder: (context, exception, stacktrace) {
                            //   return Text(stacktrace.toString());
                            // },
                            fit: BoxFit.contain,
                          ),
                        ),
                        //Text(Introductions)
                        Expanded(
                          child: Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, bottom: 5),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                "${yakai_year.substring(1)}年\n${yakaiName}",
                                style: kIsWeb
                                    ? Theme.of(context).textTheme.titleLarge
                                    : TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                            ),
                          ),
                        )),
                      ],
                    )),
              ),
            ),
            //Songs Lists
            Expanded(
              child: ListView.builder(
                  itemCount: songlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    //ListTile
                    return (songlist[index].startsWith('[text]'))
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, top: 3, bottom: 3),
                            child: Text(
                              songlist[index].trim().substring(6),
                              style: TextStyle(color: theme_purple),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: kIsWeb ? 4 : 0,
                            ),
                            child: ListTile(
                            tileColor: kIsWeb
                                ? Theme.of(context).colorScheme.surface
                                : null,
                            //leading: const Icon(Icons.music_note),
                            title: Text(
                              (songlist[index].contains('[song]'))
                                  ? StringService.dashToSpace(songlist[index]
                                      .substring(
                                          0, songlist[index].indexOf('[song]')))
                                  : StringService.dashToSpace(songlist[index]),
                              style: TextStyle(
                                  color:
                                      (songlist[index].substring(0, 2) == '//')
                                          ? theme_light_blue //poem
                                          : Colors.white),
                            ),
                            visualDensity: VisualDensity(vertical: -2),
                            onTap: () async {
                              String songName = MyDecoder.songNameToPure(
                                  songlist.elementAt(index));
                              Song curr_song = await Song.readSong(
                                  songName); //search the song
                              print('$index ${songName}');
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SongPage(
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
                                          ratings: curr_song.ratings,
                                        ),
                                        song_index: index + 1,
                                        concert: Concert(
                                          name: yakaiName,
                                          year: yakai_year,
                                          year_index: '0',
                                          songs: MyDecoder.getYakaiSongList(
                                              yakai: yakai_year),
                                        ),
                                      )));
                            },
                          ));
                  }),
            ),
            ],
          ),
        ),
      );
}
