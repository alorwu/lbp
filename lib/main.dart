import 'package:flutter/material.dart';
import 'package:lbp/screens/home.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:lbp/env/.env.dart';

import 'db/database.dart';
import 'model/notifications.dart';

void main() async {

  runApp(MyApp());
  initPlatformState();
}

Future<void> initPlatformState() async {
  OneSignal.shared.init(environment['onesignal_app_id'], iOSSettings: {
    OSiOSSettings.autoPrompt: false,
    OSiOSSettings.promptBeforeOpeningPushUrl: true
  });

  OneSignal.shared
      .setInFocusDisplayType(OSNotificationDisplayType.notification);

  OneSignal.shared.setNotificationReceivedHandler((notification) {
    refactorNotification(notification);
  });

  OneSignal.shared.setNotificationOpenedHandler((openedResult) {});

}

Future<void> refactorNotification(OSNotification notification) async {
  var newNotification = Notifications(
    null,
    notification.payload.notificationId,
    notification.payload.title,
    "Click to open",
    // notification.payload.body,
    false,
    DateTime.now().millisecondsSinceEpoch.toString()
  );
  
  final database =
  await $FloorAppDatabase.databaseBuilder('database.db').build();
  final notificationDao = database.notificationDao;
  var response = await notificationDao.findByNotificationId(newNotification.notificationId);
  if (response == null) {
    await notificationDao.insertNotification(newNotification);
  }
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sleep Better with LBP',
      theme: ThemeData(
        primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: new MyHomePage(),
      // routes: <String, WidgetBuilder>{
      //   HOME: (BuildContext context) => new MyHomePage(),
      // },
    );
  }
}
