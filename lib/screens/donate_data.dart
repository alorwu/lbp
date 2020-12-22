import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'package:lbp/env/.env.dart';

class DonateDataScreen extends StatefulWidget {
  @override
  DonateDataState createState() => DonateDataState();
}

class DonateDataState extends State<DonateDataScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  String email, appId;

  @override
  void initState() {
    super.initState();
    // emailController.text = getSavedEmail() as String;
    getCredentials();
    emailController.selection = TextSelection.fromPosition(TextPosition(offset: emailController.text.length));
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  String _validateEmail(String value) {
    if (value == null || value == '') {
      return 'Email is required';
    }
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);

    if (!regex.hasMatch(value)) {
      return 'Enter valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donate data"),
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Card(
              margin: EdgeInsets.all(10.0),
              elevation: 5.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 10.0, 20.0, 20.0),
                    child: Form(
                      key: _key,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 10.0),
                        Text("Donate your sleep data",
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w400)),
                        SizedBox(height: 5.0),
                        TextFormField(
                          // initialValue: email != null ? email.toString() : "",
                          decoration: InputDecoration(
                            labelText: "Oura account email",
                            labelStyle: TextStyle(color: Colors.blue),
                            hintText: "example@mail.com",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          autofocus: false,
                          validator: _validateEmail,
                          controller: emailController,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 10.0,
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            "Save email",
                          ),
                          textColor: Colors.white,
                          onPressed: () {
                            saveEmail(context, emailController.text);
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)
                          ),
                        ),
                      ],
                    ),
                  ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            Card(
              elevation: 5.0,
              margin: EdgeInsets.all(10.0),
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text("Click below to link your Oura account",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 16.0)),
                    SizedBox(height: 10.0),
                    RaisedButton(
                      child: Text("Click here"),
                      color: Colors.blue,
                      elevation: 5.0,
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0)
                      ),
                      onPressed: () {
                        if (email == null) {
                          showAlertDialog(context);
                        } else {
                          launchLbpSleep();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  void launchLbpSleep() {
    launch(
        "https://crowdcomputing.net/sleep-lbp",
        forceWebView: true,
        forceSafariVC: true,
        enableJavaScript: true
    );
  }

  Future<String> getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('oura_email');
      emailController.text = prefs.getString('oura_email');
      emailController.selection = TextSelection.fromPosition(TextPosition(offset: emailController.text.length));
      appId = prefs.getString("app_id");
    });
    return prefs.getString('oura_email');
  }

  saveEmail(BuildContext context, String emailString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("oura_email", emailString);
    setState(() {
      email = emailString;
      emailController.text = emailString;
      emailController.selection = TextSelection.fromPosition(TextPosition(offset: emailController.text.length));
    });

    saveEmailToRemoteDb();
    // Show snack bar
    showSnackBar(context);
  }

  Future<Widget> showAlertDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
          return AlertDialog(
            content: Text("Kindly enter your Oura email account first."),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
          );
      }
    );
  }

  void showSnackBar(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text("Email saved"),
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
    ));
  }

  Future<http.Response> saveEmailToRemoteDb() async {
    return http.put(
      '${environment['remote_url']}/api/users/${this.appId}',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'email': emailController.text
      }),
    );
  }

}
