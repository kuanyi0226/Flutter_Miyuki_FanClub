import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/screens/ad_page.dart';
import 'package:project5_miyuki/screens/yuki_store_page.dart';
import 'package:project5_miyuki/services/firebase/yukicoin_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../services/firebase/official_service.dart';
import 'concert/concert_page.dart';
import './setting_system/settings_page.dart';
import 'Yuki_Sekai/yuki_sekai_list_page.dart';
import 'yakai/yakai_page.dart';

import '../materials/MyText.dart';
import '../materials/colors.dart';

class HomeDrawerPage extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldKey;
  HomeDrawerPage({super.key, required this.scaffoldKey});

  @override
  State<HomeDrawerPage> createState() => _HomeDrawerPageState(
        scaffoldKey: scaffoldKey,
      );
}

class _HomeDrawerPageState extends State<HomeDrawerPage> {
  GlobalKey<ScaffoldState> scaffoldKey;
  bool _checked = false;
  final int CHECK_IN_COIN = 5;

  _HomeDrawerPageState({required this.scaffoldKey});

  //check to sign out
  Future _signOutCheck() {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.sign_out_confirm,
                style: TextStyle(fontSize: 25),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      _signOut();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.sign_out,
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

  void _showCheckinDialog(bool checkinStatus) {
    String title = '';
    String content = '';
    if (kIsWeb ||
        Provider.of<InternetConnectionStatus>(context, listen: false) ==
            InternetConnectionStatus.connected) {
      if (checkinStatus) {
        title = AppLocalizations.of(context)!.daily_check_in_success;
        content = AppLocalizations.of(context)!.yuki_coin + ' + $CHECK_IN_COIN';
        try {
          setState(() {
            YukicoinService.addCoins(CHECK_IN_COIN); //5
          });
        } catch (e) {
          print(e.toString());
        }
      } else {
        title = AppLocalizations.of(context)!.daily_check_in_fail;
        content = AppLocalizations.of(context)!.daily_check_in_tomorrow;
      }
    } else {
      title = AppLocalizations.of(context)!.no_wifi;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content, style: TextStyle(color: theme_purple)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(
                color: theme_dark_grey,
                image: DecorationImage(
                    image: AssetImage('assets/images/login_icon_cover.jpg'),
                    fit: BoxFit.fill)),
            currentAccountPicture: (InitData.miyukiUser.imgUrl != null)
                ? CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage(InitData.miyukiUser.imgUrl!))
                : CircleAvatar(
                    radius: 64,
                    backgroundImage: AssetImage('assets/images/logo.png')),
            accountName: Text(InitData.miyukiUser.name!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      blurRadius: 20,
                    )
                  ],
                )),
            accountEmail: Text(
              AppLocalizations.of(context)!.yuki_coin +
                  ': \$' +
                  InitData.miyukiUser.coin.toString(),
              style: TextStyle(
                fontSize: 18,
                shadows: [
                  Shadow(
                    blurRadius: 15,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 5),
            child: Text('中島みゆき非公式ファンクラブ $CURR_VERSION'),
          ),
          //Daily Check-in
          (DateFormat('yyyyMMdd').format(DateTime.now()) ==
                      InitData.checkinDate ||
                  _checked)
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: OutlinedButton(
                    onPressed: () async {
                      _showCheckinDialog(await OfficialService.dailyCheckIn());
                      setState(() {
                        _checked = true;
                      });
                    },
                    child: Text(
                      AppLocalizations.of(context)!.daily_check_in,
                      style: TextStyle(color: theme_pink),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: BorderSide(width: 2.0, color: theme_pink),
                    ),
                  ),
                ),
          ListTile(
            leading: Icon(Icons.disc_full),
            title: Text('作品 Discography'),
            onTap: () => _launchURL(
                'https', 'www.miyuki.jp', 's/y10/search/discography'),
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
          ListTile(
              leading: Icon(Icons.meeting_room_outlined),
              title: Text('雪の世界 Yuki World'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => YukiSekaiListPage()));
                scaffoldKey.currentState!.openEndDrawer(); //close drawer
              }),
          ListTile(
              leading: Icon(Icons.store),
              title: Text('雪の店 Yuki Store'),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => YukiStorePage()));
                scaffoldKey.currentState!.openEndDrawer(); //close drawer
              }),
          //Websites
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text('Websites', style: TextStyle(color: theme_purple)),
          ),
          ListTile(
            leading: Icon(Icons.assignment),
            title: Text('中島みゆき公式 Official'),
            onTap: () => _launchURL('https', 'www.miyuki.jp', ''),
          ),
          ListTile(
            leading: Icon(Icons.school),
            title: Text('中島みゆき研究所 Miyuki Lab'),
            onTap: () => _launchURL('http', 'miyuki-lab.jp', ''),
          ),
          ListTile(
            leading: Icon(Icons.lyrics),
            title: Text('Orika歌詞 Lyrics'),
            onTap: () => _launchURL('https', 'orikamushi.netlify.app',
                '/miyuki_zone/miyukiframeset'),
          ),

          //Others
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 20),
            child: Text('Others', style: TextStyle(color: theme_purple)),
          ),
          (kIsWeb)
              ? ListTile(
                  leading: Icon(Icons.android),
                  title: Text('アプリをダウンロードする Download Android App'),
                  onTap: () => launchUrlString(Uri.decodeComponent(
                      'https://play.google.com/store/apps/details?id=com.yukiclub.yukiclub')),
                )
              : Container(),
          (kIsWeb)
              ? Container()
              : ListTile(
                  leading: Icon(Icons.ad_units),
                  title: Text('Watch Ads to Earn Yuki Coin'),
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => AdPage())),
                ),
          ListTile(
            leading: Icon(Icons.coffee_rounded),
            title: Text('寄付する Donate Me'),
            onTap: () => _launchURL('https', 'bmc.link', 'kevinhe'),
          ),
          ListTile(
            leading: Icon(Icons.comment),
            title: Text('アドバイス Talk to us'),
            onTap: () => _launchURL('https', 'forms.gle', 'pZduHPmGgd7MVpZw6'),
          ),
          ListTile(
            leading: Icon(Icons.check_box),
            title: Text('リソース共有する Share Resource'),
            onTap: () => _launchURL('https', 'forms.gle', '7mJKqXmXtVU2xphQ6'),
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
