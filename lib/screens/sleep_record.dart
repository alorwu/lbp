import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/hive/DailyQ.dart';

class SleepRecordScreen extends StatefulWidget {
  @override
  SleepRecordState createState() => SleepRecordState();
}

const DATE_FORMAT_DAY = "yMMMMd";
const DATE_FORMAT_DAY_TIME = "hh:mm";
const DATE_FORMAT_AM_PM = " a";

class SleepRecordState extends State<SleepRecordScreen> {

  Box<DailyQ> list;

  @override
  initState() {
    super.initState();
    list = Hive.box('testBox');
  }

  Widget dailyCard(int index, DailyQ data) {
    return Card(
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
                  DateFormat(DATE_FORMAT_DAY).format(data.dateTaken),
                  style: TextStyle(color: Colors.white54),
                ),
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
                Text("Sleep at", style: TextStyle(color: Colors.white54)),
                Text("Sleep duration", style: TextStyle(color: Colors.white54),),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: DateFormat(DATE_FORMAT_DAY_TIME).format(data.sleepTime),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: DateFormat(DATE_FORMAT_AM_PM).format(data.sleepTime),
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300))
                    ])),
                RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: data.sleepPeriod[0].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16.0)
                      ),
                      TextSpan(
                          text: "h ",
                          style: TextStyle(color: Colors.white54)
                      ),
                      TextSpan(
                          text: data.sleepPeriod[1].toString(),
                          style: TextStyle(color: Colors.white, fontSize: 16.0)
                      ),
                      TextSpan(
                          text: " min",
                          style: TextStyle(color: Colors.white54)
                      ),
                    ])),
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
                Text("Sleep score",
                    style: TextStyle(color: Colors.white54))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: DateFormat(DATE_FORMAT_DAY_TIME).format(data.wakeupTime),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300)),
                      TextSpan(
                          text: DateFormat(DATE_FORMAT_AM_PM).format(data.wakeupTime),
                          style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14.0,
                              fontWeight: FontWeight.w300))
                    ])),
                RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: data.qualityOfSleep.toString(),
                          style: TextStyle(
                              color: Colors.white, fontSize: 16.0)),
                      TextSpan(
                          text: "/10",
                          style: TextStyle(
                              color: Colors.white54, fontSize: 16.0))
                    ])),
              ],
            ),
          ],
        ),
      ),
    );
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text('Sleep records'),
            backgroundColor: Color(0xff000000),
            elevation: 0.0,
            // systemOverlayStyle: SystemUiOverlayStyle.dark,
            brightness: Brightness.dark,
          ),
          backgroundColor: Color(0xff000000),
          body: ValueListenableBuilder(
            valueListenable: list.listenable(),
            builder: (context, Box<DailyQ> box, _) {
              return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, listIndex) {
                        return dailyCard(listIndex, list.getAt(listIndex));
                      }
              );
            },
          ),
      );
    }
  }

