import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:url_launcher/url_launcher.dart';

import './concert_page.dart';
import './setting_system/settings_page.dart';
import './yakai_page.dart';
import './home_drawer_page.dart';

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

  User? user = FirebaseAuth.instance.currentUser;
  String? userEmail;
  MiyukiUser miyukiUser =
      MiyukiUser(name: 'No Name', email: 'No data', vip: false);

  @override
  void initState() {
    super.initState();
    _readMiyukiUser();
  }

  Future<MiyukiUser> _readMiyukiUser() async {
    setState(() async {
      userEmail = user!.email;
      miyukiUser = await MiyukiUser.readUser(userEmail!);
      print('welcome ${miyukiUser.name}');
    });

    return miyukiUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        //App Bar
        appBar: AppBar(
          title: Text(APPNAME_JP),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              setState(() {});
              if (_scaffoldKey.currentState!.isDrawerOpen) {
                _scaffoldKey.currentState!.closeDrawer();
                //close drawer, if drawer is open
              } else {
                _scaffoldKey.currentState!.openDrawer();
                //open drawer, if drawer is closed
              }
            },
          ),
        ),
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
                          userName: miyukiUser.name!,
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
        drawer: HomeDrawerPage(
          miyukiUser: miyukiUser,
          user: user,
          scaffoldKey: _scaffoldKey,
        ));
  }
}

//build messages
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
