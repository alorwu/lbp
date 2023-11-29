
import 'package:flutter/material.dart';
import 'package:lbp/core/notificaton_model.dart';

import '../history.dart';
import '../more.dart';
import '../sleep_home.dart';
import '../trends.dart';

class NewHomeScreen extends StatefulWidget {
  @override
  NewHomeState createState() => NewHomeState();
}

class NewHomeState extends State<NewHomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    NotificationModel().loadAvailableNotification();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> pages = <Widget> [
      SleepHome(),
      SurveyHistoryScreen(),
      TrendScreen(),
      MoreScreen(),
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Scaffold(
            backgroundColor: Colors.black,
            bottomNavigationBar: new Theme(
              data: Theme.of(context).copyWith(canvasColor: Color(0xff000000) ),
              child: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined), label: 'History'),
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
            body: pages[_selectedIndex],
          ),
        ],
      ),
    );
  }
}
