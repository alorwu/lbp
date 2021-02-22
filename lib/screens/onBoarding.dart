import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lbp/env/.env.dart';

class OnBoarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new OnBoardingState();
}

class OnBoardingState extends State<OnBoarding> {
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  String selectedValue;
  GSheets gSheets;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Welcome - Sleep Better'),
        ),
        body: Builder(
          builder: (context) => Padding(
            padding: EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Before you begin, tell us a little about yourself",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'How old are you?',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'What is your gender?',
                      border: OutlineInputBorder(),
                    ),
                    controller: genderController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter your gender';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'How long have you had Low Back Pain? (months)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: durationController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Tell us how long you've had low back pain";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 10.0,),
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Have you been clinically diagnosed with Low Back Pain by a doctor?',
                          style: TextStyle(fontSize: 16.0),
                        ),
                        ListTile(
                          title: const Text('No'),
                          leading: Radio(
                            value: "0",
                            groupValue: selectedValue,
                            onChanged: (String value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text('Yes'),
                          leading: Radio(
                            value: "1",
                            groupValue: selectedValue,
                            onChanged: (String value) {
                              setState(() {
                                selectedValue = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ProgressButton(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blue,
                      child: Text('Get started', style: TextStyle(color: Colors.white)),
                      onPressed: (AnimationController controller) async {
                        await MyPreferences.updateOnboarding(false);
                        await MyPreferences.saveMonthlyDateTaken(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                        await MyPreferences.saveNotificationTime("07:00");
                        if (_formKey.currentState.validate()) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Your notification time has been set to 07:00. You can change this in the settings screen later.",
                                style: TextStyle(color: Colors.white)),
                          ));
                          sendData(
                              controller,
                              ageController.text,
                              genderController.text,
                              durationController.text,
                              selectedValue
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }

  sendData(AnimationController animationController, String age, String gender, String duration, String diagnosis) async {
    animationController.forward();

    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('user_info');
    sheet ??= await ss.addWorksheet('user_info');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");
    prefs.setString('segment', '07:00');

    List<String> values = List();
    values.add(id);
    values.add(age);
    values.add(gender);
    values.add(duration);
    if (diagnosis == "0")
      values.add("No");
    else if (diagnosis == "1")
      values.add("Yes");
    else values.add("null");
    var result = await sheet.values.appendRow(values);
    if (result) {
      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      animationController.stop();
    }
  }

}