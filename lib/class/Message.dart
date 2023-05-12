import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  Message({
    this.id = '',
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'age': age,
        'birthday': birthday,
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        name: json['name'],
        age: json['age'],
        birthday: (json['birthday'] as Timestamp).toDate(),
      );
}
