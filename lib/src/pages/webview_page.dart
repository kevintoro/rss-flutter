import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  WebViewPage({Key key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  WebViewController _controller;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    String data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticia'),
        brightness: Brightness.dark,
      ),
      body: WebView(
        initialUrl: 'https://megaterios.co',
        onWebViewCreated: (controller) {
          _controller = controller;
          _loadHTMLFromString(data);
        },
        onProgress: (progress) {
          CircularProgressIndicator(
            value: progress.toDouble(),
          );
        },
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }

  void _loadHTMLFromString(String data) {
    data = data.replaceAll('<img ', '<img width="100%" ');
    data = data.replaceAll('<iframe ', '<iframe width="99%"');
    _controller.loadUrl(Uri.dataFromString(
      data,
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString());
  }
}
