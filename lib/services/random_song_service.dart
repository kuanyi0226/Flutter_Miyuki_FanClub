import 'package:project5_miyuki/materials/InitData.dart';

class RandomSongService {
  static void selectSong() async {
    //print('Random Song Service_song list length: ' + InitData.allSongs.length.toString());
    final now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    int weekday = now.weekday;
    if (InitData.allSongs.length > 0) {
      // print('Song Number(Random Song Service): ' +
      //     InitData.allSongs.length.toString());
      int mapping =
          (((year + month) * day * 13 + weekday * 23 + (7 - weekday)) %
                  InitData.allSongs.length)
              .round();
      InitData.todaySong = InitData.allSongs[mapping];
    } else {
      InitData.todaySong = 'No Song';
    }
  }
}
