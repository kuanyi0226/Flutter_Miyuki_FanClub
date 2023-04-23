import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widgets/VideoPlayerWidget.dart';

class NetworkVideoPlayer extends StatefulWidget {
  String? category;
  NetworkVideoPlayer({this.category});

  @override
  State<NetworkVideoPlayer> createState() => _PageState();
}

class _PageState extends State<NetworkVideoPlayer> {
  VideoPlayerController? controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.network(
        'https://github.com/kuanyi0226/Nakajima_Miyuki_DataBase/raw/main/Video/Concert/1978_1/13_0.mp4')
      ..addListener(() => setState(() {}))
      ..setLooping(true)
      ..initialize().then((_) => controller!.play());
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.center,
        child: Column(children: [
          VideoPlayerWidget(controller: controller),
        ]),
      );
}
