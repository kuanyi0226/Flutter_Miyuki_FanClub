import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../class/Concert.dart';
import './songlist_page.dart';

class ConcertPage extends StatefulWidget {
  @override
  State<ConcertPage> createState() => _PageState();
}

class _PageState extends State<ConcertPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text('コンサート Concert'),
          ]),
        ),
        body: StreamBuilder<List<Concert>>(
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong!');
            } else if (snapshot.hasData) {
              final concerts = snapshot.data!;

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: concerts
                          .map((concert) => buildConcert(concert, context))
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
Widget buildConcert(Concert concert, BuildContext context) => ListTile(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SonglistPage(
                concert: concert,
                concert_type: "Concert",
              ))),
      leading: Image.network(
        'https://github.com/kuanyi0226/Yuki_DataBase/raw/main/Image/Concert/${concert.year}_${concert.year_index}/poster.png',
        scale: 2.3,
      ),
      title: Text(
        concert.name,
        style: TextStyle(fontSize: 21),
      ),
      subtitle: Text(concert.year),
    );
