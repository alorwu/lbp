import 'dart:convert';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:footer/footer.dart';
import 'package:http/http.dart' as http;
import 'package:lbp/db/database.dart';
import 'package:lbp/model/notifications.dart';
import 'package:lbp/screens/questionnaire_screen.dart';
import 'package:lbp/screens/setttings_screen.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../env/.env.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var url =
      'https://docs.google.com/forms/d/e/1FAIpQLSfoQPG89pO_YrFOBUXzglEmGKv9AbdtWCdLInW3ZQ1-juLV2g/viewform?usp=pp_url&entry.244517143=';

  List<Notifications> notificationsList;
  String appId;
  String oneSignalPlayerId;

  @override
  void initState() {
    getId();
    getData();
    super.initState();
  }

  startTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool firstTime = prefs.getBool('first_time');
    print("First time? => $firstTime");

    if (firstTime == null) {
      //first time
      prefs.setBool('first_time', false);
      prefs.setString('segment', '07:00'); // set the default notification time to 7am
      insertOnBoardingTask();
    }

    if (await connection()) {
        await registerUser();
    }
  }

  void getData() async {
    notificationsList = await getAllNotifications();
  }

  void insertOnBoardingTask() async {
    var firstNotification = Notifications(
      null,
      "aaa-aaa-aaa-aaa",
      "Get started here",
      "Let's get to know you",
      // "Provide some information about yourself to get the best of this app",
      false,
        DateTime.now().millisecondsSinceEpoch.toString()
    );

    final database = await $FloorAppDatabase.databaseBuilder('database.db').build();
    final notificationDao = database.notificationDao;
    await notificationDao.insertNotification(firstNotification);
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

  Future<http.Response> registerUser() async {
    return http.post(
      '${environment['remote_url']}/api/users',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'id': this.appId,
        'playerId': this.oneSignalPlayerId,
        'segment': '07'
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

  tapToDelete(Notifications notification) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete notification'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Would you like to thrash this notification?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                deleteNotification(notification);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(Notifications notification) => ListTile(
          contentPadding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
          leading: GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 12.0),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1.0, color: Colors.white24),
                ),
              ),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            onTap: () {
              tapToDelete(notification);
            },
          ),
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
          trailing: notification.id == 1
              ? Icon(Icons.alarm, color: Colors.white, size: 30.0)
              : Icon(Icons.keyboard_arrow_right,
                  color: Colors.white, size: 30.0),
          onTap: () async {
            if (notification.id == 1) {
              if (await canLaunch(url) != null) {
                await launch(url + appId,
                    forceWebView: true,
                    forceSafariVC: true,
                    enableJavaScript: true);
                deleteNotification(notification);
              } else {
                throw 'Could not launch url';
              }
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          QuestionnairePage(notification: notification)
                  )
              );
            }
          },
        );

    Card makeCard(Notifications notification) => Card(
          elevation: 8.0,
          margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, 0.9)),
            child: makeListTile(notification),
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
                            fontSize: 10.0,
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
                            fontSize: 10.0,
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

    Widget buildNotificationListWidget(List<Notifications> list) =>
        Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return makeCard(list[index]);
                }),
          ),
          Container(
            child: Footer(
              child: bottomLogo(),
              backgroundColor: Colors.grey,
            ),
          ),
        ]);

    Widget showNoDataWidget() => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'No new tasks available.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ],
            ),
            bottomLogo(),
          ],
        );

    Widget noShow() => Column(
      children: <Widget>[
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'No new tasks available.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ],
          ),
        ),
        Footer(child: bottomLogo()),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Sleep LBP'),
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
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      body: FutureBuilder(
          future: getAllNotifications(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text("There was an error");
            } else if (snapshot.hasData) {
              return notificationsList != null && notificationsList.length != 0
                  ? buildNotificationListWidget(notificationsList)
                  : noShow();
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

  Future<List<Notifications>> getAllNotifications() async {
    final database =
        await $FloorAppDatabase.databaseBuilder('database.db').build();
    final notificationDao = database.notificationDao;
    var list = await notificationDao.findAllNotifications();
    setState(() {
      notificationsList = list;
    });
    return list;
  }

  Future<void> deleteNotification(Notifications notification) async {
    final database =
        await $FloorAppDatabase.databaseBuilder('database.db').build();
    final notificationDao = database.notificationDao;
    await notificationDao.delete(notification.id);
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
