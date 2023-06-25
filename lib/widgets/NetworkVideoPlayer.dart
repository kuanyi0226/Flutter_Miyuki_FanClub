import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widgets/VideoPlayerWidget.dart';
import '../class/Concert.dart';

class NetworkVideoPlayer extends StatefulWidget {
  Concert? concert;
  int? index;
  NetworkVideoPlayer({this.concert, this.index});

  @override
  State<NetworkVideoPlayer> createState() =>
      _PageState(concert: concert, index: index);
}

class _PageState extends State<NetworkVideoPlayer> {
  Concert? concert;
  int? index;
  VideoPlayerController? controller;
  _PageState({this.concert, this.index});

  @override
  void initState() {
    super.initState();
    print(
        'Video-current concert year: ${concert!.year}_${concert!.year_index}; song: ${index}');
    //Video Url
    String videoUrl = '';
    if (concert!.year[0] != 'y') {
      videoUrl =
          'https://github.com/kuanyi0226/Nakajima_Miyuki_DataBase/raw/main/Video/Concert/${concert!.year}_${concert!.year_index}/${index}_0.mp4';
    } else {
      videoUrl =
          'https://github.com/kuanyi0226/Nakajima_Miyuki_DataBase/raw/main/Video/Yakai/${concert!.year.substring(1)}_${concert!.year_index}/${index}_0.mp4';
    }
    controller = VideoPlayerController.network(videoUrl)
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
