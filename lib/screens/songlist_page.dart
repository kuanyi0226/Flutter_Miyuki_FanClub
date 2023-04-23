import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/VideoPlayerWidget.dart';
import '../widgets/NetworkVideoPlayer.dart';
import '../class/Concert.dart';

class ConcertPage extends StatefulWidget {
  String? category;
  ConcertPage({this.category});

  @override
  State<ConcertPage> createState() => _PageState();
}

class _PageState extends State<ConcertPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text('コンサート Concert'),
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

Stream<List<Concert>> readConcerts() => FirebaseFirestore.instance
    .collection('concerts')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Concert.fromJson(doc.data())).toList());

Widget buildConcert(Concert concert, BuildContext context) => ListTile(
      onTap: () => showAlertDialog(concert, context),
      leading: Image.network(
        'https://github.com/kuanyi0226/Nakajima_Miyuki_DataBase/raw/main/Image/Concert/${concert.year}_${concert.year_index}/poster.png',
        scale: 2.5,
      ),
      title: Text(
        concert.name,
        style: TextStyle(fontSize: 21),
      ),
      subtitle: Text(concert.year),
    );

// Show AlertDialog
showAlertDialog(Concert concert, BuildContext context) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text(
      "${concert.year}年 ${concert.name}",
      style: TextStyle(fontSize: 15),
    ),
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
