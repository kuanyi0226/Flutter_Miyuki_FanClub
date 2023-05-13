import 'package:cloud_firestore/cloud_firestore.dart';

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
}
