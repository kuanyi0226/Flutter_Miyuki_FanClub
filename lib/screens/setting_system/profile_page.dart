import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/MiyukiUser.dart';

import '../../materials/colors.dart';

class ProfilePage extends StatefulWidget {
  MiyukiUser? miyukiUser;
  ProfilePage({required this.miyukiUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState(miyukiUser: miyukiUser);
}

class _ProfilePageState extends State<ProfilePage> {
  MiyukiUser? miyukiUser;
  _ProfilePageState({required this.miyukiUser});

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
                      setState(() {
                        MiyukiUser.editUserName(
                            nameController.text, miyukiUser!);
                        miyukiUser!.name = nameController.text;
                        Navigator.of(context).pop();
                      });
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
                  onTap: () => _editUserName(miyukiUser!.name!),
                  child: ListTile(
                    title: Text(
                      miyukiUser!.name!,
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
                  miyukiUser!.email!,
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
                  (miyukiUser!.vip == true)
                      ? '❆❆❆ VIP User ❆❆❆'
                      : 'Normal User',
                  style: (miyukiUser!.vip == true)
                      ? TextStyle(fontSize: 20, color: theme_light_blue)
                      : TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
