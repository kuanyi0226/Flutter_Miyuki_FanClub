import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:url_launcher/url_launcher.dart';

import './concert_page.dart';
import './setting_system/settings_page.dart';
import './yakai_page.dart';

import '../class/Message.dart';
import '../materials/text.dart';
import '../materials/colors.dart';

import '../services/message_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final version = "Version: beta 0.0.0";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String currentMessage = 'message1';
  final controller1 = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;
  String? userEmail;
  MiyukiUser? miyukiUser;

  @override
  void initState() {
    super.initState();
    _readMiyukiUser();
  }

  Future<MiyukiUser> _readMiyukiUser() async {
    userEmail = user.email;
    miyukiUser = await MiyukiUser.readUser(userEmail!);
    return miyukiUser!;
  }

  //sign out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      //App Bar
      appBar: AppBar(title: Text(APPNAME_JP)),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            //Today's song
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    '今日の曲: 時代',
                    style: TextStyle(fontSize: 20),
                  ),
                )),
            //Image
            Expanded(
              child: Image.network(
                  'https://github.com/kuanyi0226/Yuki_DataBase/raw/main/Image/Album/44/album44_17.jpg'),
            ),
            //Message Board
            Container(
              color: theme_dark_grey,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (currentMessage == 'message1') {
                        currentMessage = 'message2';
                      } else {
                        currentMessage = 'message1';
                      }
                      setState(() {});
                    },
                    icon: (currentMessage == 'message1')
                        ? Icon(Icons.looks_one)
                        : Icon(Icons.looks_two),
                  ),
                  Expanded(
                    child: TextField(
                      controller: controller1,
                      decoration: InputDecoration.collapsed(
                          hintText: '伝言板 Message Board'),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      final text = controller1.text;
                      MessageService().createMessage(
                        text: text,
                        currMessage: currentMessage,
                        userName: user.email!,
                      );
                      controller1.text = '';
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Message>>(
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong!');
                  } else if (snapshot.hasData) {
                    final messages = snapshot.data!;

                    return Column(
                      children: [
                        Expanded(
                            child: ListView(
                          children: messages.map(buildMessage).toList(),
                        )),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                stream: MessageService().readMessages(),
              ),
            ),
            Text(version),
          ],
        ),
      ),
      //Drawer
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: theme_dark_grey),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://github.com/kuanyi0226/Nakajima_Miyuki_DataBase/raw/main/Image/Album/44/album44_cover.jpg'),
              ),
              accountName:
                  Text(miyukiUser!.name!, style: TextStyle(fontSize: 18)),
              accountEmail: Text(user.email!, style: TextStyle(fontSize: 18)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 5),
              child: Text('中島みゆき非公式ファンクラブ'),
            ),
            ListTile(
              leading: Icon(Icons.disc_full),
              title: Text('作品 Discography'),
              onTap: () {
                _scaffoldKey.currentState!.openEndDrawer(); //close drawler
              },
            ),
            ListTile(
                leading: Icon(Icons.music_note_outlined),
                title: Text('コンサート Concert'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ConcertPage()));
                  _scaffoldKey.currentState!.openEndDrawer(); //close drawer
                }),
            ListTile(
                leading: Icon(Icons.nightlife),
                title: Text('夜会 Yakai'),
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => YakaiPage()));
                  _scaffoldKey.currentState!.openEndDrawer(); //close drawer
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
              leading: Icon(Icons.lyrics),
              title: Text('中島みゆき公式 Official'),
              onTap: () => _launchURL('https', 'www.miyuki.jp', ''),
            ),
            //Others
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 20),
              child: Text('Others'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('設定 Settings'),
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SettingsPage())),
            ),
            SizedBox(height: 50),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('サインアウト Sign Out'),
              onTap: signOut,
            ),
          ],
        ),
      ),
    );
  }
}

//build widgets
Widget buildMessage(Message message) => ListTile(
      tileColor: theme_dark_grey,
      leading: CircleAvatar(child: Text('${message.id}')),
      title: Text(
        message.text,
        style: TextStyle(fontSize: 21),
      ),
      subtitle: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Container(
              child: Text(message.userName!),
              alignment: Alignment.centerLeft,
            ),
            Container(
              child: Text(message.sentTime.toIso8601String()),
              alignment: Alignment.centerLeft,
            ),
          ],
        ),
      ),
    );
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
