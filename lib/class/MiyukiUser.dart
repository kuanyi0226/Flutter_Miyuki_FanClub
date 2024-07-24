import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project5_miyuki/materials/InitData.dart';

class MiyukiUser {
  String? uid;
  String? name;
  String? email;
  bool? vip = false; //set by admin
  int? coin = 0;
  String? imgUrl;

  MiyukiUser({required this.name, required this.email, this.vip, this.coin});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'vip': vip,
        'coin': coin,
      };

  static MiyukiUser fromJson(Map<String, dynamic> json) => MiyukiUser(
        name: json['name'],
        email: json['email'],
        vip: json['vip'],
        coin: json['coin'],
      );
  //create user(only create once)
  static Future createUser(
      {required String name, required String email}) async {
    MiyukiUser user =
        MiyukiUser(name: name, email: email, vip: false, coin: 1023);
    Map<String, dynamic> userData = user.toJson();
    await FirebaseFirestore.instance
        .collection('miyukiusers')
        .doc(email)
        .set(userData);
  }

  //search user
  static Future<MiyukiUser> readUser(String email) async {
    var document = await FirebaseFirestore.instance
        .collection('miyukiusers')
        .doc(email)
        .get();
    if (document.exists) {
      Map<String, dynamic>? data = document.data();
      return MiyukiUser.fromJson(data!);
    } else {
      User? user = await FirebaseAuth.instance.currentUser;
      print('Can not find the user by email');
      InitData.miyukiUser.coin = 1023;
      await MiyukiUser.createUser(name: 'No Name', email: user!.email!);
      return await MiyukiUser.readUser(user.email!);
    }
  }

  //Change name
  static Future editUserName(String name) async {
    await FirebaseFirestore.instance
        .collection('miyukiusers')
        .doc(InitData.miyukiUser.email)
        .update({'name': name});
  }
}
