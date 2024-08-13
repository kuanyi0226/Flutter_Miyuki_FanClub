import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:project5_miyuki/materials/InitData.dart';

import '../class/official/updateInfo.dart';

class OfficialService {
  //Update
  static Future<UpdateInfo> getUpdateInfo() async {
    var info = await FirebaseFirestore.instance
        .collection('official')
        .doc('update_package')
        .get();
    UpdateInfo result =
        UpdateInfo(version: info['version'], link: info['link']);
    return result;
  }

  //Daily Check-in
  static Future<bool> dailyCheckIn() async {
    bool successful = false;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyyMMdd').format(now);
    //Read
    DocumentSnapshot info = await FirebaseFirestore.instance
        .collection('official')
        .doc('daily_check_in')
        .get();
    try {
      List<dynamic> todaysUsers = info[formattedDate];
      //print('Sign in users: ' + todaysUsers.toString());
      if (todaysUsers.contains(InitData.miyukiUser.uid) == false) {
        todaysUsers.add(InitData.miyukiUser.uid);
        await FirebaseFirestore.instance
            .collection('official')
            .doc('daily_check_in')
            .update({formattedDate: todaysUsers});
        //update check-in days
        InitData.miyukiUser.checkInDays = InitData.miyukiUser.checkInDays! + 1;
        await FirebaseFirestore.instance
            .collection('miyukiusers')
            .doc(InitData.miyukiUser.email)
            .update({'checkInDays': InitData.miyukiUser.checkInDays});
        successful = true;
      }
    } catch (e) {
      //the field doesn't exist
      List<dynamic> todaysUsers = [];
      todaysUsers.add(InitData.miyukiUser.uid);
      await FirebaseFirestore.instance
          .collection('official')
          .doc('daily_check_in')
          .update({formattedDate: todaysUsers});
      //update check-in days
      InitData.miyukiUser.checkInDays = InitData.miyukiUser.checkInDays! + 1;
      await FirebaseFirestore.instance
          .collection('miyukiusers')
          .doc(InitData.miyukiUser.email)
          .update({'checkInDays': InitData.miyukiUser.checkInDays});
      successful = true;
    }
    InitData.checkinDate = formattedDate;
    return successful;
  }
}
