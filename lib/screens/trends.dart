import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/src/extensions/color_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lbp/constants/Constants.dart';
import 'package:lbp/model/hive/daily/DailyQ.dart';
import 'package:lbp/screens/questionnaires/daily_questionnaire_screen.dart';
import 'package:lbp/utils/sleep_time_charts.dart';

class TrendScreen extends StatefulWidget {
  @override
  TrendScreenState createState() => TrendScreenState();
}

class TrendScreenState extends State<TrendScreen> {
  Box<DailyQ> box;
  List<DailyQ> weekData;
  List<DailyQ> monthData;
  List<DailyQ> allData;

  List<BarChartGroupData> sleepQualityBarChartWeekData = [];
  List<BarChartGroupData> sleepQualityBarChartMonthData = [];

  List<BarChartGroupData> sleepDurationBarChartWeekData = [];
  List<BarChartGroupData> sleepDurationBarChartMonthData = [];

  var firstDayOfWeek;

  var avgWeekSleepTime;
  var avgWeekWakeTime;

  var avgMonthSleepTime;
  var avgMonthWakeTime;

  var avgAllSleepTime;
  var avgAllWakeTime;

  var now = new DateTime.now();

  var week;
  var month;

  @override
  initState() {
    super.initState();
    firstDayOfWeek = DateTime(now.year, now.month, now.day).subtract(new Duration(days: now.weekday)).add(Duration(days: 1));
    month = DateTime(now.year, now.month, 1);

    box = Hive.box('dailyBox');
    allData = box.values.toList();
    weekData = allData.where((element) => element.dateTaken.isAfter(firstDayOfWeek)).toList();

    monthData = allData.where((element) => element.sleepTime.isAfter(month)).toList();

    avgWeekSleepTime = averageSleepDateTime(weekData);
    avgWeekWakeTime = averageWakeDateTime(weekData);

    avgMonthSleepTime = averageSleepDateTime(monthData);
    avgMonthWakeTime = averageWakeDateTime(monthData);

    avgAllSleepTime = averageSleepDateTime(allData);
    avgAllWakeTime = averageWakeDateTime(allData);

    showWeekGroups();
    showMonthGroups();

    showWeekSleepDuration();
    showMonthSleepDuration();
  }

  averageSleepDateTime(List<DailyQ> data) {
    if (data.isNotEmpty) {
      double avg = data
          .map((e) => DateTime(now.year, now.month, now.day, e.sleepTime.hour,
                  e.sleepTime.minute)
              .millisecondsSinceEpoch)
          .fold(0.0, (previousValue, element) => previousValue += element);
      return DateTime.fromMillisecondsSinceEpoch((avg / data.length).round());
    }
  }

