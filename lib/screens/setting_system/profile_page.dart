import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:project5_miyuki/services/yukicoin_service.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../materials/colors.dart';
import '../../services/image_service.dart';

class ProfilePage extends StatefulWidget {
  static String imgSelectJudge = '';
  ProfilePage();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _image;
  final UPDATE_IMG_COST = 50;

  Future _editUserName(String originalName) {
    final nameController = TextEditingController();
    nameController.text = originalName;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                AppLocalizations.of(context)!.username_edit,
                style: TextStyle(color: theme_purple, fontSize: 20),
              ),
              content: TextField(
                controller: nameController,
                decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.new_username),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      String snackBarText = '';
                      if (kIsWeb ||
                          Provider.of<InternetConnectionStatus>(context,
                                  listen: false) ==
                              InternetConnectionStatus.connected) {
                        if (nameController.text != '' &&
                            nameController.text.length < 18) {
                          setState(() {
                            MiyukiUser.editUserName(nameController.text);
                            InitData.miyukiUser.name = nameController.text;
                          });
                        } else {
                          snackBarText =
                              AppLocalizations.of(context)!.username_edit_error;
                          var snackBar = SnackBar(content: Text(snackBarText));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      } else {
                        snackBarText = AppLocalizations.of(context)!.no_wifi;
                        var snackBar = SnackBar(content: Text(snackBarText));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context)!.edit,
                      style: TextStyle(color: theme_purple, fontSize: 20),
                    )),
              ],
            ));
  }

  void _selectImg() async {
    ProfilePage.imgSelectJudge = '';
    Uint8List? img = await ImageService.pickImage(ImageSource.gallery);
    print('ImgSelectJudge: ' + ProfilePage.imgSelectJudge);
    if (ProfilePage.imgSelectJudge == 'No Img Selected') {
    } else {
      return showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(
                  '写真を更新する',
                  style: TextStyle(color: theme_purple, fontSize: 20),
                ),
                content: Text(
                    'Update Photo will cost \$$UPDATE_IMG_COST Yuki Coin, sure to update your photo?'),
                actions: [
                  TextButton(
                      onPressed: () async {
                        var snackBarText = '';
                        if (kIsWeb ||
                            Provider.of<InternetConnectionStatus>(context,
                                    listen: false) ==
                                InternetConnectionStatus.connected) {
                          //check money
                          if (InitData.miyukiUser.coin! >= UPDATE_IMG_COST) {
                            YukicoinService.addCoins(0 - UPDATE_IMG_COST);
                            snackBarText = 'Successfully updated photo!' +
                                AppLocalizations.of(context)!
                                    .remaining_yukicoin +
                                ': \$${InitData.miyukiUser.coin}';
                            var snackBar =
                                SnackBar(content: Text(snackBarText));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pop();
                            _image = img;
                            String uploadResponse =
                                await ImageService.saveData(file: _image!);
                            print(uploadResponse);
                            setState(() {});
                          } else {
                            snackBarText =
                                AppLocalizations.of(context)!.money_not_enough;
                            var snackBar =
                                SnackBar(content: Text(snackBarText));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.of(context).pop();
                          }
                        } else {
                          snackBarText = 'Update failed!' +
                              AppLocalizations.of(context)!.no_wifi;
                          var snackBar = SnackBar(content: Text(snackBarText));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Update Photo',
                        style: TextStyle(color: theme_purple, fontSize: 20),
                      )),
                ],
              ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.profile),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //Image
              Stack(
                children: [
                  (_image != null)
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : (InitData.miyukiUser.imgUrl != null)
                          ? CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  NetworkImage(InitData.miyukiUser.imgUrl!))
                          : CircleAvatar(
                              radius: 64,
                              backgroundImage:
                                  AssetImage('assets/images/logo.png')),
                  Positioned(
                    child: IconButton(
                      onPressed: _selectImg,
                      icon: Icon(Icons.add_a_photo),
                    ),
                    bottom: -10,
                    left: 80,
                  )
                ],
              ),
              //User Name
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.user_name,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Card(
                child: Column(children: [
                  GestureDetector(
                    onTap: () => _editUserName(InitData.miyukiUser.name!),
                    child: ListTile(
                      title: Text(
                        InitData.miyukiUser.name!,
                        style: TextStyle(fontSize: 20),
                      ),
                      trailing: Icon(Icons.edit),
                    ),
                  ),
                ]),
              ),
              //Email
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.email,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    InitData.miyukiUser.email!,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              //Yuki Coin
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.yuki_coin,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    '\$ ${InitData.miyukiUser.coin}',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              //Vip Type
              ListTile(
                title: Text(
                  AppLocalizations.of(context)!.user_type,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Card(
                child: ListTile(
                  title: Text(
                    (InitData.miyukiUser.vip == true)
                        ? '❆❆❆ VIP User ❆❆❆'
                        : 'Normal User',
                    style: (InitData.miyukiUser.vip == true)
                        ? TextStyle(fontSize: 20, color: theme_light_blue)
                        : TextStyle(fontSize: 20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
