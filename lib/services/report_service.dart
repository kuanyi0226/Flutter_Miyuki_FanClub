import 'package:cloud_firestore/cloud_firestore.dart';

class ReportService {
  //create report
  static Future createReport({
    required String sender, //report from whom
    required String type, //from where
    required String text, //content
  }) async {
    //Reference document
    final now = DateTime.now();
    String docId = now.toString(); //sent time is the doc's id
    final docMessage =
        FirebaseFirestore.instance.collection('reports').doc(docId);

    final report = Report(
      sender: sender,
      type: type,
      text: text,
      sentTime: DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
      ),
    );
    final json = report.toJson();

    //create document and write data to Firebase
    await docMessage.set(json);
  }
}

class Report {
  String sender;
  String type;
  String text;
  final DateTime sentTime;

  Report({
    required this.sender, //report from whom
    required this.type, //from where
    required this.text, //content
    required this.sentTime,
  });

  Map<String, dynamic> toJson() => {
        'sender': sender,
        'type': type,
        'text': text,
        'sentTime': sentTime,
      };
}
