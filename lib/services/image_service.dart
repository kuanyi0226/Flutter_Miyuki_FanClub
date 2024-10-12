import 'dart:typed_data';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as IMG;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import '../screens/setting_system/profile_page.dart';

class ImageService {
  //select a photo from Phone
  static pickImage(ImageSource source) async {
    final ImagePicker _imagePicker = ImagePicker();
    XFile? _file = await _imagePicker.pickImage(source: source);

    if (_file != null) {
      return await _file.readAsBytes();
    }
    print('No Img Selected');
    ProfilePage.imgSelectJudge = 'No Img Selected';
  }

  //store the img to firebase store
  static Future<String> uploadImageToStorage(
      String childName, Uint8List file) async {
    //resize img
    Map<String, dynamic> exif = await readExifFromBytes(file);

    IMG.Image? img = IMG.decodeImage(file);
    if (exif['Image Orientation'].toString() == 'Rotated 90 CW' ||
        exif['Image Orientation'].toString() == 'Rotated 90 CCW') {
      img = IMG.copyRotate(img!, angle: 90);
    }
    IMG.Image resized = IMG.copyResize(img!, height: 200);
    Uint8List resizedImg = Uint8List.fromList(IMG.encodeJpg(resized));

    final FirebaseStorage _storage = FirebaseStorage.instance;

    Reference ref = _storage.ref().child(childName);
    UploadTask uploadTask = ref.putData(resizedImg);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> saveData({required Uint8List file}) async {
    String resp = 'img: Some error occured';
    try {
      User? user = await FirebaseAuth.instance.currentUser;
      String imgUrl = await uploadImageToStorage('userImg/${user!.uid}', file);
      await user.updatePhotoURL(imgUrl);
      InitData.miyukiUser.imgUrl = imgUrl;
      resp = 'Successfully upload img!';
    } catch (err) {
      resp = err.toString();
    }
    return resp;
  }
}
