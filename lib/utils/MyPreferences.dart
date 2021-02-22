import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lbp/model/notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:lbp/env/.env.dart';



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

  static saveFirstTime(bool first) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', first);
  }

  static fetchFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String first = prefs.getString("first_time");
    return first;
  }

  static Future<http.Response> saveNotificationTimeOnBackend(String time, String appId)  async {
    return http.put(
      '${environment['remote_url']}/api/users/$appId',
      // 'http://10.0.2.2:8080/api/users/${this.appId}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'segment': time
      }),
    );
  }


  static Future<Notifications> displayTodayNotification() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var dateTaken = prefs.getString("notification_taken_date");
    var today = DateFormat("yyyy-MM-dd").format(DateTime.now());
    if (dateTaken != null && dateTaken == today) {
      // Show "well done! You completed today's survey"
      return null;
    } else {
      // Show task and display "Time to take the survey."
      return new Notifications(
          "bbb-bbb-bbb-bbb",
          "Today's survey - ${DateFormat("dd MMM yyyy").format(DateTime.now())}",
          "Click to open",
          false,
        "daily"
      );
    }
  }

  static saveDateTaken(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notification_taken_date', date);
  }

  static Future<Notifications> insertOnBoardingTask() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var takenOnboarding = prefs.getBool("onboarding");
    if (takenOnboarding != true) {
      return Notifications(
          "aaa-aaa-aaa-aaa",
          "Get started here",
          "Let's get to know you",
          false,
        "daily"
      );
    } else {
      return null;
    }
  }

  static updateOnboarding(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', status);
  }


  static Future<Notifications> displayMonthlySleepNotification() async {
      var today = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).day;
      if (1 <= today && today <= 7) {
        return new Notifications(
            "ccc-ccc-ccc-ccc",
            "Monthly sleep survey",
            "Click to open",
            false,
            "monthly-sleep"
        );
      }
      return null;
  }

  static Future<Notifications> displayMonthlyPromis10() async {
    var today = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).day;
    if (1 <= today && today <= 7) {
      return new Notifications(
          "ddd-ddd-ddd-ddd",
          "Monthly pain survey",
          "Click to open",
          false,
          "monthly-pain"
      );
    }
    return null;
  }

  static saveMonthlyDateTaken(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('monthly_notification_taken_date', date);
  }
}

