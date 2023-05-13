import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/official/updateInfo.dart';
import 'package:project5_miyuki/widgets/MyButton.dart';

import '../../materials/text.dart';

import '../../services/official_service.dart';

class UpdatePage extends StatelessWidget {
  UpdateInfo? info;
  //String latestVersion = 'No Data';
  UpdatePage({required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Check Update'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(children: [
          Icon(
            Icons.update,
            color: Color.fromARGB(255, 117, 183, 236),
            size: 100,
          ),
          Text(
            'Current Version: $CURR_VERSION',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 50),
          Text(
            'Latest Version: ${info!.version}',
            style: TextStyle(fontSize: 25),
          ),
          SizedBox(height: 20),
          MyButton(onTap: () {}, text: 'Download Latest Version'),
        ]),
      ),
    );
  }
}
