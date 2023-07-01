import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SimpleWebView extends StatefulWidget {
  String initialUrl;
  String? webTitle;
  SimpleWebView({
    super.key,
    required this.initialUrl,
    this.webTitle,
  });

  @override
  State<SimpleWebView> createState() =>
      _SimpleWebView(initialUrl: initialUrl, webTitle: webTitle);
}

class _SimpleWebView extends State<SimpleWebView> {
  String initialUrl;
  String? webTitle = '';

  late WebViewController controller;

  _SimpleWebView({required this.initialUrl, this.webTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(webTitle!)),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: initialUrl,
        onWebViewCreated: (controller) {
          this.controller = controller;
        },
      ),
    );
  }
}
