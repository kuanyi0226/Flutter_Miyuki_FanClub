import 'package:project5_miyuki/widgets/ClubCachedImage.dart';
import 'package:project5_miyuki/widgets/web_page_shell.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/materials/colors.dart';
import 'package:project5_miyuki/l10n/app_localizations.dart';
import '../../class/Concert.dart';
import 'songlist_page.dart';

class ConcertPage extends StatefulWidget {
  @override
  State<ConcertPage> createState() => _ConcertPageState();
}

class _ConcertPageState extends State<ConcertPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  int _currentTab = 0;

  @override
  void initState() {
    super.initState();
    if (InitData.concertList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        InitData.concertList = await readConcerts();
        if (mounted) setState(() {});
      });
    }
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _selectDecade(int index) {
    setState(() => _currentTab = index);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //initConcertList();
    return Scaffold(
      appBar: AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text('コンサート Concert'),
        ]),
        bottom: TabBar(
          onTap: _selectDecade,
          controller: _tabController,
          indicatorColor: theme_pink,
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
      body: (InitData.concertList.isNotEmpty)
          ? WebPageShell(
              maxWidth: 1280,
              child: kIsWeb
                  ? LayoutBuilder(
                      builder: (context, constraints) {
                        final concerts = InitData.concertList
                            .where((concert) =>
                                yearDisplayCheck(concert.year, _currentTab))
                            .toList();

                        if (constraints.maxWidth < 600) {
                          return ListView.separated(
                            key: ValueKey('concert-list-$_currentTab'),
                            controller: _scrollController,
                            itemCount: concerts.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (context, index) =>
                                _buildWebConcertListTile(
                              concerts[index],
                              context,
                            ),
                          );
                        }

                        final columns = constraints.maxWidth >= 1100
                            ? 4
                            : constraints.maxWidth >= 760
                                ? 3
                                : 2;
                        return GridView.builder(
                          key: ValueKey('concert-grid-$_currentTab'),
                          controller: _scrollController,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: columns,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 1.18,
                          ),
                          itemCount: concerts.length,
                          itemBuilder: (context, index) =>
                              _buildWebConcertCard(concerts[index], context),
                        );
                      },
                    )
                  : ListView(
                      children: InitData.concertList
                          .map((concert) =>
                              buildConcert(concert, context, _currentTab))
                          .toList(),
                    ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

Widget _buildWebConcertCard(Concert concert, BuildContext context) {
  final imageUrl =
      'https://raw.githubusercontent.com//kuanyi0226/Yuki_DataBase/main/Image/Concert/${concert.year}_${concert.year_index}/poster.png';
  return Card(
    key: ValueKey('concert-${concert.year}-${concert.year_index}'),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SonglistPage(
            concert: concert,
            concert_type: "Concert",
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: SizedBox(
                  width: double.infinity,
                  child: ClubCachedImage(
                    key: ValueKey(imageUrl),
                    url: imageUrl,
                    fit: BoxFit.contain,
                    cacheWidth: 560,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              concert.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 3),
            Text(
              concert.year,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildWebConcertListTile(Concert concert, BuildContext context) {
  final imageUrl =
      'https://raw.githubusercontent.com//kuanyi0226/Yuki_DataBase/main/Image/Concert/${concert.year}_${concert.year_index}/poster.png';
  return Card(
    key: ValueKey('concert-list-${concert.year}-${concert.year_index}'),
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SonglistPage(
            concert: concert,
            concert_type: 'Concert',
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 82,
                height: 82,
                child: ClubCachedImage(
                  key: ValueKey(imageUrl),
                  url: imageUrl,
                  fit: BoxFit.contain,
                  cacheWidth: 180,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    concert.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    concert.year,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    ),
  );
}

Future<List<Concert>> readConcerts() async {
  List<Concert> concerts = [];
  try {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('concerts').get();
    concerts = querySnapshot.docs.map((doc) {
      return Concert.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print('Error fetching concerts: $e');
  }

  return concerts;
}

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
              child: ClubCachedImage(
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
