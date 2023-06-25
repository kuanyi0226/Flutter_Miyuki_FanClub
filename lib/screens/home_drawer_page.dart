import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';

import './concert_page.dart';
import './setting_system/settings_page.dart';
import 'yakai/yakai_page.dart';

import '../class/Message.dart';
import '../materials/text.dart';
import '../materials/colors.dart';

import '../services/message_service.dart';

class HomeDrawerPage extends StatefulWidget {
  User? user;
  GlobalKey<ScaffoldState> scaffoldKey;
  HomeDrawerPage({super.key, required this.scaffoldKey, required this.user});

  @override
  State<HomeDrawerPage> createState() => _HomeDrawerPageState(
        scaffoldKey: scaffoldKey,
        user: user,
      );
}

class _HomeDrawerPageState extends State<HomeDrawerPage> {
  User? user;
  GlobalKey<ScaffoldState> scaffoldKey;

  _HomeDrawerPageState({required this.user, required this.scaffoldKey});

  //check to sign out
  Future _signOutCheck() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Ready to log out?',
                style: TextStyle(color: theme_purple, fontSize: 25),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      _signOut();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'ログアウト Sign Out',
                      style: TextStyle(color: theme_purple, fontSize: 15),
                    )),
              ],
            ));
  }

  //sign out
  void _signOut() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: theme_dark_grey),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  'https://github.com/kuanyi0226/Nakajima_Miyuki_DataBase/raw/main/Image/Album/44/album44_cover.jpg'),
            ),
            accountName:
                Text(InitData.miyukiUser.name!, style: TextStyle(fontSize: 18)),
            accountEmail: Text(user!.email!, style: TextStyle(fontSize: 18)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 5),
            child: Text('中島みゆき非公式ファンクラブ'),
          ),
          ListTile(
            leading: Icon(Icons.disc_full),
            title: Text('作品 Discography'),
            onTap: () {
              scaffoldKey.currentState!.openEndDrawer(); //close drawler
            },
          ),
          ListTile(
              leading: Icon(Icons.music_note_outlined),
              title: Text('コンサート Concert'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ConcertPage()));
                scaffoldKey.currentState!.openEndDrawer(); //close drawer
              }),
          ListTile(
              leading: Icon(Icons.nightlife),
              title: Text('夜会 Yakai'),
              onTap: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => YakaiPage()));
                scaffoldKey.currentState!.openEndDrawer(); //close drawer
              }),
          //Websites
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text('Websites'),
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('中島みゆき研究所 Miyuki Lab'),
            onTap: () => _launchURL('http', 'miyuki-lab.jp', ''),
          ),
          ListTile(
            leading: Icon(Icons.lyrics),
            title: Text('織歌蟲 Lyrics'),
            onTap: () => _launchURL('https', 'orikamushi.netlify.app',
                '/miyuki_zone/miyukiframeset'),
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('中島みゆき公式 Official'),
            onTap: () => _launchURL('https', 'www.miyuki.jp', ''),
          ),
          //Others
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text('Others'),
          ),
          ListTile(
            leading: Icon(Icons.coffee_rounded),
            title: Text('寄付する Donate Me'),
            onTap: () => _launchURL('https', 'bmc.link', 'kevinhe'),
          ),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定 Settings'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SettingsPage()));
                scaffoldKey.currentState!.openEndDrawer(); //close drawer
              }),
          SizedBox(height: 50),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('サインアウト Sign Out'),
            onTap: _signOutCheck,
          ),
        ],
      ),
    );
  }
}

//open url
Future<void> _launchURL(String scheme, String url, String path) async {
  final Uri uri = (path != "")
      ? Uri(scheme: scheme, host: url, path: path)
      : Uri(scheme: scheme, host: url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalNonBrowserApplication,
  )) {
    throw "Can not launch the url";
  }
}
