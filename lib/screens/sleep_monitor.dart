import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SleepMonitor extends StatefulWidget {
  @override
  SleepMonitorState createState() => SleepMonitorState();
}

class SleepMonitorState extends State<SleepMonitor> {
  String _timeString;
  String _amPmString;
  Timer timer;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    _amPmString = _formatTimeOfDay(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedTime;
      _amPmString = _formatTimeOfDay(now);
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat("hh:mm").format(dateTime);
  }

  String _formatTimeOfDay(DateTime dateTime) {
    return DateFormat("a").format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 0.0,
        elevation: 0.0,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
      ),
      backgroundColor: Color(0xff000000),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            constraints: BoxConstraints.expand(),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/sunrise.jpg"),
                    fit: BoxFit.cover)),
          ),
          Container(
            margin: EdgeInsets.only(top: 120.0),
            child: Align(
                alignment: FractionalOffset.topCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("$_timeString",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 70.0,
                          fontWeight: FontWeight.w500,
                        )),
                    SizedBox(
                      width: 4,
                    ),
                    Text("$_amPmString",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w300,
                        )),
                  ],
                )),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 90.0),
            child: Align(
              alignment: FractionalOffset.bottomCenter,
              child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.stop_circle_outlined,
                        color: Colors.white,
                        semanticLabel: "Stop",
                        size: 70.0,
                      ),
                      Text(
                        "Tap to stop",
                        style: TextStyle(color: Colors.white54),
                      )
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
