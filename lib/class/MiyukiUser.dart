import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MiyukiUser {
  String? name;
  String? email;
  bool? vip = false; //set by admin

  MiyukiUser({required this.name, required this.email, this.vip});

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
  static Future createUser(
      {required String name, required String email}) async {
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
  static Future editUserName(String name) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('miyukiusers')
        .doc(user!.email)
        .update({'name': name});
  }
}
