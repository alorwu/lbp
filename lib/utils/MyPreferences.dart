import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lbp/env/.env.dart';
import 'package:lbp/model/notifications.dart';
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
      Uri.parse('${environment['remote_url']}/api/users/$appId'),
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
      // Show task and display "Time to take the survey."
      return new Notifications(
          "bbb-bbb-bbb-bbb",
          "Today's survey - ${DateFormat("dd MMM yyyy").format(DateTime.now())}",
          "Click to open",
          false,
        "daily"
      );
    // }
  }

  /// Save date survey was taken (daily survey) -- for showing icons
  static saveDateTaken(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('notification_taken_date', date);
  }

  static updateOnboarding(bool status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('first_time', status);
  }


  /// Display monthly sleep survey
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

  /// Display monthly pain survey
  static Future<Notifications> displayMonthlyPromis10() async {
    var today = DateFormat("yyyy-MM-dd").parse(DateTime.now().toString()).day;
    if (1 <= today && today <= 7) {
      return new Notifications(
          "ddd-ddd-ddd-ddd",
          "Monthly quality of life survey",
          "Click to open",
          false,
          "monthly-pain"
      );
    }
    return null;
  }

  /// Save date monthly sleep survey was taken
  static saveLastMonthlySleepSurveyDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('monthly_sleep_survey_taken_date', date);
  }

  /// Save date monthly pain survey was taken
  static saveLastMonthlyPainSurveyDate(String date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('monthly_pain_survey_taken_date', date);
  }

  /// Get date monthly sleep survey was last taken
  static fetchLastMonthlySleepSurveyDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("monthly_sleep_survey_taken_date");
  }

  /// Get date monthly pain survey was last taken
  static fetchLastMonthlyPainSurveyDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("monthly_pain_survey_taken_date");
  }
}

