import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project5_miyuki/class/Concert.dart';
import 'package:project5_miyuki/class/MyDecoder.dart';
import 'package:project5_miyuki/class/Song.dart';
import 'package:project5_miyuki/materials/colors.dart';
import 'package:project5_miyuki/screens/song_page.dart';

import '../../services/ad_mob_service.dart';

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

  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createBannerAd();
    // get the certain yakai song list
    songlist = MyDecoder.getYakaiSongList(yakai: yakai_year);
    yakaiName = MyDecoder.yearToConcertName(yakai_year);
    if (yakaiName.length > 16) {
      yakaiName = yakaiName.substring(0, 16) + '...';
    }
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      //adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
    setState(() {
      _bannerAdLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("夜会 Yakai"),
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
                        Image.network(
                          'https://github.com/kuanyi0226/Yuki_DataBase/raw/main/Image/Yakai/${yakai_year.substring(1)}_0/poster.jpg',
                          fit: BoxFit.contain,
                        ),
                        //Text(Introductions)
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 10, top: 5, bottom: 5),
                          child: Center(
                            child: Text(
                              "${yakai_year.substring(1)}年\n${yakaiName}",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
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
                  itemCount: songlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    //ListTile
                    return ListTile(
                      //leading: const Icon(Icons.music_note),
                      title: Text(
                        songlist[index],
                        style: TextStyle(
                            color: (songlist[index].substring(0, 2) == '//')
                                ? theme_light_blue //poem
                                : Colors.white),
                      ),
                      onTap: () async {
                        String songName =
                            MyDecoder.songNameToPure(songlist.elementAt(index));
                        Song curr_song =
                            await Song.readSong(songName); //search the song
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
                    );
                  }),
            ),
          ],
        ),
        bottomNavigationBar: (_bannerAd == null || !_bannerAdLoaded)
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _bannerAd!),
              ),
      );
}
