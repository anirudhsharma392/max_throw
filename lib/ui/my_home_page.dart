import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const stream = const EventChannel('com.gsoc.eventchannel/stream');

  //contains magnitude of acceleration
  var _accelaration;
  StreamSubscription _timerSubscription;

  //call this method to start subscription event
  void _enableSubscription() {
    if (_timerSubscription == null) {
      _timerSubscription =
          stream.receiveBroadcastStream().listen(_updateAcceleration);
    }
  }

  //call this method to dispose subscription event
  void _disableSubscription() {
    if (_timerSubscription != null) {
      _timerSubscription.cancel();
      _timerSubscription = null;
    }
  }

  void _updateAcceleration(timer) {
    debugPrint("Timer $timer");
    setState(() => _accelaration = timer);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.all(8.0),
          child: Card(),
        ));
  }
}
