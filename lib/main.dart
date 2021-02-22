
import 'package:flutter/material.dart';
import 'package:lbp/screens/home.dart';
import 'package:lbp/screens/onBoarding.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Widget _defaultHome = new OnBoarding();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var firstTime = prefs.getBool("first_time");
  if (firstTime == false) {
    _defaultHome = MyHomePage();
  }

  runApp(new MaterialApp(
    title: 'SloPain',
    theme: ThemeData(
      primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    debugShowCheckedModeBanner: false,
    home: _defaultHome,
    routes: <String, WidgetBuilder>{
      'home': (BuildContext context) => new MyHomePage(),
      'onboarding': (BuildContext context) => new OnBoarding(),
    },
  ));
  // runApp(MyApp(_defaultHome));
}



// Future<void> initDb() async {
//   final migration1to2 = Migration(1, 2, (database) async {
//     await database.execute("ALTER TABLE notifications ADD COLUMN date_entered TEXT");
//   });
//
//   final database = await $FloorAppDatabase
//       .databaseBuilder('database.db')
//       .addMigrations([migration1to2])
//       .build();
// }


// class MyApp extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'SloPain',
//       theme: ThemeData(
//         primaryColor: Color.fromRGBO(58, 66, 86, 1.0),
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: MyHomePage(),
//       routes: <String, WidgetBuilder>{
//         'home': (BuildContext context) => new OnBoarding(),
//         // 'onboarding': (BuildContext context) => new OnBoarding(),
//       },
//     );
//   }
// }
