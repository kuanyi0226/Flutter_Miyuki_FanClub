import 'package:cloud_firestore/cloud_firestore.dart';

class Concert {
  String year;
  String year_index;
  String name;
  List? songs;

  Concert({
    required this.name,
    required this.year,
    required this.year_index,
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
}
