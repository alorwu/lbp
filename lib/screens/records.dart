import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/hive/daily/DailyQ.dart';
import 'package:lbp/model/monthly/PSQIQuestionnaire.dart';
import 'package:lbp/model/monthly/QoLQuestionnaire.dart';
import 'package:lbp/screens/questionnaires/daily_questionnaire_screen.dart';
import 'package:lbp/screens/questionnaires/quality_of_life_questionnaire.dart';
import 'package:lbp/screens/questionnaires/sleep_questionnaire.dart';

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
    list = Hive.box('dailyBox');
  }

  Widget emptyDailyCard() {
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
                    TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
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

  Widget emptyQoLCard() {
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
                    "You have no quality of life records",
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
                        "Take the monthly quality of life survey to display history and personalized insights about the quality of your life.",
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
                                  QualityOfLifeQuestionnaire())
                      )
                    },
                    child: Text(
                      "Start quality of life survey",
                      style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
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

  Widget emptyPSQICard() {
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
                    "You have no sleep quality records",
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
                        "Take the monthly sleep quality index survey to display history and personalized insights about your monthly sleep quality.",
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
                                  SleepQuestionnaire())
                      )
                    },
                    child: Text(
                      "Take sleep quality survey",
                      style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.normal, color: Colors.white),
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
                          text: " h ",
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

    // @override
    // Widget build(BuildContext context) {
    //   return Scaffold(
    //       appBar: AppBar(
    //         centerTitle: true,
    //         title: Text('Sleep records'),
    //         backgroundColor: Color(0xff000000),
    //         elevation: 0.0,
    //         // systemOverlayStyle: SystemUiOverlayStyle.dark,
    //         brightness: Brightness.dark,
    //       ),
    //       backgroundColor: Color(0xff000000),
    //       body: ValueListenableBuilder(
    //         valueListenable: list.listenable(),
    //         builder: (context, Box<DailyQ> box, _) {
    //           if (list.isNotEmpty) {
    //             return ListView.builder(
    //                 itemCount: list.length,
    //                 itemBuilder: (context, listIndex) {
    //                     return dailyCard(listIndex, list.getAt(listIndex));
    //                 }
    //             );
    //           } else {
    //             return emptyRecordsCard();
    //           }
    //         },
    //       ),
    //   );
    // }

  Widget dailySurvey(Box<DailyQ> list) {
    return SingleChildScrollView(
        child: ValueListenableBuilder(
        valueListenable: list.listenable(),
        builder: (context, Box<DailyQ> box, _) {
          if (list.isNotEmpty) {
            return ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, listIndex) {
                  return dailyCard(listIndex, list.getAt(listIndex));
                }
            );
          } else {
            return emptyDailyCard();
          }
        },
        ),
      );
  }

  Widget qualityOfLifeSurvey() {
    return SingleChildScrollView(
      child: emptyQoLCard()
    );
  }

  Widget pSQISurvey() {
    return SingleChildScrollView(
      child: emptyPSQICard()
    );
  }

    @override
    Widget build(BuildContext context) {
      return DefaultTabController(
          length: 3,
          child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Survey records'),
          backgroundColor: Color(0xff000000),
          elevation: 0.0,
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          brightness: Brightness.dark,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Padding(padding: EdgeInsets.all(10), child: Text("Daily")),
              Padding(padding: EdgeInsets.all(10), child: Text("QoL")),
              Padding(padding: EdgeInsets.all(10), child: Text("PSQI")),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: TabBarView(
          children: [
            dailySurvey(list),
            qualityOfLifeSurvey(),
            pSQISurvey(),
          ],
        )
        // ValueListenableBuilder(
        //   valueListenable: list.listenable(),
        //   builder: (context, Box<DailyQ> box, _) {
        //     if (list.isNotEmpty) {
        //       return ListView.builder(
        //           itemCount: list.length,
        //           itemBuilder: (context, listIndex) {
        //             return dailyCard(listIndex, list.getAt(listIndex));
        //           }
        //       );
        //     } else {
        //       return emptyRecordsCard();
        //     }
        //   },
        // ),
          ),
      );
    }
  }