  averageWakeDateTime(List<DailyQ> data) {
    if (data.isNotEmpty) {
      double avg = data
          .map((e) => DateTime(now.year, now.month, now.day, e.wakeupTime.hour,
                  e.wakeupTime.minute)
              .millisecondsSinceEpoch)
          .fold(0.0, (previousValue, element) => previousValue += element);
      return DateTime.fromMillisecondsSinceEpoch((avg / data.length).round());
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
                                    weekData.averageSleepScore.toStringAsFixed(2),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18.0)),
                                Icon(
                                  Icons.stacked_line_chart,
                                  color: Colors.blue,
                                )
                              ],
                            ),
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
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: plotBarChartWith(
                      sleepQualityBarChartWeekData,
                      "Sleep score",
                    ),
                  ),
                ),
              ],
            ),

            // Row 4
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Padding(
                        padding: EdgeInsets.all(10),
                        child: SleepTimeChart(
                            data: sleepDurationBarChartWeekData,
                            title: "Sleep duration"
                        ),
                        ),
                ),
              ],
            ),
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
      return emptyTrendScreen();
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
                                      monthData.averageSleepScore.toStringAsFixed(2),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: plotBarChartWith(
                          sleepQualityBarChartMonthData,
                          "Sleep score",
                      ),
                  ),
                  ),
                ],
              ),

              // Row 4
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                          padding: EdgeInsets.all(10),
                          child: SleepTimeChart(
                            data: sleepDurationBarChartMonthData,
                            title: "Sleep duration",
                          ),
                    ),
                  ),
                ],
              ),

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
        return emptyTrendScreen();
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
                                      allData.averageSleepScore.toStringAsFixed(2),
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
              //       child: Padding(
              //             padding: EdgeInsets.all(10),
              //             child: Column(
              //               crossAxisAlignment: CrossAxisAlignment.start,
              //               children: [
              //               ],
              //             ),
              //           ),
              //     ),
              //   ],
              // ),

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
    return Padding(
    padding: EdgeInsets.all(20.0),
        child: Card(
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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 10.0, right: 25.0),
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
                      TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
              ],
            ),
          ],
        ),
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

  Widget plotBarChartWith(List<BarChartGroupData> data, String title) {
    return AspectRatio(
      aspectRatio: 1.5,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: Color(0xff81e5cd),
        ),
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                        color: Color(0xff379982),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: BarChart(
                      mainBarData(data),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y,
      int length, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 15,
        List<int> showTooltips = const [],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          y: y,
          colors: [barColor],
          width: length == 7 ? width : 5,
          borderSide: BorderSide(color: Colors.white, width: 1),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 10,
            colors: [Color(0xff72d8bf)],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  showWeekSleepDuration() {
    var lastDayOfWeek = firstDayOfWeek.add(Duration(days: 7));
    final daysToGenerate = lastDayOfWeek.difference(firstDayOfWeek).inDays;
    var sleepDurationData = List.generate(daysToGenerate, (index) => DummyData(int.parse(DateFormat("dd").format(firstDayOfWeek.add(Duration(days: index)))), 0));

    for(var d in sleepDurationData) {
      for(var x in weekData) {
        if (d.index == int.parse(DateFormat("dd").format(x.dateTaken))) {
          d.value = int.parse(x.sleepPeriod[0]) + double.parse((double.parse(x.sleepPeriod[1])/60).toStringAsFixed(2));
          break;
        }
      }
    }

    for(int i = 0; i<sleepDurationData.length; i++) {
      sleepDurationBarChartWeekData.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                width: 15, y: sleepDurationData[i].value, colors: [Colors.lightBlueAccent, Colors.greenAccent])
          ],
          showingTooltipIndicators: [0],
        ),
      );
      // sleepQualityBarChartWeekData.add(makeGroupData(i, sleepDurationData[i].value.toDouble(), sleepDurationData.length),);
    }
  }

  showMonthSleepDuration() {
    var lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysToGenerate = lastDayOfMonth.add(Duration(days: 1)).difference(month).inDays;
    var sleepDurationData = List.generate(daysToGenerate, (index) => DummyData(int.parse(DateFormat("dd").format(month.add(Duration(days: index)))), 0));

    for(var d in sleepDurationData) {
      for(var x in weekData) {
        if (d.index == int.parse(DateFormat("dd").format(x.dateTaken))) {
          d.value = int.parse(x.sleepPeriod[0]) + double.parse((double.parse(x.sleepPeriod[1])/60).toStringAsFixed(2));
          break;
        }
      }
    }

    for(int i = 0; i<sleepDurationData.length; i++) {
      sleepDurationBarChartMonthData.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
                width: sleepDurationData.length == 7 ? 15 : 5,
                y: sleepDurationData[i].value,
                colors: [Colors.lightBlueAccent, Colors.greenAccent],
            )
          ],
          showingTooltipIndicators: [0],
        ),
      );
    }
  }

  showWeekGroups() {
    var lastDayOfWeek = firstDayOfWeek.add(Duration(days: 7));
    final daysToGenerate = lastDayOfWeek.difference(firstDayOfWeek).inDays;
    var sleepQualityData = List.generate(daysToGenerate, (index) => DummyData(int.parse(DateFormat("dd").format(firstDayOfWeek.add(Duration(days: index)))), 0));

    for(var d in sleepQualityData) {
      for(var x in weekData) {
        if (d.index == int.parse(DateFormat("dd").format(x.dateTaken))) {
          d.value = x.qualityOfSleep.toDouble();
          break;
        }
      }
    }

    for(int i = 0; i<sleepQualityData.length; i++) {
      sleepQualityBarChartWeekData.add(makeGroupData(i, sleepQualityData[i].value.toDouble(), sleepQualityData.length),);
    }
  }

  showMonthGroups() {
    var lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
    final daysToGenerate = lastDayOfMonth.add(Duration(days: 1)).difference(month).inDays;
    var sleepQualityData = List.generate(daysToGenerate, (index) => DummyData(int.parse(DateFormat("dd").format(month.add(Duration(days: index)))), 0));

    for(var d in sleepQualityData) {
      for(var x in monthData) {
        if (d.index == int.parse(DateFormat("dd").format(x.dateTaken))) {
          d.value = x.qualityOfSleep.toDouble();
          break;
        }
      }
    }

    for(int i = 0; i<sleepQualityData.length; i++) {
      sleepQualityBarChartMonthData.add(makeGroupData(i, sleepQualityData[i].value.toDouble(), sleepQualityData.length));
    }
  }


  BarChartData mainBarData(List<BarChartGroupData> groupData) {
    return BarChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
              color: Color(0xff379982), fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            if (groupData.length == 7) {
              switch (value.toInt()) {
                case 0:
                  return 'M';
                case 1:
                  return 'T';
                case 2:
                  return 'W';
                case 3:
                  return 'T';
                case 4:
                  return 'F';
                case 5:
                  return 'S';
                case 6:
                  return 'S';
                default:
                  return '';
              }
            } else {
              return (value + 1) % 2 == 0 ? '' : (value + 1).toInt().toString();
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, values) => TextStyle(
            color: Color(0xff379982), fontWeight: FontWeight.bold,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: groupData, //showingGroups(),
      gridData: FlGridData(show: false),
    );
  }

}

class DummyData {
  int index;
  double value;

  DummyData(this.index, this.value);
}
