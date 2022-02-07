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
import 'package:lbp/model/hive/qol/QoLScore.dart';
import 'package:lbp/model/hive/sleep/SleepComponentScores.dart';
import 'package:lbp/screens/questionnaires/daily_questionnaire_screen.dart';
import 'package:lbp/screens/questionnaires/quality_of_life_questionnaire.dart';
import 'package:lbp/screens/questionnaires/sleep_questionnaire.dart';
import 'package:lbp/utils/survey_records_line_chart.dart';

class SurveyHistoryScreen extends StatefulWidget {
  @override
  SurveyHistoryState createState() => SurveyHistoryState();
}

const DATE_FORMAT_DAY = "yMMMMd";
const DATE_FORMAT_DAY_TIME = "hh:mm";
const DATE_FORMAT_AM_PM = " a";

class SurveyHistoryState extends State<SurveyHistoryScreen> {
  Box<DailyQ> dailyRecords;
  Box<QoL> qolRecords;
  Box<SleepComponentScores> sleepComponentScores;
  Box<QoLScore> qolScores;

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

    var isQolScoreBox = Hive.isBoxOpen("qolScoreBox");
    if (isQolScoreBox) {
      qolScores = Hive.box("qolScoreBox");
    } else {
      qolScores = await Hive.openBox("qolScoreBox");
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
                    "You have no logged data",
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                        "Take today's daily survey to collect your sleep quality and pain intensity history in order to get personalized insights about your low back pain.",
                        style: TextStyle(fontSize: 16.0)),
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
                        padding: EdgeInsets.only(
                            left: 25.0, top: 10.0, bottom: 10.0, right: 25.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        primary: Colors.blue),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionnairePage()))
                    },
                    child: Text(
                      "Take today's survey",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                        "Take the monthly quality of life survey to display history and personalized insights about the quality of your life.",
                        style: TextStyle(fontSize: 16.0)),
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
                        padding: EdgeInsets.only(
                            left: 25.0, top: 10.0, bottom: 10.0, right: 25.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        primary: Colors.blue),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  QualityOfLifeQuestionnaire()))
                    },
                    child: Text(
                      "Start quality of life survey",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                        "Take the monthly sleep quality index survey to display history and personalized insights about your monthly sleep quality.",
                        style: TextStyle(fontSize: 16.0)),
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
                        padding: EdgeInsets.only(
                            left: 25.0, top: 10.0, bottom: 10.0, right: 25.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        primary: Colors.blue),
                    onPressed: () => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SleepQuestionnaire()))
                    },
                    child: Text(
                      "Take sleep quality survey",
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
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
                Text(
                  "Sleep duration",
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: DateFormat(DATE_FORMAT_DAY_TIME)
                          .format(data.sleepTime),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300)),
                  TextSpan(
                      text:
                          DateFormat(DATE_FORMAT_AM_PM).format(data.sleepTime),
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300))
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: data.sleepPeriod[0].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  TextSpan(
                      text: " h ", style: TextStyle(color: Colors.white54)),
                  TextSpan(
                      text: data.sleepPeriod[1].toString(),
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  TextSpan(
                      text: " min", style: TextStyle(color: Colors.white54)),
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
                Text("Sleep score", style: TextStyle(color: Colors.white54))
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: DateFormat(DATE_FORMAT_DAY_TIME)
                          .format(data.wakeupTime),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300)),
                  TextSpan(
                      text:
                          DateFormat(DATE_FORMAT_AM_PM).format(data.wakeupTime),
                      style: TextStyle(
                          color: Colors.white54,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300))
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: data.qualityOfSleep.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 16.0)),
                  TextSpan(
                      text: "/10",
                      style: TextStyle(color: Colors.white54, fontSize: 16.0))
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
          });
    } else
      return emptyDailyCard();
  }

  Widget qolScoreCard(int index, QoLScore score) {
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
                  DateFormat(DATE_FORMAT_DAY).format(score.dateTaken),
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
                Text("Physical health",
                    style: TextStyle(color: Colors.white54)),
                Text(
                  "Mental health",
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: score.physicalHealth.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300)),
                  TextSpan(
                      text: "/20",
                      style: TextStyle(color: Colors.white54, fontSize: 16.0)),
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: score.mentalHealth.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.w300)),
                  TextSpan(
                      text: "/20",
                      style: TextStyle(color: Colors.white54, fontSize: 16.0)),
                ])),
              ],
            ),
            SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  Widget qualityOfLifeSurvey(Box<QoLScore> qolScores) {
    if (qolScores != null && qolScores.isNotEmpty) {
      return ListView.builder(
          itemCount: qolScores.length,
          itemBuilder: (context, listIndex) {
            return qolScoreCard(listIndex, qolScores.getAt(listIndex));
          });
    } else
      return emptyQoLCard();
  }

  Widget pSQISurvey(Box<SleepComponentScores> scores) {
    if (scores != null && scores.isNotEmpty) {
      return SingleChildScrollView(
        child: ValueListenableBuilder(
          valueListenable: scores.listenable(),
          builder: (context, Box<SleepComponentScores> box, _) =>
              sleepPlots(scores.values),
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
          sleepQualityPlot(scores),
          SizedBox(height: 10),
          sleepDurationPlot(scores),
          SizedBox(height: 10),
          dayTimeDysfunctionPlot(scores),
          SizedBox(height: 10),
          sleepEfficiencyPlot(scores),
          SizedBox(height: 10),
          sleepMedicationPlot(scores),
          SizedBox(height: 10),
          sleepLatencyPlot(scores),
          SizedBox(height: 10),
          sleepDisturbancePlot(scores),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget sleepLatencyPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for (var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepLatency.toDouble()));
    }

    return ComponentScoresLineChart(
      title: "Sleep latency",
      spots: spots,
      backgroundColor: Colors.orangeAccent,
      toolTip:
          "Sleep latency is the amount of time it takes for a person to fall asleep after going to bed.\n\n 0 - Least dysfunction \n\n 3 - Greatest dysfunction\n\n J - January...D - December",
    );
  }

  Widget sleepDurationPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for (var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepDuration.toDouble()));
    }

    return ComponentScoresLineChart(
      title: "Sleep duration",
      spots: spots,
      backgroundColor: Colors.blueAccent,
      toolTip:
          "The length of time that you spend asleep. \n\n 0: >7 hrs \n\n 1:  6-7 hrs \n\n 2: 5-6 hrs \n\n 3: <5 hrs\n\n J - January...D - December",
    );
  }

  Widget sleepQualityPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for (var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepQuality.toDouble()));
    }

    return ComponentScoresLineChart(
      title: "Subjective sleep quality",
      spots: spots,
      backgroundColor: Colors.tealAccent,
      toolTip:
          "Sleep quality is how well you believe you slept. \n\n 0 - Very good \n\n 1 - Fairly good \n\n 2 - Fairly bad \n\n 3 - Very bad\n\n J - January...D - December",
    );
  }

  Widget sleepDisturbancePlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for (var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepDisturbance.toDouble()));
    }

    return ComponentScoresLineChart(
      title: "Sleep disturbances",
      spots: spots,
      backgroundColor: Colors.greenAccent,
      toolTip:
          "The extent to which you believe your sleep was interrupted or disturbed over the past month. \n\n 0 - Least disturbance \n\n 3 - Greatest disturbance\n\n J - January...D - December",
    );
  }

  Widget sleepEfficiencyPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for (var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepEfficiency.toDouble()));
    }

    return ComponentScoresLineChart(
      title: "Habitual sleep efficiency",
      spots: spots,
      backgroundColor: Colors.yellowAccent,
      toolTip:
          "This is the percentage of time you spend asleep while in bed. It does not include time spent in bed not trying to sleep -- e.g. reading. \n\n 0: >85% \n\n 1: 75-84% \n\n 2: 65-74% \n\n 3: <65% \n\n J - January...D - December",
    );
  }

  Widget sleepMedicationPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for (var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.sleepMedication.toDouble()));
    }

    return ComponentScoresLineChart(
      title: "Use of sleep medication",
      spots: spots,
      backgroundColor: Colors.purpleAccent,
      toolTip:
          "This is the number of times you have had to resort to the use of sleep medication in order to sleep. \n\n 0 - Not during the past month \n\n 1 - Less than once a week \n\n 2 - Once or twice a week \n\n 3 - Three or more times a week \n\n J - January...D - December",
    );
  }

  Widget dayTimeDysfunctionPlot(Iterable<SleepComponentScores> scores) {
    List<FlSpot> spots = [];
    for (var score in scores) {
      var date = int.parse(DateFormat("MM").format(score.dateTaken));
      spots.add(FlSpot(date.toDouble(), score.dayTimeDysfunction.toDouble()));
    }

    return ComponentScoresLineChart(
      title: "Daytime dysfunction",
      spots: spots,
      backgroundColor: Colors.amberAccent,
      toolTip:
          "This refers to your ability to keep your enthusiasm and perform day-to-day activities. \n\n 0 - Least dysfunction \n\n 3 - Greatest dysfunction \n\n J - January...D - December",
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Your history'),
          backgroundColor: Colors.black,
          elevation: 0.0,
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          brightness: Brightness.dark,
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            tabs: [
              Padding(padding: EdgeInsets.all(5), child: Text("Daily data")),
              Padding(
                  padding: EdgeInsets.all(5), child: Text("Quality of life")),
              Padding(padding: EdgeInsets.all(5), child: Text("Monthly sleep")),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        body: TabBarView(
          children: [
            dailySurvey(dailyRecords),
            qualityOfLifeSurvey(qolScores),
            pSQISurvey(sleepComponentScores),
          ],
        ),
      ),
    );
  }
}
