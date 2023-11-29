
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static saveNotificationTime(String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("segment", time);
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
}

