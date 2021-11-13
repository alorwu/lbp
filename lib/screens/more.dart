import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lbp/screens/rss/rssfeed_screen.dart';
import 'package:lbp/screens/settings/consent.dart';
import 'package:lbp/screens/settings/privacy_policy.dart';
import 'package:lbp/screens/settings/setttings_screen.dart';

class MoreScreen extends StatefulWidget {
  @override
  MoreState createState() => MoreState();
}

class MoreState extends State<MoreScreen> {
  Widget disclaimer() => RichText(
          text: TextSpan(
              style: TextStyle(color: Colors.grey),
              children: <TextSpan>[
            TextSpan(text: "You can read our privacy disclaimer "),
            TextSpan(
                text: "here ",
                style: TextStyle(color: Color.fromRGBO(58, 66, 86, 1.0)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrivacyDisclaimerScreen()));
                  }),
            TextSpan(text: "and user consent agreement "),
            TextSpan(
                text: "here ",
                style: TextStyle(color: Color.fromRGBO(58, 66, 86, 1.0)),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConsentScreen()));
                  }),
          ]));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('More'),
        backgroundColor: Color(0xff000000),
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            // ListTile(
            //   leading: Icon(Icons.fitness_center),
            //   title: Text("Exercises"),
            //   trailing: Icon(Icons.chevron_right),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => BackPainReliefScreen()));
            //   },
            // ),
            // Divider(),
            ListTile(
              leading: Icon(Icons.rss_feed),
              title: Text("Online information"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RssFeedScreen()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text("Settings"),
              trailing: Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            Divider(),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10.0, right: 10.0, top: 10.0, bottom: 20.0),
                child: disclaimer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
