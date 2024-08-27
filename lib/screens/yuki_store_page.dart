import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project5_miyuki/class/Garment.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/yuki_store_service.dart';
import 'package:project5_miyuki/services/firebase/yukicoin_service.dart';
import 'package:provider/provider.dart';
import '../class/MyDecoder.dart';
import '../materials/colors.dart';

class YukiStorePage extends StatefulWidget {
  const YukiStorePage({super.key});

  @override
  State<YukiStorePage> createState() => _YukiStorePageState();
}

class _YukiStorePageState extends State<YukiStorePage>
    with TickerProviderStateMixin {
  int _currentTab = 0;
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _tapItem(bool purchased, Garment garment, bool isCurrentGarment) {
    if (purchased) {
      //change garment
      _changeCurrentGarment(garment, isCurrentGarment);
    } else {
      //buy new item
      _buyItem(garment);
    }
  }

  void _changeCurrentGarment(Garment garment, bool isCurrentGarment) {
    String snackBarString = '';
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.garment_change +
                    '\n' +
                    garment.name,
                style: TextStyle(fontSize: 20),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      setState(() {
                        if (kIsWeb ||
                            Provider.of<InternetConnectionStatus>(context,
                                    listen: false) ==
                                InternetConnectionStatus.connected) {
                          if (isCurrentGarment) {
                            snackBarString = AppLocalizations.of(context)!
                                .garment_put_on_already;
                          } else {
                            try {
                              for (int i = 0;
                                  i < InitData.miyukiUser.collections!.length;
                                  i++) {
                                String curr_collection =
                                    InitData.miyukiUser.collections![i];
                                //not wearing the old one
                                if (curr_collection
                                    .contains('[garment][current]')) {
                                  InitData.miyukiUser.collections![i] =
                                      curr_collection.replaceFirst(
                                          '[current]', '');
                                }
                                //wearing a new one
                                if (curr_collection.contains(garment.file)) {
                                  InitData.miyukiUser.collections![i] =
                                      curr_collection.replaceFirst(
                                          "[garment]", "[garment][current]");
                                }
                              }
                              //update collections
                              MiyukiUser.updateCollections(
                                  InitData.miyukiUser.collections!);
                              //update current garment
                              InitData.curr_garment = garment.file;
                              snackBarString =
                                  AppLocalizations.of(context)!.garment_changed;
                            } catch (e) {
                              print(e.toString());
                              snackBarString =
                                  'Something Wrong Happen while changing a garment.';
                            }
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
                      AppLocalizations.of(context)!.yes,
                      style: TextStyle(color: theme_purple, fontSize: 20),
                    )),
              ],
            ));
  }

  void _buyItem(Garment garment) {
    String snackBarString = '';
    //dialog
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.purchase_confirm +
                    '\n' +
                    garment.name,
                style: TextStyle(fontSize: 20),
              ),
              content: Text(AppLocalizations.of(context)!.price +
                  ': \$${garment.price}\n' +
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
                            if (InitData.miyukiUser.coin! > garment.price) {
                              //yuki coin
                              YukicoinService.addCoins(0 - garment.price);
                              //update collections
                              InitData.miyukiUser.collections!
                                  .add('[garment]' + garment.file);
                              MiyukiUser.updateCollections(
                                  InitData.miyukiUser.collections!);

                              snackBarString = 'Successfully bought! ' +
                                  AppLocalizations.of(context)!
                                      .remaining_yukicoin +
                                  ': \$${InitData.miyukiUser.coin}';
                            } else {
                              snackBarString = AppLocalizations.of(context)!
                                  .money_not_enough;
                            }
                          } catch (e) {
                            snackBarString = 'Something wrong happened.';
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
                      AppLocalizations.of(context)!.yes,
                      style: TextStyle(color: theme_purple, fontSize: 20),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(AppLocalizations.of(context)!.yuki_store),
          ],
        ),
        actions: [
          Center(
              child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(AppLocalizations.of(context)!.yuki_coin +
                ': ${InitData.miyukiUser.coin}'),
          )),
        ],
        // bottom: TabBar(
        //   onTap: (index) {
        //     setState(() {
        //       _currentTab = index;
        //     });
        //   },
        //   controller: _tabController,
        //   indicatorColor: theme_purple,
        //   tabs: [
        //     Tab(
        //       text: AppLocalizations.of(context)!.garment,
        //     ),
        //   ],
        // ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Garment
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10),
            child: Text(
              AppLocalizations.of(context)!.garment,
              style: TextStyle(fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, top: 10, bottom: 10, right: 15),
            child: Text(
              AppLocalizations.of(context)!.garment_info,
              style: TextStyle(fontSize: 15),
            ),
          ),
          //Item list
          Expanded(
            child: ListView.builder(
              itemCount: YukiStoreService.readAllGarments().length,
              itemBuilder: (BuildContext context, int index) =>
                  _buildItem(context, index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    String garmentName = YukiStoreService.readAllGarments().elementAt(index);
    Garment garment = MyDecoder.getGarmentInfo(garmentName);
    bool purchased = false;
    bool isCurrentGarment = false;
    for (String collection in InitData.miyukiUser.collections!) {
      if (collection.startsWith('[garment]')) {
        if (collection.contains(garment.file)) {
          purchased = true;
          if (collection.contains('[current]')) isCurrentGarment = true;
        }
      }
    }

    return ListTile(
      onTap: () => _tapItem(purchased, garment, isCurrentGarment),
      leading: Container(
        width: 40,
        height: 40,
        child: Image.asset(
          'assets/images/yuki_sekai/Main Characters/$garmentName/Jump (32x32).png',
          fit: BoxFit.contain,
        ),
      ),
      title: Text(
        garment.name,
        style: TextStyle(fontSize: 21, color: theme_purple),
      ),
      subtitle: (purchased)
          ? Row(
              children: [
                Text('\$${garment.price}'),
                Text('(' + AppLocalizations.of(context)!.purchased + ')'),
                (isCurrentGarment)
                    ? Icon(Icons.check, color: Colors.green)
                    : Container(),
                (isCurrentGarment)
                    ? Text(
                        AppLocalizations.of(context)!.current_garment,
                        style: TextStyle(fontSize: 15, color: Colors.green),
                      )
                    : Container(),
              ],
            )
          : Text(
              '\$${garment.price}',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
    );
  }
}
