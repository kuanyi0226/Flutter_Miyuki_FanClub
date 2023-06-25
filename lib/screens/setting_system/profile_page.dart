import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';
import 'package:project5_miyuki/materials/InitData.dart';
import 'package:provider/provider.dart';

import '../../materials/colors.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage();

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState();

  Future _editUserName(String originalName) {
    final nameController = TextEditingController();
    nameController.text = originalName;
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'Edit User Name',
                style: TextStyle(color: theme_purple, fontSize: 20),
              ),
              content: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'New User Name'),
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      if (Provider.of<InternetConnectionStatus>(context,
                              listen: false) ==
                          InternetConnectionStatus.connected) {
                        setState(() {
                          MiyukiUser.editUserName(nameController.text);
                          InitData.miyukiUser.name = nameController.text;
                        });
                      } else {
                        const snackBar =
                            SnackBar(content: Text('No Wifi Connection'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Edit',
                      style: TextStyle(color: theme_purple, fontSize: 20),
                    )),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //User Name
              ListTile(
                title: Text(
                  'User Name',
                  style: TextStyle(fontSize: 23),
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
                  'Email',
                  style: TextStyle(fontSize: 23),
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
                  'Yuki Coin',
                  style: TextStyle(fontSize: 23),
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
                  'Vip Type',
                  style: TextStyle(fontSize: 23),
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
