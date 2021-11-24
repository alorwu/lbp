import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lbp/screens/more.dart';
import 'package:lbp/screens/records.dart';
import 'package:lbp/screens/trends.dart';

import '../sleep_home.dart';

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
    SleepHome(),
    SleepRecordScreen(),
    TrendScreen(),
    MoreScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Color(0xff000000),
            bottomNavigationBar: new Theme(
              data: Theme.of(context).copyWith(canvasColor: Color(0xff000000) ), //Color.fromRGBO(58, 66, 86, 1.0)),
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined), label: 'Records'),
                  BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Trends'),
                  BottomNavigationBarItem(icon: Icon(Icons.add), label: 'More',),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white38,
                onTap: _onItemTapped,
                showSelectedLabels: true,
                showUnselectedLabels: true,
              ),
            ),
            body: _widgetOptions.elementAt(_selectedIndex),
          ),
        ],
      ),
    );
  }
}
