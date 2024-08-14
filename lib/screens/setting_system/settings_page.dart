import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project5_miyuki/class/official/updateInfo.dart';
import 'package:project5_miyuki/screens/setting_system/about_app_page.dart';
import 'package:project5_miyuki/screens/setting_system/copyright_page.dart';
import 'package:project5_miyuki/screens/setting_system/privacy_policy_page.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../screens/auth_system/forgot_password_page.dart';
import '../../services/ad_mob_service.dart';
import '../../services/official_service.dart';
import './update_page.dart';
import './profile_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _bannerAdLoaded = false;
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _createBannerAd();
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                AppLocalizations.of(context)!.account,
                style: TextStyle(fontSize: 22),
              ),
            ),
            //Account
            Card(
              child: Column(children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage())),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.profile,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForGotPasswordPage())),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.forgot_password,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ]),
            ),
            //More info
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(
                AppLocalizations.of(context)!.more_info_support,
                style: TextStyle(fontSize: 22),
              ),
            ),
            Card(
              child: Column(children: [
                //About App
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => AboutAppPage())),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.about_app,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),

                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => UpdatePage())),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.check_update,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => PrivacyPolicyPage())),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.privacy_policy,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                //Copyright
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CopyrightPage())),
                  child: ListTile(
                    title: Text(
                      AppLocalizations.of(context)!.copyright,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
      bottomNavigationBar: (_bannerAd == null || !_bannerAdLoaded)
          ? Container(height: 52)
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: _bannerAd!),
            ),
    );
  }
}
