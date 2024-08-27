import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project5_miyuki/materials/colors.dart';
import 'package:project5_miyuki/services/init_data_service.dart';
import '../../materials/InitData.dart';
import '../../services/firebase/remote_config_service.dart';
import '../MyHomePage.dart';

import 'login_or_register_page.dart';

import '../../materials/MyText.dart';

class AuthPage extends StatelessWidget {
  Future<void> _initData() async {
    await InitDataService.readMiyukiUser();
    InitData.allSongs = await RemoteConfigService().fetchAllSongs();
    //print("Song Amount: " + InitData.allSongs.length.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme_purple,
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show a loading indicator while waiting for auth state and data initialization
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            // Initialize data
            return FutureBuilder<void>(
              future: _initData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while data is being initialized
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  // Handle any errors that occur during initialization
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  // Data is initialized, show MyHomePage
                  return MyHomePage(title: APPNAME_JP);
                }
              },
            );
          } else {
            // User is not logged in, show LoginOrRegisterPage
            return LoginOrRegisterPage();
          }
        },
      ),
    );
  }
}
