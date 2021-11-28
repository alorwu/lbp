import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/hive/daily/DailyQ.dart';
import 'package:lbp/model/hive/qol/QoL.dart';
import 'package:lbp/model/hive/sleep/SleepComponentScores.dart';
import 'package:lbp/utils/survey_records_line_chart.dart';
import 'package:lbp/screens/questionnaires/daily_questionnaire_screen.dart';
import 'package:lbp/screens/questionnaires/quality_of_life_questionnaire.dart';
import 'package:lbp/screens/questionnaires/sleep_questionnaire.dart';

class SurveyRecordScreen extends StatefulWidget {
  @override
  SurveyRecordState createState() => SurveyRecordState();
}

const DATE_FORMAT_DAY = "yMMMMd";
const DATE_FORMAT_DAY_TIME = "hh:mm";
const DATE_FORMAT_AM_PM = " a";

class SurveyRecordState extends State<SurveyRecordScreen> {

  Box<DailyQ> dailyRecords;
  Box<QoL> qolRecords;
  Box<SleepComponentScores> sleepComponentScores;

  @override
  initState() {
    super.initState();
    initBoxes();
  }

  initBoxes() async {

    var isDailyBoxOpened = Hive.isBoxOpen("dailyBox");
    if (isDailyBoxOpened) {
      dailyRecords = Hive.box("dailyBox");
    } else {
      dailyRecords = await Hive.openBox("dailyBox");
    }
    var isQoLBoxOpened = Hive.isBoxOpen("qolBox");
    if (isQoLBoxOpened) {
      qolRecords = Hive.box("qolBox");
    } else {
      qolRecords = await Hive.openBox("qolBox");
    }

    var isPSQIBoxOpened = Hive.isBoxOpen("psqiScore");
    if (isPSQIBoxOpened) {
      sleepComponentScores = Hive.box("psqiScore");
    } else {
      sleepComponentScores = await Hive.openBox("psqiScore");
    }
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

  Widget dailySurvey(Box<DailyQ> list) {
    if (list != null && list.isNotEmpty) {
      return ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, listIndex) {
            return dailyCard(listIndex, list.getAt(listIndex));
          }
      );
    } else {
      return emptyDailyCard();
    }
    // return SingleChildScrollView(
    //     child: ValueListenableBuilder(
    //     valueListenable: list.listenable(),
    //     builder: (context, Box<DailyQ> box, _) {
    //       if (list.isNotEmpty) {
    //         return ListView.builder(
    //             itemCount: list.length,
    //             itemBuilder: (context, listIndex) {
    //               return dailyCard(listIndex, list.getAt(listIndex));
    //             }
    //         );
    //       } else {
    //         return emptyDailyCard();
    //       }
    //     },
    //     ),
    //   );
  }

  Widget qualityOfLifeSurvey() {
    return emptyQoLCard();
  }

  Widget pSQISurvey(Box<SleepComponentScores> scores) {
    if (scores != null && scores.isNotEmpty) {
      return SingleChildScrollView(
          child: ValueListenableBuilder(
            valueListenable: scores.listenable(),
            builder: (context, Box<SleepComponentScores> box, _) => sleepPlots(scores.values),
          ),
      );
    } else {
      return emptyPSQICard();
    }
  }

  Widget sleepPlots(Iterable<SleepComponentScores> scores) {
    return Padding(
        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
        child: Column(
      children: [
        sleepLatencyPlot(scores),
        SizedBox(height: 10),
        sleepDurationPlot(scores),
        SizedBox(height: 10),
        sleepQualityPlot(scores),
        SizedBox(height: 10),
        sleepDisturbancePlot(scores),
        SizedBox(height: 10),
        sleepEfficiencyPlot(scores),
        SizedBox(height: 10),
        sleepMedicationPlot(scores),
        SizedBox(height: 10),
        dayTimeDysfunctionPlot(scores),
        SizedBox(height: 10),
      ],
        ),
    );
  }

  Widget sleepLatencyPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for(var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepLatency.toDouble()));
    }

    return ComponentScoresLineChart(
        title: "Sleep latency",
        spots: spots,
      backgroundColor: Colors.deepOrangeAccent //Color(0xff379982),
    );
  }

  Widget sleepDurationPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for(var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepDuration.toDouble()));
    }

    return ComponentScoresLineChart(
        title: "Sleep duration",
        spots: spots,
      backgroundColor: Colors.pink,
    );
  }

  Widget sleepQualityPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for(var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepQuality.toDouble()));
    }

    return ComponentScoresLineChart(
        title: "Sleep quality",
        spots: spots,
      backgroundColor: Colors.teal //Color(0xff379982),
    );
  }

  Widget sleepDisturbancePlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for(var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepDisturbance.toDouble()));
    }

    return ComponentScoresLineChart(
        title: "Sleep disturbance",
        spots: spots,
      backgroundColor: Colors.green//Color(0xff81e5cd),
    );
  }

  Widget sleepEfficiencyPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for(var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepEfficiency.toDouble()));
    }

    return ComponentScoresLineChart(
        title: "Sleep efficiency",
        spots: spots,
      backgroundColor: Colors.blueAccent //Color(0xff379982),
    );
  }

  Widget sleepMedicationPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for(var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepMedication.toDouble()));
    }

    return ComponentScoresLineChart(
        title: "Sleep medication",
        spots: spots,
      backgroundColor: Colors.purple,
    );
  }

  Widget dayTimeDysfunctionPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for(var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.dayTimeDysfunction.toDouble()));
    }

    return ComponentScoresLineChart(
        title: "Day time dysfunction",
        spots: spots,
      backgroundColor: Colors.amber,
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
          backgroundColor: Colors.black,
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
            dailySurvey(dailyRecords),
            qualityOfLifeSurvey(),
            pSQISurvey(sleepComponentScores),
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

