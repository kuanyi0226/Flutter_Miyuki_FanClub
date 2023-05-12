import 'package:cloud_firestore/cloud_firestore.dart';

class Concert {
  String year;
  String? year_index = '0';
  String name;
  List? songs;

  Concert({
    required this.name,
    required this.year,
    this.year_index,
    this.songs,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'year': year,
        'year_index': year_index,
        'songs': songs,
      };

  static Concert fromJson(Map<String, dynamic> json) => Concert(
        name: json['name'],
        year: json['year'],
        year_index: json['year_index'],
        songs: json['songs'],
      );

  static Future<Concert> readConcert(String year_index) async {
    var document = await FirebaseFirestore.instance
        .collection('concerts')
        .doc(year_index)
        .get();
    if (document.exists) {
      Map<String, dynamic>? data = document.data();
      return Concert.fromJson(data!);
    } else {
      List noData = [];
      noData.add('No Concert');
      print('Can\'t find the concert year_index');
      return Concert(
        name: 'error',
        year: '1972',
        year_index: '1972_0',
      );
    }
  }
}
