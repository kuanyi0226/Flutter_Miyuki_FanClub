import 'package:flutter/material.dart';
import 'package:project5_miyuki/class/official/updateInfo.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../materials/MyText.dart';

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
        child: Column(
          children: [
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
            // MyButton(
            //     onTap: () async {
            //       if (CURR_VERSION != info!.version) {
            //         _launchURL('https', 'drive.google.com', info!.link!);
            //       } else {
            //         var snackBar = SnackBar(
            //             content: Text('The current version is up to date'));
            //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
            //       }
            //     },
            //     text: 'Download Latest Version'),
            SizedBox(height: 30),
            Text(
              'Update History',
              style: TextStyle(fontSize: 25),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: UPDATE_CONTENT.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      child: Text(UPDATE_CONTENT[index]),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
