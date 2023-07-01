import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final int id;
  String text = '';
  final DateTime sentTime;
  String? userName = '匿名';
  String? senderImgUrl;

  Message({
    required this.id,
    required this.text,
    this.userName,
    required this.sentTime,
    required this.senderImgUrl,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'userName': userName,
        'text': text,
        'sentTime': sentTime,
        'senderImgUrl': senderImgUrl,
      };

  static Message fromJson(Map<String, dynamic> json) => Message(
        id: json['id'],
        userName: json['userName'],
        text: json['text'],
        sentTime: (json['sentTime'] as Timestamp).toDate(),
        senderImgUrl: json['senderImgUrl'],
      );
}
