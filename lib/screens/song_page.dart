import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/screens/MyHomePage.dart';

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
  List<String> lyricsList = [' '];
  List<Widget> lyricsTexts = [];

  _SongPageState({
    this.song,
    this.concert,
    this.song_index,
  });

  @override
  void initState() {
    super.initState();
    lyricsList = song!.lyrics_jp!.split('%');
    for (int i = 0; i < lyricsList.length; i++) {
      lyricsTexts.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: Text(
            lyricsList.elementAt(i),
            style: TextStyle(fontSize: 18),
          ),
        ),
      ));
    }
  }

  //bottom navigation
  int _curr_index = 0;

  void _onTap(int index) {
    setState(() {
      _curr_index = index;
    });
    //back to home
    if (_curr_index == 3) {
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

  //add comment
  Future _createComment() async {
    //user info
    User? user = FirebaseAuth.instance.currentUser;
    MiyukiUser miyukiUser = await MiyukiUser.readUser(user!.email!);

    final nameController = TextEditingController();
    nameController.text = '';
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Comment',
                style: TextStyle(color: theme_purple, fontSize: 20),
              ),
              content: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Comment'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        String newComment = user.uid +
                            '%%' +
                            miyukiUser.name! +
                            '%%' +
                            nameController.text;
                        Song.addComment(song!.name, newComment);
                        song!.comment!.add(newComment);
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: theme_purple, fontSize: 20),
                    )),
              ],
            ));
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
        SizedBox(height: 20),
        (_curr_index == 0)
            ? //Live List
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
                                      color: theme_dark_grey,
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
                : CircularProgressIndicator()
            : (_curr_index == 1)
                ? //Lyrics
                Expanded(
                    child: SingleChildScrollView(
                      child: Column(children: lyricsTexts),
                    ),
                  )
                : // Comment
                (song!.comment != null)
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: song!.comment!.length,
                            itemBuilder: ((context, index) {
                              return Container(
                                height: 60,
                                child: GestureDetector(
                                  onTap: () {
                                    //TODO: report system
                                  },
                                  child: Card(
                                    elevation: 10,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Row(
                                      children: [
                                        //Comment
                                        Card(
                                          color: theme_dark_grey,
                                          child: Text(
                                            song!.comment!.elementAt(index),
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        ),
                                        //User Name
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            song!.comment!.elementAt(index),
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
                    : Text('No Comment')
      ]),
      //Add Comment Button
      floatingActionButton: Visibility(
        visible: _curr_index == 2,
        child: FloatingActionButton(
          onPressed: _createComment,
          child: Icon(Icons.add),
        ),
      ),
      //Bottom Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _curr_index,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Lives'),
          BottomNavigationBarItem(icon: Icon(Icons.lyrics), label: 'Lyrics'),
          BottomNavigationBarItem(icon: Icon(Icons.comment), label: 'Comment'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        ],
        onTap: (idx) => _onTap(idx),
      ),
    );
  }
}
