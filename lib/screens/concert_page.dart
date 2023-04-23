import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widgets/VideoPlayerWidget.dart';
import '../widgets/NetworkVideoPlayer.dart';

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
            IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          ]),
        ),
        body: NetworkVideoPlayer(),
      );
}
