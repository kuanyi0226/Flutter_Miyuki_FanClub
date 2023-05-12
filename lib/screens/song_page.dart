import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../class/Concert.dart';
import './songlist_page.dart';
import '../class/Song.dart';
import '../widgets/NetworkVideoPlayer.dart';

import '../class/Decoder.dart';
import '../materials/colors.dart';

class SongPage extends StatefulWidget {
  Song? song;
  Concert? concert;
  int? song_index;
  SongPage({
    this.song,
    this.concert,
    this.song_index,
  });

  @override
  State<SongPage> createState() => _SongPageState(
        song: song,
        concert: concert,
        song_index: song_index,
      );
}

class _SongPageState extends State<SongPage> {
  Song? song;
  Concert? concert;
  int? song_index;
  _SongPageState({
    this.song,
    this.concert,
    this.song_index,
  });

  //bottom navigation
  int _curr_index = 0;

  void _onTap(int index) {
    setState(() {
      _curr_index = index;
    });
    //jump
    if (_curr_index == 1) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song!.name),
      ),
      body: Column(children: [
        NetworkVideoPlayer(
          concert: concert,
          index: song_index,
        ),
        // Text: Live
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'Live: ',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
        // Live list
        (song!.live != null)
            ? Expanded(
                child: ListView.builder(
                    itemCount: song!.live!.length,
                    itemBuilder: ((context, index) {
                      return Container(
                        height: 60,
                        child: GestureDetector(
                          onTap: () async {
                            //Read the concert tapped
                            Concert tap_concert = await Concert.readConcert(
                                song!.live!.elementAt(index));
                            //Jump to the correspond concert songlist page
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SonglistPage(
                                      concert: tap_concert,
                                      concert_type: 'Concert',
                                    )));
                          },
                          child: Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Row(
                              children: [
                                //Year
                                Card(
                                  color: theme_grey,
                                  child: Text(
                                    Decoder.yearToConcertYear(
                                        song!.live!.elementAt(index)),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                //Concert Name
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    Decoder.yearToConcertName(
                                        song!.live!.elementAt(index)),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    })),
              )
            : CircularProgressIndicator(),
        // Lyrics
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Text(
                'Lyrics: ',
                style: TextStyle(fontSize: 25),
              ),
            ),
          ),
        ),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  song!.lyrics_jp!,
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ],
        ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _curr_index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.lyrics), label: '歌詞 Lyrics'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム Home'),
        ],
        onTap: (idx) => _onTap(idx),
      ),
    );
  }
}
