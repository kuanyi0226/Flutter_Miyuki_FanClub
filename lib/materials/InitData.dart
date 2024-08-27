import 'package:project5_miyuki/class/Yuki_Sekai/PlayerInfo.dart';

import '../class/Concert.dart';
import '../class/MiyukiUser.dart';

class InitData {
  static MiyukiUser miyukiUser =
      MiyukiUser(name: 'No Name', email: 'No data', vip: false);
  static String todaySong = 'No Song';
  //static YukiSekai yukiSekai = YukiSekai();
  static String curr_worldName = 'y2006';
  static String curr_garment = 'y2006_pink_dress';
  static bool isInSekai = false;
  static List<PlayerInfo> playersInfo = [];
  static bool turnOnEffect = true;
  static String checkinDate = '';
  static List<Concert> concertList = [];

  //const
  static List<String> YAKAIS = [
    'y1989',
    'y1990',
    'y1991',
    'y1992',
    'y1993',
    'y1994',
    'y1995',
    'y1996',
    'y1997',
    'y1998',
    'y2000',
    'y2002',
    'y2004',
    'y2006',
    'y2008',
    'y2009',
    'y2011',
    'y2013',
    'y2014',
    'y2016',
    'y2017',
    'y2019',
  ];
  static List<String> allSongs = [];
}
