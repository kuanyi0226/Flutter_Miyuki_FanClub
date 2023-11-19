import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String sender_email;
  String? senderName = '匿名';
  String text = '';
  final DateTime sentTime;
  String? senderImgUrl;

  ChatMessage({
    required this.sender_email,
    required this.text,
    this.senderName,
    required this.sentTime,
    required this.senderImgUrl,
  });

  Map<String, dynamic> toJson() => {
        'sender_email': sender_email,
        'senderName': senderName,
        'text': text,
        'sentTime': sentTime,
        'senderImgUrl': senderImgUrl,
      };

  static ChatMessage fromJson(Map<String, dynamic> json) => ChatMessage(
        sender_email: json['sender_email'],
        senderName: json['senderName'],
        text: json['text'],
        sentTime: (json['sentTime'] as Timestamp).toDate(),
        senderImgUrl: json['senderImgUrl'],
      );
}
