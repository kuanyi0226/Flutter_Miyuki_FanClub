import 'package:cloud_firestore/cloud_firestore.dart';

class Song {
  String name;
  String? author = '中島みゆき'; //作詞
  String? composer = '中島みゆき'; //作曲
  List? live;

  String? lyrics_jp;
  String? lyrics_cn;
  String? lyrics_en;

  List? comment;
  String? review_cn;
  String? review_en;

  Song({
    required this.name,
    required this.author,
    required this.composer,
    this.live,
    this.lyrics_jp,
    this.lyrics_en,
    this.lyrics_cn,
    this.comment,
    this.review_cn,
    this.review_en,
  });

  Map<String, dynamic> toJson() => {
        '1': name,
        '2': author,
        '3': composer,
        '4': live,
        '5': comment,
        '6': review_cn,
        '7': review_en,
        '8': lyrics_jp,
        '9': lyrics_cn,
        '10': lyrics_en,
      };

  static Song fromJson(Map<String, dynamic> json) => Song(
        name: json['1'],
        author: json['2'],
        composer: json['3'],
        live: json['4'],
        comment: json['5'],
        review_cn: json['6'],
        review_en: json['7'],
        lyrics_jp: json['8'],
        lyrics_cn: json['9'],
        lyrics_en: json['10'],
      );

  static Future<Song> readSong(String name) async {
    var document =
        await FirebaseFirestore.instance.collection('songs').doc(name).get();
    if (document.exists) {
      Map<String, dynamic>? data = document.data();
      return Song.fromJson(data!);
    } else {
      return Song(
        name: 'error',
        author: 'error',
        composer: 'error',
        live: null,
        lyrics_jp: '',
        lyrics_cn: '',
        lyrics_en: '',
        comment: null,
        review_cn: '',
        review_en: '',
      );
    }
  }

  //add comment
  static Future addComment(String songName, String newComment) async {
    Song currSong = await Song.readSong(songName);
    List<dynamic>? currComments = currSong.comment;
    if (currComments!.elementAt(0) == '') {
      //every song's comment was init as ''
      currComments.clear();
    }
    currComments.add(newComment);
    await FirebaseFirestore.instance
        .collection('songs')
        .doc(songName)
        .update({'5': currComments});
  }

  //delete comment
  static Future deleteComment(String songName, String deleteComment) async {
    Song currSong = await Song.readSong(songName);
    List<dynamic>? currComments = currSong.comment;
    //find target comment in the list
    for (int i = 0; i < currComments!.length; i++) {
      if (currComments.elementAt(i) == deleteComment) {
        currComments.removeAt(i); //delete comment
        break;
      }
    }
    //avoid error: don't let the list be empty
    if (currComments.isEmpty) {
      currComments.add('');
    }
    await FirebaseFirestore.instance
        .collection('songs')
        .doc(songName)
        .update({'5': currComments});
  }
}
