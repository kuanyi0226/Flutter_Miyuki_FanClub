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

  late WebViewController _controller;

  _SimpleWebView({required this.initialUrl, this.webTitle}) {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(initialUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(webTitle!)),
      body: WebViewWidget(controller: _controller),
    );
  }
}
