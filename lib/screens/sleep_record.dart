

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SleepRecordScreen extends StatefulWidget {
  @override
  SleepRecordState createState() => SleepRecordState();
}

class SleepRecordState extends State<SleepRecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep records'),
        backgroundColor: Color(0xff000000),
          elevation: 0.0,
          brightness: Brightness.dark,
      ),
    );
  }

}