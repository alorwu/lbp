
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:lbp/core/notification_repository.dart';
import 'package:lbp/core/notification_repository_impl.dart';
import 'package:lbp/core/notificaton_model.dart';
import 'package:lbp/data/entity/notification/firebase_notification.dart';
import 'package:lbp/screens/tester_information_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env/.env.dart';
import 'data/entity/daily/daily_q.dart';
import 'data/entity/qol/quality_of_life.dart';
import 'data/entity/qol/quality_of_life_score.dart';
import 'data/entity/sleep/psqi.dart';
import 'data/entity/sleep/sleep_component_score.dart';
import 'features/mobility/domain/entity/mobility_data.dart';
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
  Hive.registerAdapter(FirebaseNotificationAdapter());
  Hive.registerAdapter(MobilityDataAdapter());

  await Hive.openBox<DailyQ>("dailyBox");
  await Hive.openBox<User>("userBox");
  await Hive.openBox<PSQI>("psqiBox");
  await Hive.openBox<QoL>("qolBox");
  await Hive.openBox<SleepComponentScores>("psqiScore");
  await Hive.openBox<QoLScore>("qolScoreBox");
  await Hive.openBox<FirebaseNotification>("notificationBox");
  await Hive.openBox("location_data");
  await Hive.openBox<MobilityData>("mobility_data");
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

/// Create a [AndroidNotificationChannel] for heads up notifications
late AndroidNotificationChannel channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationModel().loadAvailableNotification();
  await initializeHiveDependencies();
  await Firebase.initializeApp();

  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  // FirebaseCrashlytics.instance.crash();

  Widget _defaultHome = new OnBoarding();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var firstTime = prefs.getBool("first_time");
  if (firstTime == false) {
    _defaultHome = NewHomeScreen();
  }

  runApp(
    ChangeNotifierProvider<NotificationModel>(
      create: (_) => NotificationModel()..loadAvailableNotification(),
      child: LbpApp(defaultHome: _defaultHome),
    )
  );
}


class LbpApp extends StatefulWidget {
  final Widget defaultHome;

  const LbpApp({Key? key, required this.defaultHome}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LbpAppState();
}

class LbpAppState extends State<LbpApp> with WidgetsBindingObserver {
  late NotificationRepository repository;
  late String? deviceId;
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    getId();
    setupInteractiveMessage();
    repository = NotificationRepositoryImpl();
    super.initState();
  }

  Future<String?> getId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString('app_id');
    setState(() {
      deviceId = id;
    });
    return id;
  }

  void setupInteractiveMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      print("Initial message is not null ${initialMessage.messageType}");
    }

    var token = await FirebaseMessaging.instance.getToken();
      print("Firebase token: $token");
      saveUserToken(token);
      saveUserTokenToRemoteDb(token);


    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
              timeoutAfter: 21600000,
            ),
          ),
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      // handleAuctionMessage(message);
      NotificationModel().loadAvailableNotification();
    });
  }

  Future<http.Response> saveUserTokenToRemoteDb(String? token)  async {
    final response = await http.put(
      Uri.parse('${environment['remote_url']}/api/users/$deviceId/token'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: token,
    );

    if(response.statusCode.toString().startsWith("2")) {
      return response;
    } else {
      throw Exception("Could not save token");
    }
  }

  Future<void> saveUserToken(String? token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token ?? "");
  }

  void handleAuctionMessage(RemoteMessage message) async {
    var isAuction = message.data.containsKey("auctionId");
    if (isAuction) {
      NotificationModel().saveFirebaseNotification(message);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch(state) {
      case AppLifecycleState.resumed:
        NotificationModel().loadAvailableNotification();
        break;
      case AppLifecycleState.inactive:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
      // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
      // TODO: Handle this case.
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: '',
          theme: ThemeData(
            primaryColor: Colors.black,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          debugShowCheckedModeBanner: false,
          home: widget.defaultHome,
          routes: <String, WidgetBuilder>{
            'home': (BuildContext context) => new NewHomeScreen(),
            'onboarding': (BuildContext context) => new OnBoarding(),
            'testerinformation': (BuildContext context) => new TesterInformation(),
          },
    );
  }
}
