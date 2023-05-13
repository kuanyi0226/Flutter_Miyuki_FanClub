import 'package:cloud_firestore/cloud_firestore.dart';

class MiyukiUser {
  String? name;
  String? email;
  bool? vip = false; //set by admin

  MiyukiUser({this.name, this.email, this.vip});

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'vip': vip,
      };

  static MiyukiUser fromJson(Map<String, dynamic> json) => MiyukiUser(
        name: json['name'],
        email: json['email'],
        vip: json['vip'],
      );
  //create user(only create once)
  static Future createUser(String name, String email) async {
    MiyukiUser user = MiyukiUser(name: name, email: email, vip: false);
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
      print('Can not find the user by email');
      return MiyukiUser(name: 'No User', email: 'No Data', vip: false);
    }
  }

  //Change name
  static Future editUserName(String name, MiyukiUser originalUserInfo) async {
    MiyukiUser newInfo = MiyukiUser(
        name: name, email: originalUserInfo.email, vip: originalUserInfo.vip);
    Map<String, dynamic> userData = newInfo.toJson();
    await FirebaseFirestore.instance
        .collection('miyukiusers')
        .doc(originalUserInfo.email)
        .set(userData);
  }
}
