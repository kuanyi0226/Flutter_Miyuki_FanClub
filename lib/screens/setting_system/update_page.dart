import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/official/updateInfo.dart';
import 'package:project5_miyuki/widgets/MyButton.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../materials/text.dart';

class UpdatePage extends StatelessWidget {
  UpdateInfo? info;
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
          MyButton(
              onTap: () async =>
                  _launchURL('https', 'drive.google.com', info!.link!),
              text: 'Download Latest Version'),
        ]),
      ),
    );
  }
}

Future<void> _launchURL(String scheme, String url, String path) async {
  final Uri uri = (path != "")
      ? Uri(scheme: scheme, host: url, path: path)
      : Uri(scheme: scheme, host: url);
  if (!await launchUrl(
    uri,
    mode: LaunchMode.externalNonBrowserApplication,
  )) {
    throw "Can not launch the url";
  }
}
