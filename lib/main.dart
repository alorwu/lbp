
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lbp/model/hive/sleep/SleepComponentScores.dart';
import 'package:lbp/screens/new_home_screen/NewHomeScreen.dart';
import 'package:lbp/screens/onBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/hive/daily/DailyQ.dart';
import 'model/hive/qol/QoL.dart';
import 'model/hive/sleep/PSQI.dart';
import 'model/hive/user/User.dart';

void initializeHiveDependencies() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DailyQAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PSQIAdapter());
  Hive.registerAdapter(QoLAdapter());
  Hive.registerAdapter(SleepComponentScoresAdapter());

  await Hive.openBox<DailyQ>("dailyBox");
  await Hive.openBox<User>("userBox");
  await Hive.openBox<PSQI>("psqiBox");
  await Hive.openBox<QoL>("qolBox");
  await Hive.openBox<SleepComponentScores>("psqiScore");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  initializeHiveDependencies();

  await Firebase.initializeApp();
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // FirebaseCrashlytics.instance.crash();

  Widget _defaultHome = new OnBoarding();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var firstTime = prefs.getBool("first_time");
  if (firstTime == false) {
    _defaultHome = NewHomeScreen();
  }

  runApp(new MaterialApp(
    title: 'Sleep Better with Back Pain',
    theme: ThemeData(
      primaryColor: Colors.black,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false,
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      'home': (BuildContext context) => new NewHomeScreen(),
      'onboarding': (BuildContext context) => new OnBoarding(),
    },
  ));
}
