import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:project5_miyuki/screens/Yuki_Sekai/yuki_sekai_page.dart';
import '../../materials/InitData.dart';
import '../../materials/colors.dart';

class YukiSekaiListPage extends StatefulWidget {
  const YukiSekaiListPage({super.key});

  @override
  State<YukiSekaiListPage> createState() => _YukiSekaiListPageState();
}

class _YukiSekaiListPageState extends State<YukiSekaiListPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('雪の世界 Yuki World'),
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              _currentTab = index;
            });
          },
          controller: _tabController,
          indicatorColor: theme_purple,
          tabs: [
            Tab(
              text: AppLocalizations.of(context)!.concert,
            ),
            Tab(
              text: AppLocalizations.of(context)!.yakai,
            ),
          ],
        ),
      ),
      body: (_currentTab == 1)
          ? ListView(children: [
              //2006 mirage hotel
              ListTile(
                visualDensity: VisualDensity(vertical: 3),
                leading: Container(
                  width: 120,
                  height: 90,
                  child: Image.asset(
                    'assets/images/yuki_sekai/y2006/background_display.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text(AppLocalizations.of(context)!.mirage_hotel),
                subtitle: Text('2006年 夜会 Vol.14'),
                onTap: () async {
                  InitData.curr_worldName = 'y2006';
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => YukiSekaiPage(
                            title: AppLocalizations.of(context)!.mirage_hotel,
                          )));
                  InitData.isInSekai = true;
                },
              ),
            ])
          : ListView(children: [
              //2007 Uta Tabi
              ListTile(
                visualDensity: VisualDensity(vertical: 3),
                leading: Container(
                  width: 120,
                  height: 90,
                  child: Image.asset(
                    'assets/images/yuki_sekai/2007_0/background_display.jpg',
                    fit: BoxFit.fill,
                  ),
                ),
                title: Text('TOUR 2007 歌旅'),
                subtitle: Text('2007年 Concert\'07'),
                onTap: () async {
                  InitData.curr_worldName = '2007_0';
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => YukiSekaiPage(
                            title: 'TOUR 2007 歌旅',
                          )));
                  InitData.isInSekai = true;
                },
              ),
            ]),
    );
  }
}
