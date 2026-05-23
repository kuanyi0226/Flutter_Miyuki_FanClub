import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/class/ChatMessage.dart';
import 'package:project5_miyuki/materials/InitData.dart';

class ChatroomService {
  final String chatRoomId = '2026';

  // create data
  Future createMessage({
    required String sender_email,
    required String text,
    required String senderName,
    required String? senderImgUrl,
  }) async {
    final now = DateTime.now(); // use utc time as the id of chat
    final now_utc = now.toUtc();

    final String messageId = '${now_utc.year}-' +
        '${(now_utc.month < 10) ? '0' + now_utc.month.toString() : now_utc.month}-' +
        '${(now_utc.day < 10) ? '0' + now_utc.day.toString() : now_utc.day}-' +
        '${(now_utc.hour < 10) ? '0' + now_utc.hour.toString() : now_utc.hour}:' +
        '${(now_utc.minute < 10) ? '0' + now_utc.minute.toString() : now_utc.minute}:' +
        '${(now_utc.second < 10) ? '0' + now_utc.second.toString() : now_utc.second}:' +
        '${now_utc.microsecond}';

    final docMessage = FirebaseFirestore.instance
        .collection('public-chat-room')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId);

    final message = ChatMessage(
      text: text,
      sender_email: InitData.miyukiUser.email!,
      senderName: senderName,
      senderImgUrl: senderImgUrl,
      sentTime: DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      ),
    );
    final json = message.toJson();

    // create document and write data to Firebase
    await docMessage.set(json);
  }

  // read data
  Stream<List<ChatMessage>> readMessages(int limit) {
    return FirebaseFirestore.instance
        .collection('public-chat-room')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('sentTime', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromJson(doc.data()))
            .toList());
  }
}
