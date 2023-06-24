import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/screens/MyHomePage.dart';
import 'package:project5_miyuki/services/report_service.dart';

import '../class/Concert.dart';
import './songlist_page.dart';
import '../class/Song.dart';
import '../widgets/NetworkVideoPlayer.dart';

import '../class/MyDecoder.dart';
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
    if (lyricsList.elementAt(0) == '') {
      lyricsTexts.add(Text(
        'No Lyrics',
        style: TextStyle(fontSize: 18),
      ));
    } else {
      for (int i = 0; i < lyricsList.length; i++) {
        lyricsTexts.add(Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Text(
              lyricsList.elementAt(i),
              style: TextStyle(fontSize: 16),
            ),
          ),
        ));
      }
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

    final commentController = TextEditingController();
    commentController.text = '';
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Comment',
                style: TextStyle(color: theme_purple, fontSize: 20),
              ),
              content: TextField(
                controller: commentController,
                decoration: InputDecoration(hintText: 'Comment'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (commentController.text.length >= 15) {
                          final now = DateTime.now();
                          //newComment: uid + userName + sentTime + comment
                          String userName = (miyukiUser.vip == true)
                              ? ('❆' + miyukiUser.name!)
                              : miyukiUser.name!;
                          String newComment = user.uid +
                              '%%' +
                              userName +
                              '%%' +
                              '${now.timeZoneName}: ${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}' +
                              '%%' +
                              commentController.text;
                          Song.addComment(song!.name, newComment);

                          if (song!.comment!.elementAt(0) == '') {
                            //every song's comment was init as ''
                            song!.comment!.clear();
                          }
                          song!.comment!.add(newComment);
                          Navigator.of(context).pop();
                          const snackBar = SnackBar(
                              content: Text('Thanks for your comment~'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          const snackBar = SnackBar(
                              content: Text('Please Type More Than 15 words'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    child: Text(
                      'Add',
                      style: TextStyle(color: theme_purple, fontSize: 20),
                    )),
              ],
            ));
  }

  //delete comment
  Future _deleteComment(String deleteComment) async {
    final commentController = TextEditingController();
    commentController.text = '';
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Delete Comment',
                style: TextStyle(color: theme_purple, fontSize: 20),
              ),
              content: Text('Sure to delete this comment?'),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        //delete from firebase
                        Song.deleteComment(song!.name, deleteComment);
                        //delete from current display
                        for (int i = 0; i < song!.comment!.length; i++) {
                          if (song!.comment!.elementAt(i) == deleteComment) {
                            song!.comment!.removeAt(i); //delete comment
                            break;
                          }
                        }
                        //avoid error: don't let the list be empty
                        if (song!.comment!.isEmpty) {
                          song!.comment!.add('');
                        }
                        //finish
                        Navigator.of(context).pop();
                        const snackBar =
                            SnackBar(content: Text('Deleted a comment'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      });
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    )),
              ],
            ));
  }

  //report comment
  Future _reportComment(String reportComment) async {
    //user info
    User? user = FirebaseAuth.instance.currentUser;

    final reportController = TextEditingController();
    reportController.text = '';
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Report This Comment',
                style: TextStyle(color: theme_purple, fontSize: 20),
              ),
              content: TextField(
                controller: reportController,
                decoration:
                    InputDecoration(hintText: 'Describe this comment...'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (reportController.text.length >= 15) {
                          String reportString = 'Song Name: ' +
                              song!.name +
                              ';Comment context: ' +
                              reportComment +
                              ';Report Context: ' +
                              reportController.text;
                          ReportService.createReport(
                              sender: user!.uid,
                              type: 'Comment',
                              text: reportString);
                          Navigator.of(context).pop();
                          const snackBar = SnackBar(
                              content: Text('We have Received your report'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        } else {
                          const snackBar = SnackBar(
                              content: Text('Please Type More Than 15 words'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      });
                    },
                    child: Text(
                      'Report',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    )),
              ],
            ));
  }

  //switch the video
  Future _switchVideo(String concertYear) async {
    Concert? newConcert = await Concert.readConcert(concertYear);
    int newSongIndex = 0;
    if (newConcert != null) {
      for (int i = 0; i < newConcert.songs!.length; i++) {
        if (newConcert.songs!.elementAt(i).contains(song!.name)) {
          newSongIndex = i + 1;
          break;
        }
      }
    }
    print('Current Concert:' + newConcert.name);
    print('Current song index:' + newSongIndex.toString());

    //switch video
    Navigator.pop(context);
    //push without animation
    Navigator.push(
        context,
        PageRouteBuilder(
            transitionDuration: const Duration(seconds: 0),
            pageBuilder: (_, __, ___) => SongPage(
                concert: newConcert, song_index: newSongIndex, song: song)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(song!.name),
      ),
      body: Column(children: [
        (concert == null)
            ? Container(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : NetworkVideoPlayer(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Year
                                    Card(
                                      color: theme_dark_grey,
                                      child: Text(
                                        MyDecoder.yearToConcertYear(
                                            song!.live!.elementAt(index)),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    //Concert Name
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        MyDecoder.yearToConcertName(
                                            song!.live!.elementAt(index)),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          _switchVideo(
                                              song!.live!.elementAt(index));
                                        },
                                        icon: Icon(Icons.music_video))
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
                (song!.comment != null && song!.comment!.elementAt(0) != '')
                    ? Expanded(
                        child: ListView.builder(
                            itemCount: song!.comment!.length,
                            itemBuilder: ((context, index) {
                              User? curr_user =
                                  FirebaseAuth.instance.currentUser;
                              //0:uid,1:userName,2:date,3:comment
                              List<String> commentSplit =
                                  song!.comment!.elementAt(index).split('%%');
                              //shorten the name, avoid exceeding boundary
                              if (commentSplit[1].length > 13) {
                                commentSplit[1] =
                                    commentSplit[1].substring(0, 13) + '...';
                              }
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: ListTile(
                                      title: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          //User Name
                                          Container(
                                            child: Text(
                                              commentSplit.elementAt(1),
                                              style: (commentSplit
                                                          .elementAt(1)[0] ==
                                                      '❆')
                                                  ? TextStyle(
                                                      fontSize: 20,
                                                      color: theme_light_blue)
                                                  : TextStyle(fontSize: 20),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          //Sent Time
                                          Container(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Text(
                                                  commentSplit.elementAt(2),
                                                  style:
                                                      TextStyle(fontSize: 10)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      //Message Text
                                      subtitle: Text(
                                        commentSplit.elementAt(3),
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      ),
                                      trailing: (curr_user!.uid ==
                                              commentSplit[0])
                                          ? IconButton(
                                              onPressed: () async =>
                                                  _deleteComment(song!.comment!
                                                      .elementAt(index)),
                                              icon: Icon(Icons.delete))
                                          : IconButton(
                                              onPressed: () async =>
                                                  _reportComment(song!.comment!
                                                      .elementAt(index)),
                                              icon: Icon(Icons.report)),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              );
                            })),
                      )
                    : Text(
                        'No Comment',
                        style: TextStyle(fontSize: 18),
                      )
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
