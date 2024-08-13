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
  List? collections;
  int? checkInDays = 0;

  MiyukiUser(
      {required this.name,
      required this.email,
      this.vip,
      this.coin,
      this.collections,
      this.checkInDays}) {
    initCollections(this);
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'vip': vip,
        'coin': coin,
        'collections': collections,
        'checkInDays': checkInDays,
      };

  static MiyukiUser fromJson(Map<String, dynamic> json) => MiyukiUser(
        name: json['name'],
        email: json['email'],
        vip: json['vip'],
        coin: json['coin'],
        collections: json['collections'],
        checkInDays: json['checkInDays'],
      );
  //create user(only create once)
  static Future createUser(
      {required String name, required String email}) async {
    MiyukiUser user = MiyukiUser(
        name: name, email: email, vip: false, coin: 1023, checkInDays: 0);
    initCollections(user);
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
      MiyukiUser curr_user = MiyukiUser.fromJson(data!);
      initCollections(curr_user);
      initCheckInDays(curr_user);
      return curr_user;
    } else {
      User? user = await FirebaseAuth.instance.currentUser;
      print('Can not find the user by email');
      InitData.miyukiUser.coin = 1023;
      await MiyukiUser.createUser(name: 'No Name', email: user!.email!);
      return await MiyukiUser.readUser(user.email!);
    }
  }

  //Update name
  static Future editUserName(String name) async {
    await FirebaseFirestore.instance
        .collection('miyukiusers')
        .doc(InitData.miyukiUser.email)
        .update({'name': name});
  }

  //Update collections
  static Future updateCollections(List new_collections) async {
    await FirebaseFirestore.instance
        .collection('miyukiusers')
        .doc(InitData.miyukiUser.email)
        .update({'collections': new_collections});
  }

  //make sure the collections are not null
  static void initCollections(MiyukiUser user) {
    if (user.collections == null) {
      user.collections = ['[garment][current]y2006_pink_dress'];
    }
  }

  //make sure the checkInDays are not null
  static void initCheckInDays(MiyukiUser user) {
    if (user.checkInDays == null) {
      user.checkInDays = 0;
    }
  }
}
