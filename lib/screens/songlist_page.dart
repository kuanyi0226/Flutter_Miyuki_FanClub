import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/VideoPlayerWidget.dart';
import '../widgets/NetworkVideoPlayer.dart';
import '../class/Concert.dart';

class SonglistPage extends StatefulWidget {
  Concert? concert;
  SonglistPage({this.concert});

  @override
  State<SonglistPage> createState() => _PageState(concert: concert);
}

class _PageState extends State<SonglistPage> {
  Concert? concert;
  _PageState({this.concert});

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text("${concert!.year}年 ${concert!.name}"),
        ]),
      ),
      body: /*NetworkVideoPlayer(),*/ Column(
        children: [
          SizedBox(
            height: 150,
            child: Card(
              elevation: 15.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: ListTile(
                leading: Image.network(
                    'https://github.com/kuanyi0226/Nakajima_Miyuki_DataBase/raw/main/Image/Concert/${concert!.year}_${concert!.year_index}/poster.png'),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: concert!.songs!.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    leading: const Icon(Icons.music_note),
                    title: Text(concert!.songs![index]),
                    onTap: () {
                      showAlertDialog(concert!, context);
                    },
                  );
                }),
          ),
        ],
      ));
}

// Show AlertDialog
showAlertDialog(Concert concert, BuildContext context) {
  // Init
  AlertDialog dialog = AlertDialog(
    title: Text(
      "${concert.year}年 ${concert.name}",
      style: TextStyle(fontSize: 15),
    ),
    actions: [
      NetworkVideoPlayer() /*Play the correspond video*/,
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
