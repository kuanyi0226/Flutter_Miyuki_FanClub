import 'package:flutter/material.dart';
import 'package:project5_miyuki/services/firebase/remote_config_service.dart';
import '../../materials/MyText.dart';
import '../../services/firebase/official_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdatePage extends StatefulWidget {
  const UpdatePage({super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  String _latestVersion = "Wait for fetching data...";

  @override
  void initState() {
    fetchAppVersion();
    //print('latest version is: ${updateInfo.version}');
    super.initState();
  }

  void fetchAppVersion() async {
    String version = await RemoteConfigService().fetchAppVersion();
    setState(() {
      _latestVersion = version;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.check_update),
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
              'Latest Version: $_latestVersion',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(height: 20),
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

// Future<void> _launchURL(String scheme, String url, String path) async {
//   final Uri uri = (path != "")
//       ? Uri(scheme: scheme, host: url, path: path)
//       : Uri(scheme: scheme, host: url);
//   if (!await launchUrl(
//     uri,
//     mode: LaunchMode.externalNonBrowserApplication,
//   )) {
//     throw "Can not launch the url";
//   }
// }
