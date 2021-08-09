import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lbp/screens/settings/consent.dart';
import 'package:lbp/screens/settings/privacy_policy.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:preferences/preference_page.dart';
import 'package:preferences/preference_title.dart';
import 'package:preferences/preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'about.dart';
import 'donate_data.dart';


class SettingsScreen extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<SettingsScreen> {
  var url = 'https://docs.google.com/forms/d/e/1FAIpQLSfoQPG89pO_YrFOBUXzglEmGKv9AbdtWCdLInW3ZQ1-juLV2g/viewform?usp=pp_url&entry.244517143=';

  String appId;
  String oneSignalPlayerId;
  String time;
  // String dropdownValue = 'One';

  @override
  void initState() {
    super.initState();
    getId();
    getSelectedTime();
  }

  void showSnackBar(BuildContext context, String value) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text("Notification time updated to $value"),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    ));
  }


  Widget donateData() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: ListTile(
            title: Text("How to donate your Oura data"),
            subtitle: Text("Contribute your Oura data to our ongoing research. Click here to see how (approx. 1-3 minutes).", style: TextStyle(fontSize: 12.0)),
            // leading: Icon(Icons.arrow_right_alt_outlined),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DonateDataScreen()));
            },
          ),
        ),
      ],
    ),
  );





  Widget notificationTime(BuildContext context) => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: ListTile(
            title: Text("Daily survey reminder time"),
            subtitle: Text("Configure the time to receive your daily survey invitation", style: TextStyle(fontSize: 12.0)),
            // leading: Icon(Icons.language),
            trailing:  DropdownButton<String>(
              value: this.time,
              onChanged: (String newValue) async {
                setState(() {
                  this.time = newValue;
                });
                saveSelectedTime(newValue);
                var res = await MyPreferences.saveNotificationTimeOnBackend(newValue.substring(0, 2), appId);
                if (res.statusCode == 200) {
                  this.showSnackBar(context, newValue);
                }
              },
              items: <String>['06:00', '07:00', '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00', '18:00', '19:00', '20:00']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),// Text("Select time"),
          ),
        ),
      ],
    ),
  );

  Widget aboutUs() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: ListTile(
            title: Text("About this app"),
            subtitle: Text("Get to know what this Sleep Better with Back Pain app is all about", style: TextStyle(fontSize: 12.0)),
            // leading: Icon(Icons.people_rounded),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AboutScreen()));
            },
          ),
        ),
      ],
    ),
  );

  Widget otherStudies() => Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: ListTile(
            title: Text("See our other studies"),
            subtitle: Text("Check out other studies we are running that may interest you", style: TextStyle(fontSize: 12.0)),
            // leading: Icon(Icons.app_registration),
            trailing: Icon(Icons.chevron_right),
            onTap: () async {
              launch(
                  "https://crowdcomputing.net",
                  forceWebView: true,
                  forceSafariVC: true,
                  enableJavaScript: true
              );
            },
          ),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xff000000),
        brightness: Brightness.dark,
      ),
      body: Builder(
        builder: (context) => Card(
          margin: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(5.0, 5.0, 5.0, 0.0),
                  child: PreferencePage([
                    PreferenceTitle("Notification time", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                    notificationTime(context),
                    PreferenceTitle("Donate data", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                    donateData(),
                    PreferenceTitle("About app", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                    aboutUs(),
                    PreferenceTitle("Other studies", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w700)),
                    otherStudies()
                  ]),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }



  @override
  void dispose() {
    super.dispose();
  }

  // Future<http.Response> saveNotificationTimeOnBackend(String time)  async {
  //   return http.put(
  //     '${environment['remote_url']}/api/users/${this.appId}',
  //     // 'http://10.0.2.2:8080/api/users/${this.appId}',
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode({
  //       'segment': time
  //     }),
  //   );
  // }

  void saveSelectedTime(String time) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('segment', time);
  }

  getSelectedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var setTime = prefs.getString('segment');
    if (setTime == null || setTime.isEmpty) {
      setTime = "07:00";
    }
    setState(() {
      time = setTime;
    });
    return setTime;
  }

  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    var id = "";
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      id = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      id = androidDeviceInfo.androidId; // unique ID on Android
    }
    setState(() {
      appId = id;
    });
    return id;
  }
}

