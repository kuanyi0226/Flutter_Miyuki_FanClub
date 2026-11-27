import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:project5_miyuki/class/MyDecoder.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/screens/yakai/yakai_songlist_page.dart';
import 'package:project5_miyuki/widgets/ClubCachedImage.dart';
import 'package:project5_miyuki/widgets/web_page_shell.dart';

class YakaiPage extends StatefulWidget {
  @override
  State<YakaiPage> createState() => _PageState();
}

class _PageState extends State<YakaiPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
        title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Text('夜会 Yakai'),
        ]),
      ),
      body: WebPageShell(
        maxWidth: 1280,
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (kIsWeb) {
              final columns = constraints.maxWidth >= 1100
                  ? 4
                  : constraints.maxWidth >= 760
                      ? 3
                      : constraints.maxWidth >= 480
                          ? 2
                          : 1;
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.18,
                ),
                itemCount: InitData.YAKAIS.length,
                itemBuilder: (context, index) {
                  final year = InitData.YAKAIS.elementAt(index);
                  return _buildWebYakaiCard(context, year);
                },
              );
            }
            return ListView.builder(
              itemCount: InitData.YAKAIS.length,
              itemBuilder: (context, index) {
                String curr_yakai_year = InitData.YAKAIS.elementAt(index);
                return ListTile(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => YakaiSonglistPage(
                        yakai_year: curr_yakai_year,
                      ))),
              leading: Container(
                width: 40,
                height: 40,
                child: ClubCachedImage(
                  url:
                      'https://raw.githubusercontent.com//kuanyi0226/Yuki_DataBase/main/Image/Yakai/${curr_yakai_year.substring(1)}_0/poster.jpg',
                  // errorBuilder: (context, exception, stacktrace) {
                  //   return Text(stacktrace.toString());
                  // },
                  fit: BoxFit.contain,
                ),
              ),
              title: Text(
                MyDecoder.yearToConcertName(curr_yakai_year),
                style: TextStyle(fontSize: 21),
              ),
              subtitle: Text(curr_yakai_year.substring(1)),
                );
              },
            );
          },
        ),
      ));
}

Widget _buildWebYakaiCard(BuildContext context, String year) {
  return Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => YakaiSonglistPage(yakai_year: year),
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
                    url:
                        'https://raw.githubusercontent.com//kuanyi0226/Yuki_DataBase/main/Image/Yakai/${year.substring(1)}_0/poster.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              MyDecoder.yearToConcertName(year),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 3),
            Text(
              year.substring(1),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    ),
  );
}
