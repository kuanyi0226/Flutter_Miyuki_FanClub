import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:url_launcher/url_launcher.dart';

import './concert_page.dart';
import './settings_page.dart';
import './yakai_page.dart';

import '../class/Message.dart';
import '../materials/text.dart';
import '../materials/colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final version = "Version: beta 0.0.0";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String currentMessage = 'user1';
  final controller1 = TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  //sign out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(APPNAME_JP),
        actions: [
          IconButton(
            onPressed: () {
              if (currentMessage == 'user1') {
                currentMessage = 'user2';
              } else {
                currentMessage = 'user1';
              }
              setState(() {});
            },
            icon: (currentMessage == 'user1')
                ? Icon(Icons.looks_one)
                : Icon(Icons.looks_two),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller1,
                    decoration: InputDecoration.collapsed(
                        hintText: '伝言板 Message Board'),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    final name = controller1.text;
                    createUser(name: name, currUser: currentMessage);
                    controller1.text = '';
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<List<Message>>(
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong!');
                  } else if (snapshot.hasData) {
                    final users = snapshot.data!;

                    return Column(
                      children: [
                        Expanded(
                            child: ListView(
                          children: users.map(buildUser).toList(),
                        )),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                stream: readUsers(),
              ),
            ),
            Expanded(
              child: Image.network(
                  'https://github.com/kuanyi0226/Yuki_DataBase/raw/main/Image/Album/44/album44_17.jpg'),
            ),
            Text(version),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: theme_grey),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://github.com/kuanyi0226/Nakajima_Miyuki_DataBase/raw/main/Image/Album/44/album44_cover.jpg'),
              ),
              accountName: Text('中島みゆき非公式ファンクラブ'),
              accountEmail: Text(user.email!),
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
Widget buildUser(Message message) => ListTile(
      leading: CircleAvatar(child: Text('${message.age}')),
      title: Text(
        message.name,
        style: TextStyle(fontSize: 21),
      ),
      subtitle: Text(message.birthday.toIso8601String()),
    );

//create data
Future createUser({required String name, required String currUser}) async {
  //Reference t document
  final docUser = FirebaseFirestore.instance.collection('users').doc(currUser);
  final now = DateTime.now();

  final user = Message(
    id: docUser.id,
    name: name,
    age: (currUser == 'user1') ? 1 : 2,
    birthday: DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
    ),
  );
  final json = user.toJson();

  //create document and write data to Firebase
  await docUser.set(json);
}

//read data
Stream<List<Message>> readUsers() =>
    FirebaseFirestore.instance.collection('users').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());

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
