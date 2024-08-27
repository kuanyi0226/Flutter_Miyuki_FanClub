import 'package:firebase_auth/firebase_auth.dart';

import '../class/MiyukiUser.dart';
import '../materials/InitData.dart';
import 'firebase/remote_config_service.dart';

class InitDataService {
  static Future<bool> checkInit() async {
    bool needSetState = false;
    if (InitData.allSongs.isEmpty || InitData.allSongs == null) {
      print('init data for: all songs');
      InitData.allSongs = await RemoteConfigService().fetchAllSongs();
      needSetState = true;
    } else if (InitData.miyukiUser.email == 'No data') {
      print('init data for: MiyukiUser');
      await readMiyukiUser();
      needSetState = true;
    }

    return needSetState;
  }

  static Future<MiyukiUser> readMiyukiUser() async {
    User? user;
    String? userEmail;
    user = await FirebaseAuth.instance.currentUser;
    userEmail = user!.email;
    InitData.miyukiUser = await MiyukiUser.readUser(userEmail!);
    InitData.miyukiUser.uid = user.uid;
    InitData.miyukiUser.imgUrl = user.photoURL;
    print('welcome ${InitData.miyukiUser.name} ${user.uid}');

    //init current garment
    for (String collection in InitData.miyukiUser.collections!) {
      if (collection.startsWith('[garment]')) {
        if (collection.contains('[current]')) {
          InitData.curr_garment =
              collection.replaceFirst('[garment][current]', '');
        }
      }
    }

    return InitData.miyukiUser;
  }
}
