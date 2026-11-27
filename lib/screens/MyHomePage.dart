import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_weather_bg_null_safety/flutter_weather_bg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project5_miyuki/class/Song.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/screens/concert/concert_page.dart';
import 'package:project5_miyuki/screens/public_chat_room_page.dart';
import 'package:project5_miyuki/screens/song_page.dart';
import 'package:project5_miyuki/screens/yakai/yakai_page.dart';
import 'package:project5_miyuki/services/ad_mob_service.dart';
import 'package:project5_miyuki/services/custom_search_delegate.dart';
import 'package:project5_miyuki/services/init_data_service.dart';
import 'package:project5_miyuki/services/random_song_service.dart';
import 'package:project5_miyuki/services/firebase/yukicoin_service.dart';
import 'package:project5_miyuki/widgets/PromoCarouselWidget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './home_drawer_page.dart';
import './web_home_dashboard.dart';
import './web_home_layout.dart';
import './web_home_viewport.dart'
    if (dart.library.html) './web_home_viewport_web.dart';

import '../class/Message.dart';
import '../materials/colors.dart';

import '../services/firebase/message_service.dart';
import 'Yuki_Sekai/yuki_world_entry.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with WidgetsBindingObserver, RouteAware {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String currentMessage = '1';
  final controller1 = TextEditingController();
  late Stream<List<Message>> _messageStream;

  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  final AudioPlayer? _audioPlayer = kIsWeb ? null : AudioPlayer();
  final _weatherClock = Stream<void>.periodic(const Duration(seconds: 1));
  Timer? _dailySongTimer;
  PageRoute<dynamic>? _homeRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!kIsWeb) return;
    final route = ModalRoute.of(context);
    if (route is PageRoute<dynamic> && route != _homeRoute) {
      webHomeRouteObserver.unsubscribe(this);
      _homeRoute = route;
      webHomeRouteObserver.subscribe(this, route);
    }
  }

  @override
  void didPush() => setWebHomeViewport(true);

  @override
  void didPopNext() => setWebHomeViewport(true);

  @override
  void didPushNext() => setWebHomeViewport(false);

  @override
  void didPop() => setWebHomeViewport(false);

  //init all data needed
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _updateDailySong();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final needsUpdate = await InitDataService.checkInit();
      if (needsUpdate && mounted) setState(_updateDailySong);
    });
    _messageStream = MessageService().readMessages(
      target_to_read: 'message-board',
    );

    if (!kIsWeb) {
      checkForUpdate();
      _createBannerAd();
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      webHomeRouteObserver.unsubscribe(this);
      setWebHomeViewport(false);
    }
    WidgetsBinding.instance.removeObserver(this);
    _dailySongTimer?.cancel();
    controller1.dispose();
    _audioPlayer?.dispose();
    _bannerAd?.dispose();
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
      _audioPlayer?.setVolume(0);
    } else if (state == AppLifecycleState.resumed) {
      setState(_updateDailySong);
    }
  }

  void _updateDailySong() {
    RandomSongService.selectSong();
    _dailySongTimer?.cancel();
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    _dailySongTimer = Timer(tomorrow.difference(now), () {
      if (mounted) setState(_updateDailySong);
    });
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
                AppLocalizations.of(context)!.message_board_confirm +
                    '$currentMessage',
                style: TextStyle(color: theme_purple, fontSize: 20),
              ),
              content: Text('It will cost you \$1 Yuki Coin.\n' +
                  AppLocalizations.of(context)!.remaining_yukicoin +
                  ': \$' +
                  InitData.miyukiUser.coin.toString()),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (kIsWeb ||
                            Provider.of<InternetConnectionStatus>(context,
                                    listen: false) ==
                                InternetConnectionStatus.connected) {
                          try {
                            if (InitData.miyukiUser.coin! > 0) {
                              //cost 1 yuki coin
                              YukicoinService.addCoins(-1);
                              //send message
                              final text = controller1.text;
                              MessageService().createMessage(
                                target_to_send: 'message-board',
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
                              snackBarString = AppLocalizations.of(context)!
                                  .money_not_enough;
                            }
                          } catch (e) {
                            print(e.toString());
                          }
                        } else {
                          snackBarString =
                              AppLocalizations.of(context)!.no_wifi;
                        }

                        //finish
                        var snackBar = SnackBar(content: Text(snackBarString));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        Navigator.of(context).pop();
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!.send,
                      style: const TextStyle(color: Colors.red, fontSize: 20),
                    )),
              ],
            ));
  }

  //For in-app update
  Future<void> checkForUpdate() async {
    print('checking for Update');
    InAppUpdate.checkForUpdate().then((info) {
      if (!mounted) return;
      setState(() {
        if (info.updateAvailability == UpdateAvailability.updateAvailable) {
          print('update available');
          update();
        }
      });
    }).catchError((e) {
      print(e.toString());
    });
  }

  void update() async {
    print('Updating');
    await InAppUpdate.startFlexibleUpdate();
    InAppUpdate.completeFlexibleUpdate().then((_) {}).catchError((e) {
      print(e.toString());
    });
  }

  void _changeChannel() {
    setState(() {
      currentMessage = (int.parse(currentMessage) % 5 + 1).toString();
    });
  }

  Future<void> _openTodaySong() async {
    if (InitData.todaySong == 'No Song') return;
    final song = await Song.readSong(InitData.todaySong);
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SongPage(song: song)),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return WebHomeDashboard(
        scaffoldKey: _scaffoldKey,
        drawer: HomeDrawerPage(scaffoldKey: _scaffoldKey),
        todaySong: InitData.todaySong,
        openSong: _openTodaySong,
        openSearch: () =>
            showSearch(context: context, delegate: CustomSearchDelegate()),
        openChat: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PublicChatRoomPage()),
        ),
        openConcert: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => ConcertPage()),
        ),
        openYakai: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => YakaiPage()),
        ),
        openWorld: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const YukiWorldEntry()),
        ),
        messages: _messageStream,
        messageController: controller1,
        messageChannel: currentMessage,
        changeChannel: _changeChannel,
        sendMessage: _sentMessage,
      );
    }
    return Scaffold(
        key: _scaffoldKey,
        //App Bar
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Image.asset(
              'assets/images/yuki_club.png',
              width: 170,
              cacheWidth: kIsWeb ? 340 : null,
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
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              StreamBuilder<void>(
                stream: _weatherClock,
                builder: (context, snapshot) {
                  final now = DateTime.now();
                  final snow = now.minute % 30 == 0;
                  final isCurrent = ModalRoute.of(context)?.isCurrent ?? false;
                  final volume =
                      snow && now.second < 50 && isCurrent ? 0.1 : 0.0;
                  if (snow && now.second == 0) {
                    _audioPlayer!.play(
                      AssetSource('jidai_music.mp3'),
                      volume: volume,
                    );
                  } else {
                    _audioPlayer!.setVolume(volume);
                  }
                  final size = MediaQuery.of(context).size;
                  return WeatherBg(
                    weatherType:
                        snow ? WeatherType.heavySnow : WeatherType.cloudyNight,
                    height: size.height,
                    width: size.height,
                  );
                },
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Today's song
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: GestureDetector(
                          onTap: _openTodaySong,
                          child: Text(
                            '今日の曲：${InitData.todaySong.replaceAll('_', ' ')}',
                            style: const TextStyle(
                              fontSize: 20,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    //Function Buttons
                    Container(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          //Public Chat Room
                          FilledButton.tonal(
                            //style: ButtonStyle(backgroundColor: ),
                            child:
                                Text(AppLocalizations.of(context)!.chat_room),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PublicChatRoomPage()));
                            },
                          ),
                          SizedBox(width: 5),
                          //Concert
                          FilledButton.tonal(
                            //style: ButtonStyle(backgroundColor: ),
                            child: Text(AppLocalizations.of(context)!.concert),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ConcertPage()));
                            },
                          ),
                          SizedBox(width: 5),
                          //Yakai
                          FilledButton.tonal(
                            //style: ButtonStyle(backgroundColor: ),
                            child: Text(AppLocalizations.of(context)!.yakai),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => YakaiPage()));
                            },
                          ),
                          SizedBox(width: 5),
                          //Yuki World
                          FilledButton.tonal(
                            //style: ButtonStyle(backgroundColor: ),
                            child:
                                Text(AppLocalizations.of(context)!.yuki_world),
                            onPressed: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const YukiWorldEntry()));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    const PromoCarouselWidget(),
                    //Message Board
                    Container(
                      decoration: BoxDecoration(
                        //color: theme_dark,
                        border: Border.all(
                          color: theme_pink,
                          width: 2.0, // Set the border width
                        ),
                        borderRadius: BorderRadius.circular(
                            30.0), // Set the border radius for curvy edges
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: _changeChannel,
                            icon: (currentMessage == '1')
                                ? Icon(Icons.looks_one, color: theme_pink)
                                : (currentMessage == '2')
                                    ? Icon(Icons.looks_two, color: theme_pink)
                                    : (currentMessage == '3')
                                        ? Icon(Icons.looks_3, color: theme_pink)
                                        : (currentMessage == '4')
                                            ? Icon(Icons.looks_4,
                                                color: theme_pink)
                                            : Icon(Icons.looks_5,
                                                color: theme_pink),
                          ),
                          Expanded(
                            child: TextField(
                              maxLines: null,
                              maxLength: 100,
                              controller: controller1,
                              decoration: InputDecoration(
                                  counterText: "",
                                  border: InputBorder.none,
                                  hintText: AppLocalizations.of(context)!
                                      .message_board),
                            ),
                          ),
                          //sent message
                          IconButton(
                            onPressed: () => _sentMessage(),
                            icon: Icon(Icons.send, color: theme_pink),
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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                        stream: _messageStream,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: (_bannerAd == null || !_bannerAdLoaded)
        //     ? Container()
        //     : Container(
        //         margin: const EdgeInsets.only(bottom: 12),
        //         height: 52,
        //         child: AdWidget(ad: _bannerAd!),
        //       ),
        //Drawer
        drawer: HomeDrawerPage(
          scaffoldKey: _scaffoldKey,
        ));
  }
}

