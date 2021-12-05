import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:footer/footer.dart';
import 'package:lbp/screens/rss/rssfeed_screen.dart';
import 'package:lbp/screens/settings/consent.dart';
import 'package:lbp/screens/settings/privacy_policy.dart';
import 'package:lbp/screens/settings/setttings_screen.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Column(
        children: [
          Expanded(
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
                Divider(),
                ListTile(
                  leading: Icon(Icons.rss_feed),
                  title: Text("Online information"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RssFeedScreen()));
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                  trailing: Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen()));
                  },
                ),
                Divider(),
              ],
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.only(
                left: 10.0, right: 10.0, top: 5.0, bottom: 10.0),
            child: Center(child: disclaimer()),
          ),
          Footer(
            child: bottomLogo(),
            backgroundColor: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget bottomLogo() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      'images/cc.jpg',
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text("CC Research Group",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(64, 75, 96, 0.9))),
                ],
              ),
            ),
            onTap: () {
              openCCGroup();
            },
          ),
          GestureDetector(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: Image.asset(
                      'images/ubicomp.jpg',
                      height: 40.0,
                      width: 40.0,
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Text("UBICOMP Research Unit",
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(64, 75, 96, 0.9))),
                ],
              ),
            ),
            onTap: () {
              openUbiComp();
            },
          ),
        ],
      );

  void openCCGroup() async {
    final url = "https://ubicomp.oulu.fi/cc";
    if (await canLaunch(url)) {
      await launch(url,
          forceWebView: true, forceSafariVC: true, enableJavaScript: true);
    } else {
      throw 'Could not launch url';
    }
  }

  void openUbiComp() async {
    final url = "https://ubicomp.oulu.fi";
    if (await canLaunch(url)) {
      await launch(url,
          forceWebView: true, forceSafariVC: true, enableJavaScript: true);
    } else {
      throw 'Could not launch url';
    }
  }
}
