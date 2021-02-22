import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lbp/model/notifications.dart';
import 'package:lbp/screens/questionnaire_screen.dart';
import 'package:lbp/screens/setttings_screen.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../env/.env.dart';
import 'monthly_pain_questionnaire_screen.dart';
import 'monthly_questionnaire_screen.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var url =
      'https://docs.google.com/forms/d/e/1FAIpQLSfoQPG89pO_YrFOBUXzglEmGKv9AbdtWCdLInW3ZQ1-juLV2g/viewform?usp=pp_url&entry.244517143=';

  List<Notifications> notificationsList = List();
  String appId;
  String oneSignalPlayerId;
  Notifications onBoarding;
  Notifications survey;
  String notificationTakenDate;

  var notification = Notifications(
    "bbb-bbb-bbb-bbb",
    "Today's survey", // - ${DateFormat("dd MMM yyyy").format(DateTime.now())}",
    "Click to open",
    false,
    "daily"
  );

  @override
  void initState() {
    super.initState();
    initPlatformState();
    getId();
  }

  Future<void> initPlatformState() async {
    OneSignal.shared.init(environment['onesignal_app_id'], iOSSettings: {
      OSiOSSettings.autoPrompt: false,
      OSiOSSettings.promptBeforeOpeningPushUrl: true
    });

    OneSignal.shared
        .setInFocusDisplayType(OSNotificationDisplayType.notification);

    OneSignal.shared.setNotificationReceivedHandler((notification) {
      // refactorNotification(notification);
    });

    OneSignal.shared.setNotificationOpenedHandler((openedResult) {
      // MyPreferences.checkAndDisplayNotificationToday();
    });

    var status = await OneSignal.shared.getPermissionSubscriptionState();

    if (!status.permissionStatus.hasPrompted) {
      OneSignal.shared.addTrigger("prompt_ios", "true");
    }

  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    MyPreferences.saveNotificationTimeOnBackend(prefs.getString("segment").substring(0, 2), appId);

    if (await connection()) {
      await registerUser(prefs.getString("segment").substring(0, 2));
    }

  }



  Future<bool> connection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      } else {
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text("No internet connection"),
        ));
        return false;
      }
    } on SocketException catch (_) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text("Check your internet connection"),
      ));
      return false;
    }
  }

  Future<http.Response> registerUser(String segment) async {
    return http.post(
      '${environment['remote_url']}/api/users',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': this.appId,
        'playerId': this.oneSignalPlayerId,
        'segment': segment
      }),
    );
  }

  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    var id;
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      id = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      id = androidDeviceInfo.androidId; // unique ID on Android
    }
    setState(() {
      appId = id;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("app_id", id);

    if (id != null && oneSignalPlayerId != null) {
      startTime();
    } else {
      getId();
      getPlayerId();
    }
    return id;
  }

  Future<String> getPlayerId() async {
    OSPermissionSubscriptionState status =
    await OneSignal.shared.getPermissionSubscriptionState();
    String playerId = status.subscriptionStatus.userId;
    setState(() {
      oneSignalPlayerId = playerId;
    });
    if (playerId != null) {
      startTime();
    }
    return playerId;
  }

  @override
  Widget build(BuildContext context) {

    ListTile makeListTile(Notifications notification) => ListTile(
      contentPadding: EdgeInsets.fromLTRB(15.0, 0, 5.0, 0),
      title: Text(
        notification.title,
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15.0),
      ),
      subtitle: Row(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: Text(
              notification.description,
              style: TextStyle(color: Colors.white, fontSize: 12.0),
            ),
          ),
        ],
      ),
      trailing: notification.notificationId == "aaa-aaa-aaa-aaa"
          ? Icon(Icons.alarm, color: Colors.white, size: 30.0)
          : Icon(Icons.keyboard_arrow_right,
          color: Colors.white, size: 30.0),
      onTap: () async {
        if(notification.type == "daily") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      QuestionnairePage(notification: notification)
              )
          );
        } else if(notification.type == "monthly-pain") {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MonthlyPainQuestionnairePage(notification: notification)
              )
          );
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MonthlyQuestionnairePage(notification: notification)
              )
          );
        }
      },
    );

    Card makeCard(Notifications notification) => Card(
      elevation: 8.0,
      margin: EdgeInsets.fromLTRB(6.0, 3.0, 6.0, 3.0),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromRGBO(64, 75, 96, 0.9),
            borderRadius: BorderRadius.circular(4.0)
        ),
        child: notification == null ? Container() : makeListTile(notification),
      ),
    );

    Widget bottomLogo() => Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'images/cc.jpg',
                    height: 40.0,
                    width: 40.0,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 5.0),
                Text("CC Research Group",
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(64, 75, 96, 0.9))),
              ],
            ),
          ),
          onTap: () {
            openCCGroup();
          },
        ),
        GestureDetector(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.asset(
                    'images/ubicomp.jpg',
                    height: 40.0,
                    width: 40.0,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(height: 5.0),
                Text("UBICOMP Research Unit",
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(64, 75, 96, 0.9))),
              ],
            ),
          ),
          onTap: () {
            openUbiComp();
          },
        ),
      ],
    );


    Widget sadFace() => Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/sadd.png', height: 180.0, width: 180.0),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Text(
                "You haven't taken your survey for today yet. Do so now.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(64, 75, 96, 0.9), fontSize: 20.0)
            ),
          ),
        ],
      ),
    );

    Widget happyFace() => Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset('images/smiley.png', height: 180.0, width: 180.0),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
            child: Text(
                "Congratulations!! \nYou have taken your survey for today. Check back tomorrow.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Color.fromRGBO(64, 75, 96, 0.9), fontSize: 20.0)
            ),
          ),
        ],
      ),
    );


    Widget checkFaceToShow() {
      if (notificationTakenDate == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
        return happyFace();
      } else {
        return sadFace();
      }
    }

    Widget bodyWidget(List<Notifications> data) {
      return Column(
        children: <Widget>[
          for(var i in data) makeCard(i),
          checkFaceToShow(),
          Footer(
            child: bottomLogo(),
            backgroundColor: Colors.grey,
          ),
        ],
      );
    }


      return Scaffold(
        appBar: AppBar(
          title: Text('Sleep Better with Back Pain'),
          elevation: 5,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()));
                },
                child: Icon(
                  Icons.settings,
                  size: 24.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white, //Color.fromRGBO(58, 66, 86, 1.0),
        body: FutureBuilder(
            future: getSurveys(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text("There was an error $snapshot");
              } else if (snapshot.hasData) {
                return bodyWidget(snapshot.data);
              } else {
                return Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            }
        ),
      );
    }



  Future<List<Notifications>> getSurveys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var notificationTaken = prefs.getString("notification_taken_date");
    setState(() {
      notificationTakenDate = notificationTaken;
    });

    var survey = await MyPreferences.displayTodayNotification();
    var monthlySleepSurvey = await MyPreferences.displayMonthlySleepNotification();
    var monthlyPainSurvey = await MyPreferences.displayMonthlyPromis10();
    notificationsList.clear();

    if (survey != null) {
      notificationsList.add(survey);
    }
    if (monthlySleepSurvey != null) {
      notificationsList.add(monthlySleepSurvey);
    }
    if (monthlyPainSurvey != null) {
      notificationsList.add(monthlyPainSurvey);
    }

    return notificationsList;
  }


  void openCCGroup() async {
    final url = "https://ubicomp.oulu.fi/cc";
    if (await canLaunch(url)) {
      await launch(
          url,
          forceWebView: true,
          forceSafariVC: true,
          enableJavaScript: true
      );
    } else {
      throw 'Could not launch url';
    }
  }

  void openUbiComp() async {
    final url = "https://ubicomp.oulu.fi";
    if (await canLaunch(url)) {
      await launch(
          url,
          forceWebView: true,
          forceSafariVC: true,
          enableJavaScript: true
      );
    } else {
      throw 'Could not launch url';
    }
  }
}
