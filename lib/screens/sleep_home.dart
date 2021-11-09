import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lbp/screens/questionnaires/daily_questionnaire_screen.dart';
import 'package:lbp/screens/questionnaires/quality_of_life_questionnaire.dart';
import 'package:lbp/screens/questionnaires/sleep_questionnaire.dart';
import 'package:lbp/screens/sleep_monitor.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../env/.env.dart';

class SleepHome extends StatefulWidget {
  @override
  SleepHomeState createState() => SleepHomeState();
}

class SleepHomeState extends State<SleepHome> {
  String _timeString;
  String _amPmString;
  Timer timer;
  bool showMonthlySurveys = true;
  bool showQOLSurvey = true;
  bool showSleepSurvey = true;

  String todayTakenDate;
  String qolLastDateTaken;
  String sleepLastDateTaken;

  String userId;
  String oneSignalPlayerId;

  @override
  void initState() {
    initPlatformState();
    initializeVariables();
    _timeString = _formatDateTime(DateTime.now());
    _amPmString = _formatTimeOfDay(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    var today = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).day;
    setState(() {
      showMonthlySurveys = 1 <= today && today <= 17;
    });
    super.initState();
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.setAppId(environment['onesignal_app_id']);
    // OneSignal.shared.init(environment['onesignal_app_id'], iOSSettings: {
    //   OSiOSSettings.autoPrompt: false,
    //   OSiOSSettings.promptBeforeOpeningPushUrl: true
    // });

    // OneSignal.shared
    //     .setInFocusDisplayType(OSNotificationDisplayType.notification);

    // OneSignal.shared.setNotificationReceivedHandler((notification) {
    //   // refactorNotification(notification);
    // });

    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      // MyPreferences.checkAndDisplayNotificationToday();
    });

    // var status = await OneSignal.shared.getPermissionSubscriptionState();
    //
    // if (!status.permissionStatus.hasPrompted) {
    //   OneSignal.shared.addTrigger("prompt_ios", "true");
    // }
  }

  Future<void> initializeVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var todayTaken = prefs.getString("notification_taken_date");
    var sleepSurveyDate = prefs.getString("monthly_sleep_survey_taken_date");
    var promis10Date = prefs.getString("monthly_pain_survey_taken_date");

    var today = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).day;

    var id = prefs.getString("app_id");
    var playerId = await getPlayerId();
    if (playerId == null) {
      getPlayerId();
    }
    setState(() {
      userId = id;
      oneSignalPlayerId = playerId;
      todayTakenDate = todayTaken;
      qolLastDateTaken = promis10Date;
      sleepLastDateTaken = sleepSurveyDate;

      if (qolLastDateTaken != null) {
        showQOLSurvey = (1 <= today && today <= 17) &&
            DateFormat("yyyy-MM").parse(qolLastDateTaken) !=
                DateFormat("yyyy-MM").parse(DateTime.now().toString());
      }
      if (sleepLastDateTaken != null ) {
        showSleepSurvey = (1 <= today && today <= 17) &&
            DateFormat("yyyy-MM").parse(sleepLastDateTaken) !=
                DateFormat("yyyy-MM").parse(DateTime.now().toString());
      }
    });
    print("**************************");
    print(id);
    print(oneSignalPlayerId);
    print("*******************");
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

  Future<String> getPlayerId() async {
    String playerId = await OneSignal.shared.getDeviceState().then((value) => value.userId);
    setState(() {
      oneSignalPlayerId = playerId;
    });
    return playerId;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget checkIconToShow() {
    if (todayTakenDate == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
      return happyIcon();
    } else {
      return sadIcon();
    }
  }

  Widget sadIcon() {
    return Row(
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
    );
  }

  Widget happyIcon() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text("Good job!! You've completed today's survey.",
            style: TextStyle(
                color: Colors.white,
                fontSize: 14.0)),
        ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.asset(
            'images/smiley.png',
            height: 40.0,
            width: 40.0,
            fit: BoxFit.fill,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Sleep Better with Back Pain"),
      //   backgroundColor: Color(0xff000000),
      //   elevation: 0.0,
      //   systemOverlayStyle: SystemUiOverlayStyle.dark,
      // ),
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
            color: Colors.black38,
            margin: EdgeInsets.only(bottom: 20.0),
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
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  QuestionnairePage())
                          );
                        },
                        child: Card(
                          elevation: 3.0,
                          color: Colors.grey[850],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: EdgeInsets.all(8),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Today's survey",
                                    style: TextStyle(color: Colors.white54)),
                                SizedBox(height: 5),
                                checkIconToShow()
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Monthly surveys
                this.showMonthlySurveys
                ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sleep survey
                          this.showSleepSurvey
                              ? Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SleepQuestionnaire()));
                                    },
                                    child: Card(
                                        elevation: 3.0,
                                        color: Colors.grey[850],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: EdgeInsets.all(8),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Monthly sleep survey",
                                                  style: TextStyle(
                                                      color: Colors.white54)),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                )
                              : Container(),

                          // Quality of life survey
                          this.showQOLSurvey
                              ? Expanded(
                                  flex: 2,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  QualityOfLifeQuestionnaire()
                                          ),
                                      );
                                    },
                                    child: Card(
                                        elevation: 3.0,
                                        color: Colors.grey[850],
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: EdgeInsets.all(8),
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text("Quality of life survey",
                                                  style: TextStyle(
                                                      color: Colors.white54)),
                                              SizedBox(height: 10),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
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
                                )
                              : Container(),
                  ],
                )
                : Container(),

                // Container(
                //   width: double.infinity,
                //   height: 50,
                //   margin: EdgeInsets.only(top:10, bottom: 20, left: 8, right: 8),
                //   child: ElevatedButton.icon(
                //       onPressed: () {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => SleepMonitor()));
                //       },
                //       style: ButtonStyle(
                //         shape:
                //             MaterialStateProperty.all<RoundedRectangleBorder>(
                //           RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(50.0),
                //           ),
                //         ),
                //       ),
                //       icon: Icon(Icons.play_arrow_rounded),
                //       label: Text(
                //         "Track sleep",
                //         style: TextStyle(
                //             color: Colors.white,
                //             fontWeight: FontWeight.bold,
                //             fontSize: 18.0),
                //       )),
                // ),
              ],
            ),
          ),
          // Clock
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
                          fontSize: 60.0,
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
        ],
      ),
    );
  }
}
