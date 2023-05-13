import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/class/official/updateInfo.dart';

import '../../screens/auth_system/forgot_password_page.dart';
import '../../services/official_service.dart';
import './update_page.dart';
import './profile_page.dart';

class SettingsPage extends StatefulWidget {
  MiyukiUser? miyukiUser;
  SettingsPage({super.key, required this.miyukiUser});

  @override
  State<SettingsPage> createState() =>
      _SettingsPageState(miyukiUser: miyukiUser!);
}

class _SettingsPageState extends State<SettingsPage> {
  MiyukiUser? miyukiUser;
  UpdateInfo? updateInfo;
  _SettingsPageState({required MiyukiUser miyukiUser}) {
    this.miyukiUser = miyukiUser;
    _getInfo();
  }
  Future _getInfo() async {
    updateInfo = await OfficialService.getUpdateInfo();
    print('latest version is: ${updateInfo!.version}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(
                'Account',
                style: TextStyle(fontSize: 25),
              ),
            ),
            //Account
            Card(
              child: Column(children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            miyukiUser: miyukiUser,
                          ))),
                  child: ListTile(
                    title: Text(
                      'Profile',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ForGotPasswordPage())),
                  child: ListTile(
                    title: Text(
                      'Forgot Password',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ]),
            ),
            //About
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(
                'About Us',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Card(
              child: Column(children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdatePage(info: updateInfo))),
                  child: ListTile(
                    title: Text(
                      'Check Update',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
