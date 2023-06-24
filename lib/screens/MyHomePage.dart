import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/custom_search_delegate.dart';
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
  final version = "Version: ${CURR_VERSION}";
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String currentMessage = 'message1';
  final controller1 = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  String? userEmail;

  //init all data needed
  @override
  void initState() {
    super.initState();
    _readMiyukiUser();

    //read all song names for searching
    var db = FirebaseFirestore.instance;
    db.collection('songs').get().then((querySnapshot) {
      for (var docSnapshot in querySnapshot.docs) {
        InitData.allSongs.add(docSnapshot.id);
      }
    });
  }

  Future<MiyukiUser> _readMiyukiUser() async {
    setState(() async {
      userEmail = user!.email;
      InitData.miyukiUser = await MiyukiUser.readUser(userEmail!);
      print('welcome ${InitData.miyukiUser.name} ${user!.uid}');
    });

    return InitData.miyukiUser;
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
          //Search Button
          actions: [
            IconButton(
                onPressed: () {
                  showSearch(
                      context: context, delegate: CustomSearchDelegate());
                },
                icon: const Icon(Icons.search))
          ],
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
                          userName: (InitData.miyukiUser.vip == false)
                              ? InitData.miyukiUser.name!
                              : '❆ ${InitData.miyukiUser.name}',
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
          user: user,
          scaffoldKey: _scaffoldKey,
        ));
  }
}

//build messages
Widget buildMessage(Message message) {
  String messageName;
  if (message.userName!.length > 13) {
    messageName = message.userName!.substring(0, 13) + '...';
  } else {
    messageName = message.userName!;
  }

  return ListTile(
    tileColor: theme_dark_grey,
    leading: CircleAvatar(
      child: Text('${message.id}'),
      radius: 20,
    ),
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //User Name
        Container(
          child: Text(
            messageName,
            style: (message.userName![0] == '❆')
                ? TextStyle(fontSize: 20, color: theme_light_blue)
                : TextStyle(fontSize: 20),
          ),
        ),
        SizedBox(width: 5),
        //Sent Time
        Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Text(
                '${message.sentTime.timeZoneName}: ${message.sentTime.year}/${message.sentTime.month}/${message.sentTime.day} ${message.sentTime.hour}:${message.sentTime.minute}',
                style: TextStyle(fontSize: 10)),
          ),
        ),
      ],
    ),
    //Message Text
    subtitle: Text(
      message.text,
      style: TextStyle(fontSize: 18, color: Colors.white),
    ),
  );
}
