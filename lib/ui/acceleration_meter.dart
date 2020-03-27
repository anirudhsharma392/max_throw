import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:max_throw/style/style.dart';

class AccelerationMeter extends StatefulWidget {
  @override
  _AccelerationMeterState createState() => _AccelerationMeterState();
}

class _AccelerationMeterState extends State<AccelerationMeter> {
  static const stream = const EventChannel('com.gsoc.eventchannel/stream');
  StreamSubscription _timerSubscription;

  //contains magnitude of acceleration
  var _acceleration;
  //array of top 5 acceleration
  List maxAcceleration = [0.0, 0.0, 0.0, 0.0, 0.0];
  //space between widgets
  double _space = 20;
  //background color of a score widget
  Color _color = primary;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('asd');
    _enableSubscription();
  }

  @override
  void dispose() {
    _disableSubscription();
    // TODO: implement dispose
    super.dispose();
  }

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

  //called after every 200 millisecond to detect any change in the accelerometer sensor
  void _updateAcceleration(value) {
    debugPrint("Timer $value");
    setState(() {
      _acceleration = value;

      //sets the maximum value inside an array in decreasing order
      (maxAcceleration[0] < value && value > 30)
          ? maxAcceleration.insert(0, value)
          : null;

      //assigns color dynamically acc. to the value
      //red means maximum
      if (value > 11 && value < 15) {
        _color = green;
      } else if (value >= 15 && value < 20) {
        _color = Colors.orange;
      } else if (value >= 20) {
        _color = red;
      } else {
        _color = primary;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Column(
      children: <Widget>[
        y(_space * 3),
        _score(width),
        y(_space * 1),
        Text(
          "Top 5",
          style: TextStyle(
              fontSize: 30,
              fontFamily: 'raleway',
              fontWeight: FontWeight.w700,
              color: Colors.green),
        ),
        y(_space * 1),
        Top5(maxAcceleration)
      ],
    );
  }

  //gives a vertical margin
  Widget y(ht) => SizedBox(height: ht);
  //gives a horizontal margin
  Widget x(ht) => SizedBox(height: ht);

  Widget _score(wt) => Container(
        width: wt,
        decoration: BoxDecoration(
            color: _color, borderRadius: BorderRadius.circular(20)),
        child: Column(
          children: <Widget>[
            y(_space * 1.5),
            Text(
              "Acceleration Score",
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'raleway',
                  fontWeight: FontWeight.w700,
                  color: white),
            ),
            y(_space / 2),
            Text(
              "${_acceleration?.toStringAsFixed(3) ?? "  --  "} m/s²",
              style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'baloo',
                  fontWeight: FontWeight.w600,
                  color: white),
            ),
            y(_space * 1.5),
          ],
        ),
      );
}

class Top5 extends StatelessWidget {
  List maxAcceleraion;
  Top5(this.maxAcceleraion);
  Color _borderColor = primary;

  double _borderRadius = 20;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: _borderColor,
          width: 8,
        ),
        borderRadius: BorderRadius.circular(_borderRadius),
      ),
      child: Column(
        children: <Widget>[
          _row(true, "1", maxAcceleraion[0]),
          _row(false, "2", maxAcceleraion[1]),
          _row(true, "3", maxAcceleraion[2]),
          _row(false, "4", maxAcceleraion[3]),
          _row(true, "5", maxAcceleraion[4]),
        ],
      ),
    );
  }

  Widget _row(bool odd, String index, double score) {
    return Container(
      width: 250,
      height: 43,
      child: Row(
        children: <Widget>[
          Container(
            width: 43,
            color: odd ? _borderColor : Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              index,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'raleway',
                  fontWeight: FontWeight.w700,
                  color: odd ? Colors.white : _borderColor),
            ),
          ),
          Flexible(
              child: Container(
            color: odd ? _borderColor : Colors.transparent,
            alignment: Alignment.center,
            child: Text(
              "${score == 0 ? "   --   " : score?.toStringAsFixed(3)} m/s²",
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'raleway',
                  fontWeight: FontWeight.w700,
                  color: odd ? Colors.white : _borderColor),
            ),
          ))
        ],
      ),
    );
  }
}
