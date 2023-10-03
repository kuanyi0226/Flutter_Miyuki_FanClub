import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/class/Song.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/screens/song_page.dart';
import 'package:project5_miyuki/services/ad_mob_service.dart';
import 'package:project5_miyuki/services/custom_search_delegate.dart';
import 'package:project5_miyuki/services/random_song_service.dart';
import 'package:project5_miyuki/services/yukicoin_service.dart';
import 'package:provider/provider.dart';

import './home_drawer_page.dart';

import '../class/Message.dart';
import '../materials/MyText.dart';
import '../materials/colors.dart';

import '../services/message_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String currentMessage = '1';
  final controller1 = TextEditingController();

  User? user;
  String? userEmail;

  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  final audioPlayer = AudioPlayer();

  //init all data needed
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _readMiyukiUser();
    _createBannerAd();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //detect app is in background
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    //don't care
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = (state == AppLifecycleState.paused);
    if (isBackground) {
      audioPlayer.setVolume(0);
    }
  }

  Future<MiyukiUser> _readMiyukiUser() async {
    setState(() async {
      user = await FirebaseAuth.instance.currentUser;
      userEmail = user!.email;
      InitData.miyukiUser = await MiyukiUser.readUser(userEmail!);
      InitData.miyukiUser.uid = user!.uid;
      InitData.miyukiUser.imgUrl = user!.photoURL;
      print('welcome ${InitData.miyukiUser.name} ${user!.uid}');
    });

    return InitData.miyukiUser;
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      adUnitId: AdMobService.bannerAdUnitId!,
      //adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
    setState(() {
      _bannerAdLoaded = true;
    });
  }

  //sent message by add button
  void _sentMessage() {
    String snackBarString = '';
    //dialog
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Sure To Send Message\non channel "$currentMessage"?',
                style: TextStyle(color: theme_purple, fontSize: 20),
              ),
              content: Text('It will cost you \$1 Yuki Coin.\nYou have \$' +
                  InitData.miyukiUser.coin.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (Provider.of<InternetConnectionStatus>(context,
                                listen: false) ==
                            InternetConnectionStatus.connected) {
                          try {
                            if (InitData.miyukiUser.coin! > 0) {
                              //cost 1 yuki coin
                              YukicoinService.addCoins(-1);
                              //send message
                              final text = controller1.text;
                              MessageService().createMessage(
                                text: text,
                                currMessage: currentMessage,
                                senderImgUrl:
                                    (InitData.miyukiUser.imgUrl != null)
                                        ? InitData.miyukiUser.imgUrl!
                                        : '',
                                userName: (InitData.miyukiUser.vip == false)
                                    ? InitData.miyukiUser.name!
                                    : '❆ ${InitData.miyukiUser.name}',
                              );
                              controller1.text = '';
                              snackBarString =
                                  'Successfully sent! You still have Yuki Coin \$${InitData.miyukiUser.coin}';
                            } else {
                              snackBarString = 'Your money is not enough';
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        } else {
                          snackBarString = 'No Wifi Connection';
                        }

                        //finish
                        var snackBar = SnackBar(content: Text(snackBarString));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: Colors.red, fontSize: 20),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        //App Bar
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Image.asset(
              'assets/images/yuki_club.png',
              width: 170,
            ),
          ),
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
        body: Stack(
          children: [
            //background
            StreamBuilder(
              stream: Stream.periodic(Duration(seconds: 1)),
              builder: (context, snapshot) {
                final curr_time = DateTime.now();
                //decide music
                if (curr_time.minute % 30 == 0 && curr_time.second == 0) {
                  //start
                  if (ModalRoute.of(context)?.isCurrent ?? false) {
                    //top stack page
                    audioPlayer.play(AssetSource('jidai_music.mp3'),
                        volume: 0.10);
                  } else {
                    audioPlayer.play(AssetSource('jidai_music.mp3'), volume: 0);
                  }
                } else if (curr_time.minute % 30 == 0 &&
                    curr_time.second < 50) {
                  //playing
                  if (ModalRoute.of(context)?.isCurrent ?? false) {
                    //top stack page
                    audioPlayer.setVolume(0.10);
                  } else {
                    audioPlayer.setVolume(0);
                  }
                } else {
                  //not playing
                  audioPlayer.setVolume(0);
                }
                //decide background effect
                return (curr_time.minute % 30 == 0)
                    ? WeatherBg(
                        weatherType: WeatherType.heavySnow,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.height,
                      )
                    : WeatherBg(
                        weatherType: WeatherType.cloudyNight,
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.height,
                      );
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  //Today's song
                  StreamBuilder(
                    stream: Stream.periodic(Duration(seconds: 1)),
                    builder: (context, snapshot) {
                      RandomSongService.selectSong();
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: GestureDetector(
                            onTap: () async {
                              if (InitData.todaySong != 'No Song') {
                                Song currSong =
                                    await Song.readSong(InitData.todaySong);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => SongPage(
                                          song: currSong,
                                        )));
                              }
                            },
                            child: Text(
                              '今日の曲：${InitData.todaySong}',
                              style: TextStyle(
                                  fontSize: 20,
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 10),
                  //Message Board
                  Container(
                    color: theme_dark_grey,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            int tempInt = int.parse(currentMessage) + 1;
                            if (tempInt >= 7) tempInt = 1;
                            currentMessage = tempInt.toString();
                            setState(() {});
                          },
                          icon: (currentMessage == '1')
                              ? Icon(Icons.looks_one, color: Colors.orange)
                              : (currentMessage == '2')
                                  ? Icon(Icons.looks_two, color: Colors.orange)
                                  : (currentMessage == '3')
                                      ? Icon(Icons.looks_3,
                                          color: Colors.orange)
                                      : (currentMessage == '4')
                                          ? Icon(Icons.looks_4,
                                              color: Colors.orange)
                                          : (currentMessage == '5')
                                              ? Icon(Icons.looks_5,
                                                  color: Colors.orange)
                                              : Icon(Icons.looks_6,
                                                  color: Colors.orange),
                        ),
                        Expanded(
                          child: TextField(
                            controller: controller1,
                            decoration: InputDecoration.collapsed(
                                hintText: '伝言板 Message Board'),
                          ),
                        ),
                        //sent message
                        IconButton(
                          onPressed: () => _sentMessage(),
                          icon: Icon(Icons.send),
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
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: (_bannerAd == null || !_bannerAdLoaded)
            ? Container()
            : Container(
                margin: const EdgeInsets.only(bottom: 12),
                height: 52,
                child: AdWidget(ad: _bannerAd!),
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
    shape: RoundedRectangleBorder(
      side: BorderSide(color: Colors.black, width: 1),
      borderRadius: BorderRadius.circular(5),
    ),
    tileColor: theme_dark_grey,
    leading: Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(5),
          child: (message.senderImgUrl != '')
              ? CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(message.senderImgUrl!))
              : CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/logo.png')),
        ),
        Positioned(
          child: Text(
            message.id.toString(),
            style: TextStyle(
                fontSize: 25,
                color: Colors.orange,
                fontWeight: FontWeight.bold),
          ),
          bottom: -5,
          left: -1,
        )
      ],
    ),
    title: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //User Name
        Flexible(
          child: Text(
            messageName,
            style: (message.userName![0] == '❆')
                ? TextStyle(
                    fontSize: 20,
                    color: theme_light_blue,
                    overflow: TextOverflow.ellipsis)
                : TextStyle(
                    fontSize: 20,
                    overflow: TextOverflow.ellipsis,
                  ),
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
