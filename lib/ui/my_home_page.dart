import 'package:flutter/material.dart';
import 'package:max_throw/style/style.dart';
import 'package:max_throw/ui/acceleration_meter.dart';
import 'package:max_throw/ui/button.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _activated = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _activated = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: <Widget>[
              //if activated then it will show real time acceleration
              _activated ? AccelerationMeter() : _heading(),
              Button(
                //activates the AccelerationMeter widget and enters inside the game.
                onTap: () => setState(() {
                  _activated ? _activated = false : _activated = true;
                }),
                fontSize: _activated ?36:40,
                //sets the button size and animates it
                size: _activated ? 100 : 290,
                text: _activated ? "Stop" : "Start",
                color: _activated ? Colors.red : Colors.green,
              )
            ],
          ),
        ),
      ),
    );
  }


  //this widget contains the heading and body of startup page
  Widget _heading() => SizedBox(
        height: 520,
        child: Container(
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 50,
              ),
              Text(
                "Max-Throw",
                style: headingStyle,
              ),
              SizedBox(
                height: 70,
              ),
              Text(
                "Hold your phone firmly and then jerk it as fast as you can to win the game.\n Your phone records the maximum acceleration.",
                textAlign: TextAlign.justify,
                style: subHeadingStyle,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Caution : Make sure that you holds the phone tightly",
                textAlign: TextAlign.justify,
                style: subHeadingStyle,
              ),
            ],
          ),
        ),
      );
}
