import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:lbp/model/hive/DailyQ.dart';

class SleepRecordScreen extends StatefulWidget {
  @override
  SleepRecordState createState() => SleepRecordState();
}

class SleepRecordState extends State<SleepRecordScreen> {
  Widget dailyCard = Card(
    color: Color(0xff1f1f1f),
    elevation: 5.0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    child: Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "Date: 01/08 ",
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Sleep score",
                  style: TextStyle(color: Colors.white54)),
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "5.0",
                        style: TextStyle(
                            color: Colors.white, fontSize: 38.0)),
                    TextSpan(
                        text: "/10",
                        style: TextStyle(
                            color: Colors.white54, fontSize: 18.0))
                  ])),
            ],
          ),

          SizedBox(
            height: 15.0,
          ),
          Divider(height: 1.0, color: Colors.white70),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Duration",
                style: TextStyle(color: Colors.white54),
              ),
              Text("Sleep at",
                  style: TextStyle(color: Colors.white54))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "7 ",
                        style: TextStyle(
                            color: Colors.white, fontSize: 20.0)),
                    TextSpan(
                        text: "h ",
                        style: TextStyle(color: Colors.white54)),
                    TextSpan(
                        text: "31 ",
                        style: TextStyle(
                            color: Colors.white, fontSize: 20.0)),
                    TextSpan(
                        text: "min",
                        style: TextStyle(color: Colors.white54))
                  ])),
              Text(
                "08:40 PM",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          SizedBox(height: 15.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Wake at",
                style: TextStyle(color: Colors.white54),
              ),
              Text("Ambient noise",
                  style: TextStyle(color: Colors.white54))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("04:00 AM",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w300)),
              RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: "25 ",
                        style: TextStyle(
                            color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w300)),
                    TextSpan(
                        text: "db",
                        style: TextStyle(color: Colors.white54))
                  ])),
            ],
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep records'),
        backgroundColor: Color(0xff000000),
        elevation: 0.0,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      backgroundColor: Color(0xff000000),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            dailyCard,
            dailyCard,
            dailyCard,
            dailyCard,
            dailyCard
          ],
        ),
      ),
    );
  }
}
