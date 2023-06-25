import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/class/official/updateInfo.dart';

import '../../screens/auth_system/forgot_password_page.dart';
import '../../services/official_service.dart';
import './update_page.dart';
import './profile_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  UpdateInfo? updateInfo;
  _SettingsPageState() {
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
                  onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ProfilePage())),
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
            //More info
            ListTile(
              leading: const Icon(Icons.info),
              title: Text(
                'More Info And Support',
                style: TextStyle(fontSize: 25),
              ),
            ),
            Card(
              child: Column(children: [
                //About App
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdatePage(info: updateInfo))),
                  child: ListTile(
                    title: Text(
                      'About App',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
                //Help and QAs
                GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdatePage(info: updateInfo))),
                  child: ListTile(
                    title: Text(
                      'Help and QAs',
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
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
