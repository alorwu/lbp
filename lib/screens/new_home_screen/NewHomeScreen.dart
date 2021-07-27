import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lbp/screens/home.dart';
import 'package:lbp/screens/settings/about.dart';
import 'package:lbp/screens/settings/donate_data.dart';
import 'package:lbp/screens/settings/setttings_screen.dart';
import 'package:lbp/screens/trends.dart';

class NewHomeScreen extends StatefulWidget {
  @override
  NewHomeState createState() => NewHomeState();
}

class NewHomeState extends State<NewHomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _widgetOptions = <Widget> [
    MyHomePage(),
    // AboutScreen(),
    TrendScreen(),
    SettingsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.red,
            bottomNavigationBar: new Theme(
              data: Theme.of(context).copyWith(canvasColor: Color.fromRGBO(58, 66, 86, 1.0)),
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  // BottomNavigationBarItem(
                  //     icon: Icon(Icons.event_note_outlined), label: 'Records'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart), label: 'Trends'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'More',
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.amber[800],
                onTap: _onItemTapped,
              ),
            ),
            body: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
