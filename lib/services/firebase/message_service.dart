import '../../class/Message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MessageService {
  //create data
  Future createMessage({
    required String target_to_send,
    required String currMessage,
    required String text,
    required String userName,
    required String? senderImgUrl,
  }) async {
    //Reference document
    final docMessage = FirebaseFirestore.instance
        .collection(target_to_send)
        .doc('message' + currMessage);
    final now = DateTime.now();

    final message = Message(
      text: text,
      id: int.parse(currMessage),
      userName: userName,
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
  Stream<List<Message>> readMessages({required String target_to_read}) {
    return FirebaseFirestore.instance
        .collection(target_to_read)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromJson(doc.data())).toList());
  }
}
