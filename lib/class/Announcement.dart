import 'package:cloud_firestore/cloud_firestore.dart';

class Announcement {
  final String id;
  final String description;
  final String imageUrl;
  final String clickUrl;
  final DateTime timestamp;

  Announcement({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.clickUrl,
    required this.timestamp,
  });

  factory Announcement.fromJson(Map<String, dynamic> json, String docId) {
    return Announcement(
      id: docId,
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      clickUrl: json['clickUrl'] ?? '',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'imageUrl': imageUrl,
      'clickUrl': clickUrl,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}
