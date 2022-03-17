
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/entity/daily/daily_q.dart';
import 'data/entity/qol/quality_of_life.dart';
import 'data/entity/qol/quality_of_life_score.dart';
import 'data/entity/sleep/psqi.dart';
import 'data/entity/sleep/sleep_component_score.dart';
import 'features/user/data/entity/user_dto.dart';
import 'screens/new_home_screen/new_home_screen.dart';
import 'screens/onboarding.dart';

Future<void> initializeHiveDependencies() async {
  await Hive.initFlutter();
  Hive.registerAdapter(DailyQAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(PSQIAdapter());
  Hive.registerAdapter(QoLAdapter());
  Hive.registerAdapter(SleepComponentScoresAdapter());
  Hive.registerAdapter(QoLScoreAdapter());

  await Hive.openBox<DailyQ>("dailyBox");
  await Hive.openBox<User>("userBox");
  await Hive.openBox<PSQI>("psqiBox");
  await Hive.openBox<QoL>("qolBox");
  await Hive.openBox<SleepComponentScores>("psqiScore");
  await Hive.openBox<QoLScore>("qolScoreBox");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeHiveDependencies();

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
    title: 'Sleepain',
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
