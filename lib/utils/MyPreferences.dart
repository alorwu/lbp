import 'package:shared_preferences/shared_preferences.dart';

class MyPreferences {
  static saveNotificationTime(String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("segment", time);
  }

  static fetchNotificationTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String time = prefs.getString("segment");
    return time;
  }
}