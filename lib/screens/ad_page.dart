import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:project5_miyuki/materials/colors.dart';

import '../materials/InitData.dart';
import '../services/ad_mob_service.dart';
import '../services/yukicoin_service.dart';

class AdPage extends StatefulWidget {
  const AdPage({super.key});

  @override
  State<AdPage> createState() => _AdPageState();
}

class _AdPageState extends State<AdPage> {
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;
  bool _bannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _createRewardedAd();
    _createBannerAd();
  }

  void _createBannerAd() {
    _bannerAd = BannerAd(
      size: AdSize.fullBanner,
      //adUnitId: AdMobService.bannerAdUnitId!,
      adUnitId: 'ca-app-pub-3940256099942544/6300978111',
      listener: AdMobService.bannerAdListener,
      request: const AdRequest(),
    )..load();
    setState(() {
      _bannerAdLoaded = true;
    });
  }

  void _createRewardedAd() {
    RewardedAd.load(
        //adUnitId: AdMobService.rewardedAdUnitId!,
        adUnitId: 'ca-app-pub-3940256099942544/5224354917',
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (ad) => _rewardedAd = ad,
            onAdFailedToLoad: (error) => _rewardedAd = null));
    setState(() {});
  }

  void _showRewardedAd() {
    print('Rewarded ad is Not null');
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _createRewardedAd(); //create new one
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _createRewardedAd(); //create new one
      },
    );
    _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) => setState(() {
              YukicoinService.addCoins(25);
              //finish
              var snackBar = SnackBar(
                  content: Text(
                      'Thanks for watching Ads, you have Yuki Coin \$${InitData.miyukiUser.coin.toString()}'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Thanks for watching Ads')),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(primary: theme_purple),
          child: Text(
            'Watch Ad!',
            style: TextStyle(fontSize: 50),
          ),
          onPressed: _showRewardedAd,
        ),
      ),
      bottomNavigationBar: (_bannerAd == null || !_bannerAdLoaded)
          ? Container()
          : Container(
              margin: const EdgeInsets.only(bottom: 12),
              height: 52,
              child: AdWidget(ad: _bannerAd!),
            ),
    );
  }
}
