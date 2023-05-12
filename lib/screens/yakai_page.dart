import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './songlist_page.dart';

import '../widgets/VideoPlayerWidget.dart';
import '../widgets/NetworkVideoPlayer.dart';
import '../class/Concert.dart';

class YakaiPage extends StatefulWidget {
  String? category;
  YakaiPage({this.category});

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
        body: /*NetworkVideoPlayer(),*/ StreamBuilder<List<Concert>>(
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong!');
            } else if (snapshot.hasData) {
              final concerts = snapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: concerts
                          .map((concert) => buildConcert(concert, context))
                          .toList(),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          stream: readConcerts(),
        ),
      );
}

Stream<List<Concert>> readConcerts() =>
    FirebaseFirestore.instance.collection('yakai').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Concert.fromJson(doc.data())).toList());

Widget buildConcert(Concert concert, BuildContext context) => ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SonglistPage(
                concert: concert,
                concert_type: "Yakai",
              ))),
      leading: Image.network(
        'https://github.com/kuanyi0226/Yuki_DataBase/raw/main/Image/Yakai/${concert.year}_0/poster.jpg',
        scale: 2.5,
      ),
      title: Text(
        concert.name,
        style: TextStyle(fontSize: 21),
      ),
      subtitle: Text(concert.year),
    );

// Show AlertDialog
showAlertDialog(BuildContext context) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text("AlertDialog component"),
    actions: [
      NetworkVideoPlayer(),
      ElevatedButton(
          child: Text("Cancel"),
          onPressed: () {
            Navigator.pop(context);
          }),
    ],
  );

  // Show the dialog
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}
