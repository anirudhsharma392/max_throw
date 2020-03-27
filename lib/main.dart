import 'dart:io';

import 'package:flutter/material.dart';
import 'package:max_throw/style/style.dart';

import 'ui/my_home_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Platform.isAndroid ? MyHomePage() : Warning(),
    );
  }
}

class Warning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Only Android is Supported",
          style: subHeadingStyle,
        ),
      ),
    );
  }
}
