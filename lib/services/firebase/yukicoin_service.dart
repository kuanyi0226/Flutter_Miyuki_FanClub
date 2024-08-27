import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/materials/InitData.dart';

class YukicoinService {
  //add coins
  static Future addCoins(int amount) async {
    int currCoins = InitData.miyukiUser.coin!;
    String curr_email = InitData.miyukiUser.email!;
    int newCoins;

    if (currCoins != null && amount != 0 && curr_email != null) {
      newCoins = currCoins + amount;
      try {
        InitData.miyukiUser.coin = newCoins;
        await FirebaseFirestore.instance
            .collection('miyukiusers')
            .doc(curr_email)
            .update({'coin': newCoins});
      } catch (e) {}

      print('current yuki coins: \$' + InitData.miyukiUser.coin.toString());
    }
  }
}