//build messages
Widget buildMessage(Message message) {
  String messageName = message.userName!;
  // if (message.userName!.length > 13) {
  //   messageName = message.userName!.substring(0, 13) + '...';
  // } else {
  //   messageName = message.userName!;
  // }

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
                  backgroundImage: ResizeImage.resizeIfNeeded(
                    kIsWeb ? 80 : null,
                    null,
                    const AssetImage('assets/images/logo.png'),
                  ),
                ),
        ),
        Positioned(
          child: Text(
            message.id.toString(),
            style: TextStyle(
                fontSize: 25, color: theme_pink, fontWeight: FontWeight.bold),
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
            overflow: TextOverflow.ellipsis,
            style: (message.userName![0] == '❆')
                ? TextStyle(
                    fontSize: 18,
                    color: theme_light_blue,
                    overflow: TextOverflow.ellipsis)
                : TextStyle(
                    fontSize: 18,
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
                '${message.sentTime.year}/${message.sentTime.month}/${message.sentTime.day} ${(message.sentTime.hour < 10 ? '0' + message.sentTime.hour.toString() : message.sentTime.hour)}:${(message.sentTime.minute < 10 ? '0' + message.sentTime.minute.toString() : message.sentTime.minute)}',
                style: TextStyle(fontSize: 10)),
          ),
        ),
      ],
    ),
    //Message Text
    subtitle: Text(
      message.text,
      style: TextStyle(fontSize: 16, color: Colors.white),
    ),
  );
}
