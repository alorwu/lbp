import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/hive/daily/DailyQ.dart';
import 'package:lbp/constants/Constants.dart';
import 'package:lbp/screens/questionnaires/daily_questionnaire_screen.dart';

class TrendScreen extends StatefulWidget {
  @override
  TrendScreenState createState() => TrendScreenState();
}

class TrendScreenState extends State<TrendScreen> {
  Box<DailyQ> box;
  List<DailyQ> weekData;
  List<DailyQ> monthData;
  List<DailyQ> allData;

  var avgWeekSleepTime;
  var avgWeekWakeTime;

  var avgMonthSleepTime;
  var avgMonthWakeTime;

  var avgAllSleepTime;
  var avgAllWakeTime;

  var now = new DateTime.now();

  @override
  initState() {
    super.initState();
    var week = now.subtract(Duration(days: 7));
    var month = DateTime(now.year, now.month-1, now.day);

    box = Hive.box('testBox');
    allData = box.values.toList();
    weekData = allData.where((element) => week.isBefore(element.sleepTime)).toList();
    monthData = allData.where((element) => month.isBefore(element.sleepTime)).toList();

    avgWeekSleepTime = averageSleepDateTime(weekData);
    avgWeekWakeTime = averageWakeDateTime(weekData);

    avgMonthSleepTime = averageSleepDateTime(monthData);
    avgMonthWakeTime = averageWakeDateTime(monthData);

    avgAllSleepTime = averageSleepDateTime(allData);
    avgAllWakeTime = averageWakeDateTime(allData);

  }

  averageSleepDateTime(List<DailyQ> data) {
    if (data.isNotEmpty) {
      double avg = data.map((e) => e.sleepTime.millisecondsSinceEpoch).fold(
          0.0, (value, element) => value += element);
      double vg = data.map((e) =>
      DateTime(now.year, now.month, now.day, e.sleepTime.hour, e.sleepTime.minute)
          .millisecondsSinceEpoch).fold(
          0.0, (previousValue, element) => previousValue += element);
      var res = DateTime.fromMillisecondsSinceEpoch((vg / data.length).round());
      return res;
    }
  }

  averageWakeDateTime(List<DailyQ> data) {
    if (data.isNotEmpty) {
      double avg = data.map((e) => e.wakeupTime.millisecondsSinceEpoch).fold(
          0.0, (value, element) => value += element);
      // return new DateTime.fromMillisecondsSinceEpoch((avg/data.length).round());
      double vg = data.map((e) =>
      DateTime(
          now.year, now.month, now.day, e.wakeupTime.hour, e.wakeupTime.minute)
          .millisecondsSinceEpoch).fold(
          0.0, (previousValue, element) => previousValue += element);
      var res = DateTime.fromMillisecondsSinceEpoch((vg / data.length).round());
      print("Wakeup avg: $res");
      return res;
    }
  }


