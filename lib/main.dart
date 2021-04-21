import 'package:flutter/material.dart';
import 'package:rss_reader/src/pages/home_page.dart';
import 'package:rss_reader/src/pages/webview_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomePage(),
        'webview': (BuildContext context) => WebViewPage(),
      },
    );
  }
}
