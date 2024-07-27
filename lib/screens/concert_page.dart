import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/materials/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../class/Concert.dart';
import './songlist_page.dart';

class ConcertPage extends StatefulWidget {
  @override
  State<ConcertPage> createState() => _PageState();
}

class _PageState extends State<ConcertPage> with TickerProviderStateMixin {
  late final TabController _tabController;
  int _currentTab = 0;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text('コンサート Concert'),
          ]),
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
                text: AppLocalizations.of(context)!.all,
              ),
              Tab(
                text: '1970s',
              ),
              Tab(
                text: '1980s',
              ),
              Tab(
                text: '1990s',
              ),
              Tab(
                text: '2000s',
              ),
            ],
          ),
        ),
        body: StreamBuilder<List<Concert>>(
          builder: (context, snapshot) {
            print("tab : ${_tabController.index}");
            if (snapshot.hasError) {
              return Text('Something went wrong!');
            } else if (snapshot.hasData) {
              final concerts = snapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: concerts
                          .map((concert) =>
                              buildConcert(concert, context, _currentTab))
                          .toList(),
                    ),
                  ),
                ],
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
          stream: readConcerts(),
        ),
      );
}

Stream<List<Concert>> readConcerts() => FirebaseFirestore.instance
    .collection('concerts')
    .snapshots()
    .map((snapshot) =>
        snapshot.docs.map((doc) => Concert.fromJson(doc.data())).toList());
//ListTile Widget
Widget buildConcert(Concert concert, BuildContext context, int currentTab) =>
    (yearDisplayCheck(concert.year, currentTab))
        ? ListTile(
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SonglistPage(
                      concert: concert,
                      concert_type: "Concert",
                    ))),
            leading: Container(
              width: 40,
              height: 40,
              child: FastCachedImage(
                url:
                    'https://raw.githubusercontent.com//kuanyi0226/Yuki_DataBase/main/Image/Concert/${concert.year}_${concert.year_index}/poster.png',
                // errorBuilder: (context, exception, stacktrace) {
                //   return Text(stacktrace.toString());
                // },
                fit: BoxFit.contain,
              ),
            ),
            // Image.network(
            //   'https://github.com/kuanyi0226/Yuki_DataBase/raw/main/Image/Concert/${concert.year}_${concert.year_index}/poster.png',
            //   scale: 2.3,
            // ),
            title: Text(
              concert.name,
              style: TextStyle(fontSize: 21),
            ),
            subtitle: Text(concert.year),
          )
        : Container();

bool yearDisplayCheck(String year, int currentTab) {
  int concert_year = 0;
  concert_year = int.parse(year);
  switch (currentTab) {
    case 0:
      //display all concerts
      return true;
    case 1:
      //display 1970s
      return (concert_year >= 1970 && concert_year < 1980);
    case 2:
      //display 1980s
      return (concert_year >= 1980 && concert_year < 1990);
    case 3:
      //display 1990s
      return (concert_year >= 1990 && concert_year < 2000);
    case 4:
      //display 2000s
      return (concert_year >= 2000);
    default:
      return true;
  }
}