  Widget weekTab(List<DailyQ> weekData) {
    if (weekData.isNotEmpty) {
      return SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // Row 1
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sleep score
                Expanded(
                  flex: 2,
                  child: Card(
                      elevation: 3.0,
                      color: Color(0xff1F1F1F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Average",
                                style: TextStyle(color: Colors.white30)),
                            Text("Sleep score",
                                style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    weekData.averageSleepScore.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0)),
                                Icon(
                                  Icons.stacked_line_chart,
                                  color: Colors.blue,
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                ),

                // Sleep duration
                Expanded(
                  flex: 2,
                  child: Card(
                      elevation: 3.0,
                      color: Color(0xff1F1F1F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Average",
                                style: TextStyle(color: Colors.white30)),
                            Text("Sleep duration",
                                style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: weekData.averageSleepPeriod[0]
                                              .toString(),
                                          style: TextStyle(color: Colors.white,
                                              fontSize: 16.0)
                                      ),
                                      TextSpan(
                                          text: "h ",
                                          style: TextStyle(
                                              color: Colors.white54)
                                      ),
                                      TextSpan(
                                          text: weekData.averageSleepPeriod[1]
                                              .toString(),
                                          style: TextStyle(color: Colors.white,
                                              fontSize: 16.0)
                                      ),
                                      TextSpan(
                                          text: " min",
                                          style: TextStyle(
                                              color: Colors.white54)
                                      ),
                                    ])),
                                Icon(
                                  Icons.waterfall_chart,
                                  color: Colors.pink,
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),

            // Row 2
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Sleep at
                Expanded(
                  flex: 2,
                  child: Card(
                      elevation: 3.0,
                      color: Color(0xff1F1F1F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Average",
                                style: TextStyle(color: Colors.white30)),
                            Text("Sleep at",
                                style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: DateFormat(DATE_FORMAT_DAY_TIME)
                                              .format(avgWeekSleepTime),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w300)),
                                      TextSpan(
                                          text: DateFormat(DATE_FORMAT_AM_PM)
                                              .format(avgWeekSleepTime),
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300))
                                    ])
                                ),
                                Icon(
                                  Icons.nights_stay,
                                  color: Colors.deepPurple,
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                ),

                // Wake up at
                Expanded(
                  flex: 2,
                  child: Card(
                      elevation: 3.0,
                      color: Color(0xff1F1F1F),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      margin: EdgeInsets.all(8),
                      child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Average",
                                style: TextStyle(color: Colors.white30)),
                            Text("Wake up at",
                                style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                          text: DateFormat(DATE_FORMAT_DAY_TIME)
                                              .format(avgWeekWakeTime),
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w300)),
                                      TextSpan(
                                          text: DateFormat(DATE_FORMAT_AM_PM)
                                              .format(avgWeekWakeTime),
                                          style: TextStyle(
                                              color: Colors.white54,
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w300))
                                    ])
                                ),
                                Icon(
                                  Icons.wb_sunny,
                                  color: Colors.yellow,
                                )
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ],
            ),

            // Row 3
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       flex: 2,
            //       child: Card(
            //           elevation: 3.0,
            //           color: Color(0xff1F1F1F),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10)),
            //           margin: EdgeInsets.all(8),
            //           child: Padding(
            //             padding: EdgeInsets.all(10),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("Sleep Duration",
            //                     style: TextStyle(color: Colors.white)),
            //                 SizedBox(height: 10),
            //                 Container(
            //                   color: Colors.purpleAccent,
            //                   height: 200.0,
            //                 )
            //               ],
            //             ),
            //           )),
            //     ),
            //   ],
            // ),
            //
            // // Row 4
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       flex: 2,
            //       child: Card(
            //           elevation: 3.0,
            //           color: Color(0xff1F1F1F),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10)),
            //           margin: EdgeInsets.all(8),
            //           child: Padding(
            //             padding: EdgeInsets.all(10),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("Sleep at", style: TextStyle(color: Colors
            //                     .white)),
            //                 SizedBox(height: 10),
            //                 Container(
            //                   color: Colors.blueAccent,
            //                   height: 200.0,
            //                 )
            //               ],
            //             ),
            //           )),
            //     ),
            //   ],
            // ),
            //
            // // Row 5
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     Expanded(
            //       flex: 2,
            //       child: Card(
            //           elevation: 3.0,
            //           color: Color(0xff1F1F1F),
            //           shape: RoundedRectangleBorder(
            //               borderRadius: BorderRadius.circular(10)),
            //           margin: EdgeInsets.all(8),
            //           child: Padding(
            //             padding: EdgeInsets.all(10),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Text("Wake up at",
            //                     style: TextStyle(color: Colors.white)),
            //                 SizedBox(height: 10),
            //                 Container(
            //                   color: Colors.greenAccent,
            //                   height: 200.0,
            //                 )
            //               ],
            //             ),
            //           )),
            //     ),
            //   ],
            // )
          ],
        ),
      );
    }
    else {
      return Container();
    }
  }

    Widget monthTab (List<DailyQ> monthData) {
      if(monthData.isNotEmpty) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Row 1
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sleep score
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 3.0,
                        color: Color(0xff1F1F1F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Average",
                                  style: TextStyle(color: Colors.white30)),
                              Text("Sleep score",
                                  style:
                                  TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                      monthData.averageSleepScore.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18.0)),
                                  Icon(
                                    Icons.stacked_line_chart,
                                    color: Colors.blue,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),

                  // Sleep duration
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 3.0,
                        color: Color(0xff1F1F1F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Average",
                                  style: TextStyle(color: Colors.white30)),
                              Text("Sleep duration",
                                  style:
                                  TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  // Text("8h 59min",
                                  //     style: TextStyle(
                                  //         color: Colors.white, fontSize: 18.0)),
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: monthData
                                                .averageSleepPeriod[0]
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0)
                                        ),
                                        TextSpan(
                                            text: "h ",
                                            style: TextStyle(
                                                color: Colors.white54)
                                        ),
                                        TextSpan(
                                            text: monthData
                                                .averageSleepPeriod[1]
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0)
                                        ),
                                        TextSpan(
                                            text: " min",
                                            style: TextStyle(
                                                color: Colors.white54)
                                        ),
                                      ])),
                                  Icon(
                                    Icons.waterfall_chart,
                                    color: Colors.pink,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),

              // Row 2
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sleep at
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 3.0,
                        color: Color(0xff1F1F1F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Average",
                                  style: TextStyle(color: Colors.white30)),
                              Text("Sleep at",
                                  style:
                                  TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: DateFormat(
                                                DATE_FORMAT_DAY_TIME).format(
                                                avgMonthSleepTime),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: DateFormat(DATE_FORMAT_AM_PM)
                                                .format(avgMonthSleepTime),
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w300))
                                      ])
                                  ),
                                  // Text("21:50",
                                  //     style: TextStyle(
                                  //         color: Colors.white, fontSize: 18.0)),
                                  Icon(
                                    Icons.nights_stay,
                                    color: Colors.deepPurple,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),

                  // Wake up at
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 3.0,
                        color: Color(0xff1F1F1F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Average",
                                  style: TextStyle(color: Colors.white30)),
                              Text("Wake up at",
                                  style:
                                  TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: DateFormat(
                                                DATE_FORMAT_DAY_TIME).format(
                                                avgMonthWakeTime),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: DateFormat(DATE_FORMAT_AM_PM)
                                                .format(avgMonthWakeTime),
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w300))
                                      ])
                                  ),
                                  Icon(
                                    Icons.wb_sunny,
                                    color: Colors.yellow,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),

              // Row 3
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Card(
              //           elevation: 3.0,
              //           color: Color(0xff1F1F1F),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10)),
              //           margin: EdgeInsets.all(8),
              //           child: Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("Sleep Duration",
              //                     style: TextStyle(color: Colors.white)),
              //                 SizedBox(height: 10),
              //                 Container(
              //                   color: Colors.purpleAccent,
              //                   height: 200.0,
              //                 )
              //               ],
              //             ),
              //           )),
              //     ),
              //   ],
              // ),
              //
              // // Row 4
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Card(
              //           elevation: 3.0,
              //           color: Color(0xff1F1F1F),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10)),
              //           margin: EdgeInsets.all(8),
              //           child: Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("Sleep at", style: TextStyle(color: Colors.white)),
              //                 SizedBox(height: 10),
              //                 Container(
              //                   color: Colors.blueAccent,
              //                   height: 200.0,
              //                 )
              //               ],
              //             ),
              //           )),
              //     ),
              //   ],
              // ),
              //
              // // Row 5
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Card(
              //           elevation: 3.0,
              //           color: Color(0xff1F1F1F),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10)),
              //           margin: EdgeInsets.all(8),
              //           child: Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("Wake up at",
              //                     style: TextStyle(color: Colors.white)),
              //                 SizedBox(height: 10),
              //                 Container(
              //                   color: Colors.greenAccent,
              //                   height: 200.0,
              //                 )
              //               ],
              //             ),
              //           )),
              //     ),
              //   ],
              // )
            ],
          ),
        );
      }
      else {
        return Container();
      }
    }

    Widget allTab (List<DailyQ> allData) {
      if (allData.isNotEmpty) {
        return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Row 1
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sleep score
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 3.0,
                        color: Color(0xff1F1F1F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Average",
                                  style: TextStyle(color: Colors.white30)),
                              Text("Sleep score",
                                  style:
                                  TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  Text(
                                      allData.averageSleepScore.toString(),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0)),
                                  Icon(
                                    Icons.stacked_line_chart,
                                    color: Colors.blue,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),

                  // Sleep duration
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 3.0,
                        color: Color(0xff1F1F1F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Average",
                                  style: TextStyle(color: Colors.white30)),
                              Text("Sleep duration",
                                  style:
                                  TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: allData.averageSleepPeriod[0]
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0)
                                        ),
                                        TextSpan(
                                            text: "h ",
                                            style: TextStyle(
                                                color: Colors.white54)
                                        ),
                                        TextSpan(
                                            text: allData.averageSleepPeriod[1]
                                                .toString(),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0)
                                        ),
                                        TextSpan(
                                            text: " min",
                                            style: TextStyle(
                                                color: Colors.white54)
                                        ),
                                      ])),
                                  Icon(
                                    Icons.waterfall_chart,
                                    color: Colors.pink,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),

              // Row 2
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sleep at
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 3.0,
                        color: Color(0xff1F1F1F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Average",
                                  style: TextStyle(color: Colors.white30)),
                              Text("Sleep at",
                                  style:
                                  TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: DateFormat(
                                                DATE_FORMAT_DAY_TIME).format(
                                                avgAllSleepTime),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: DateFormat(DATE_FORMAT_AM_PM)
                                                .format(avgAllSleepTime),
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w300))
                                      ])),
                                  Icon(
                                    Icons.nights_stay,
                                    color: Colors.deepPurple,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),

                  // Wake up at
                  Expanded(
                    flex: 2,
                    child: Card(
                        elevation: 3.0,
                        color: Color(0xff1F1F1F),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Average",
                                  style: TextStyle(color: Colors.white30)),
                              Text("Wake up at",
                                  style:
                                  TextStyle(
                                      color: Colors.white, fontSize: 15.0)),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween,
                                children: [
                                  RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: DateFormat(
                                                DATE_FORMAT_DAY_TIME).format(
                                                avgAllWakeTime),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.w300)),
                                        TextSpan(
                                            text: DateFormat(DATE_FORMAT_AM_PM)
                                                .format(avgAllWakeTime),
                                            style: TextStyle(
                                                color: Colors.white54,
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w300))
                                      ])),
                                  Icon(
                                    Icons.wb_sunny,
                                    color: Colors.yellow,
                                  )
                                ],
                              )
                            ],
                          ),
                        )),
                  ),
                ],
              ),

              // Row 3
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Card(
              //           elevation: 3.0,
              //           color: Color(0xff1F1F1F),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10)),
              //           margin: EdgeInsets.all(8),
              //           child: Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("Sleep Duration",
              //                     style: TextStyle(color: Colors.white)),
              //                 SizedBox(height: 10),
              //                 Container(
              //                   color: Colors.purpleAccent,
              //                   height: 200.0,
              //                 )
              //               ],
              //             ),
              //           )),
              //     ),
              //   ],
              // ),
              //
              // // Row 4
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Card(
              //           elevation: 3.0,
              //           color: Color(0xff1F1F1F),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10)),
              //           margin: EdgeInsets.all(8),
              //           child: Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("Sleep at", style: TextStyle(color: Colors.white)),
              //                 SizedBox(height: 10),
              //                 Container(
              //                   color: Colors.blueAccent,
              //                   height: 200.0,
              //                 )
              //               ],
              //             ),
              //           )),
              //     ),
              //   ],
              // ),
              //
              // // Row 5
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(
              //       flex: 2,
              //       child: Card(
              //           elevation: 3.0,
              //           color: Color(0xff1F1F1F),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(10)),
              //           margin: EdgeInsets.all(8),
              //           child: Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //                 Text("Wake up at",
              //                     style: TextStyle(color: Colors.white)),
              //                 SizedBox(height: 10),
              //                 Container(
              //                   color: Colors.greenAccent,
              //                   height: 200.0,
              //                 )
              //               ],
              //             ),
              //           )),
              //     ),
              //   ],
              // )
            ],
          ),
        );
      }
      else {
        return Container();
      }
    }

  Widget emptyTrendScreen() {
    return Card(
      color: Colors.white,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'images/icons-calendar.png',
                    width: 150.0,
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "You have no logged records yet",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible (
                  child: Text(
                      "Take today's daily survey to collect your sleep quality and pain intensity history in order to get personalized insights about your low back pain.",
                      style: TextStyle(fontSize: 16.0)
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(15.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        primary: Colors.blue
                    ),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QuestionnairePage())
                      )
                    },
                    child: Text(
                      "Take today's survey",
                      style:
                      TextStyle(fontSize: 18.0, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }


  @override
    Widget build(BuildContext context) {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text("Trends"),
                backgroundColor: Color(0xff000000),
                elevation: 0.0,
                brightness: Brightness.dark,
                // systemOverlayStyle: SystemUiOverlayStyle(
                //     statusBarIconBrightness: Brightness.dark,
                //   statusBarBrightness: Brightness.dark
                // ),
                bottom: TabBar(
                  indicatorColor: Colors.white,
                  indicatorSize: TabBarIndicatorSize.label,
                  tabs: [
                    Padding(padding: EdgeInsets.all(10), child: Text("Week")),
                    Padding(padding: EdgeInsets.all(10), child: Text("Month")),
                    Padding(padding: EdgeInsets.all(10), child: Text("All")),
                  ],
                ),
              ),
              backgroundColor: Color(0xff000000),
              extendBodyBehindAppBar: false,
              body: allData.isNotEmpty
                ? TabBarView(
                    children: [
                      weekTab(weekData),
                      monthTab(monthData),
                      allTab(allData),
                    ],
                  )
                : emptyTrendScreen())
      );
    }
  }
