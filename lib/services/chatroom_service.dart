import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project5_miyuki/class/ChatMessage.dart';
import 'package:project5_miyuki/materials/InitData.dart';

class ChatroomService {
  //create data
  Future createMessage({
    required String sender_email,
    required String text,
    required String senderName,
    required String? senderImgUrl,
  }) async {
    //Reference document
    final now = DateTime.now(); //use utc time as the id of chat
    final now_utc = now.toUtc();
    final docMessage = FirebaseFirestore.instance
        .collection('public-chat-room')
        .doc('${now_utc.year}-' +
            '${(now_utc.month < 10) ? '0' + now_utc.month.toString() : now_utc.month}-' +
            '${(now_utc.day < 10) ? '0' + now_utc.day.toString() : now_utc.day}-' +
            '${(now_utc.hour < 10) ? '0' + now_utc.hour.toString() : now_utc.hour}:' +
            '${(now_utc.minute < 10) ? '0' + now_utc.minute.toString() : now_utc.minute}:' +
            '${(now_utc.second < 10) ? '0' + now_utc.second.toString() : now_utc.second}:' +
            '${now_utc.microsecond}');

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

    //create document and write data to Firebase
    await docMessage.set(json);
  }

  //read data
  Stream<List<ChatMessage>> readMessages() {
    return FirebaseFirestore.instance
        .collection('public-chat-room')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromJson(doc.data()))
            .toList());
  }
}
