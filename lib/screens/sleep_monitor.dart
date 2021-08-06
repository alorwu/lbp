import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SleepMonitor extends StatefulWidget {
  @override
  SleepMonitorState createState() => SleepMonitorState();
}

class SleepMonitorState extends State<SleepMonitor> {
  String _timeString;
  Timer timer;

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat("hh:mm a").format(dateTime);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep Better"),
        backgroundColor: Color(0xff000000),
        elevation: 0.0,
        brightness: Brightness.dark,
      ),
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
            constraints: BoxConstraints.expand(),
            color: Colors.black54,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Daily survey
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {},
                        child: Card(
                          elevation: 3.0,
                          color: Colors.black38,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Today's survey",
                                    style:
                                        TextStyle(color: Colors.white54)),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Not completed yet. Click to open",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14.0)),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(5.0),
                                      child: Image.asset(
                                        'images/sadd.png',
                                        height: 40.0,
                                        width: 40.0,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                      ),
                      ),
                    ),
                  ],
                ),
                  // Monthly surveys
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {},
                      child: Card(
                          elevation: 3.0,
                          color: Colors.black38,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Monthly sleep survey",
                                    style:
                                    TextStyle(color: Colors.white54)),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Click to open",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0)),
                                    Icon(
                                      Icons.alarm,
                                      color: Colors.blue,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                      ),
                    ),

                    // Sleep duration
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {},
                      child: Card(
                          elevation: 3.0,
                          color: Colors.black26,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Quality of life survey",
                                    style: TextStyle(color: Colors.white54)
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Click to open",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12.0)),
                                    Icon(
                                      Icons.alarm,
                                      color: Colors.green,
                                    )
                                  ],
                                )
                              ],
                            ),
                          )),
                      ),
                    ),
                  ],
                ),

                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.all(20),
                  child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<
                            RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          ),
                        ),
                      ),
                      icon: Icon(Icons.play_arrow_rounded),
                      label: Text(
                        "Start Sleep",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      )),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 80.0),
            child: Align(
              alignment: FractionalOffset.center,
              child: Text(
                  "$_timeString",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 43.0,
                      fontWeight: FontWeight.bold,
                  )
              ),
            ),
          ),

        ],
      ),
    );
  }
}
