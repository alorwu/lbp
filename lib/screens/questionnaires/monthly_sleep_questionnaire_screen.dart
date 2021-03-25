
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/monthly/PSQIQuestion.dart';
import 'package:lbp/model/monthly/PSQIQuestionnaire.dart';
import 'package:lbp/model/notifications.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env/.env.dart';

class MonthlyQuestionnairePage extends StatefulWidget {
  final Notifications notification;

  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  MonthlyQuestionnairePage(
      {Key key,
        @required this.notification,
        this.sliderHeight = 48,
        this.max = 10,
        this.min = 0,
        this.fullWidth = false})
      : super(key: key);

  @override
  _MonthlyQuestionnairePageState createState() =>
      _MonthlyQuestionnairePageState();
}

class _MonthlyQuestionnairePageState extends State<MonthlyQuestionnairePage> {
  PSQIQuestionnaire questionnaire = PSQIQuestionnaire();
  Notifications _notification;
  // List<String> answers = List();
  GSheets gSheets;
  final _formKey = GlobalKey<FormState>();


  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
    // answers.length = questionnaire
    //     .getPSQIQuestions()
    //     .length;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        elevation: 0,
        title: Text("Monthly Sleep Survey"),
      ),
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: buildQuestionsPage(),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ProgressButton(
                        borderRadius: BorderRadius.circular(8.0),
                      color: Colors.blue,
                      onPressed: (AnimationController animationController) async {
                        if (_formKey.currentState.validate()) {
                          await MyPreferences.saveLastMonthlySleepSurveyDate(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                          sendData(_notification, animationController);
                          // setState(() {
                          //   // Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                          // });
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildQuestionsPage() {
    var entries = questionnaire.getPSQIQuestions();
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10.0),
      itemCount: entries.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 3,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: [
                Text(
                  entries[index].number + ". " + entries[index].question,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18.0),
                ),
                Center(
                  child: this.answerWidget(entries[index], index),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget answerWidget(PSQIQuestion question, int index) {
    switch (question.type) {
      case "likert":
        return comboWidget(question, index);
      case "freeformlikert":
        return freeFormWidget(question, index);
      case "text":
        return textWidget(question, index);
      default:
        return null;
    }
  }

  Widget textWidget(PSQIQuestion question, int index) {
    return Container(
      margin: EdgeInsets.all(12),
      child: bedTime(question, index),
    );
  }

  Widget bedTime(PSQIQuestion question, int index) {
    List<String> time;
    switch(question.subtitle) {
      case 'BED TIME':
        time = [
          '00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00',
          '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00',
          '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'];
        break;
      case 'NUMBER OF MINUTES':
        time = ["1-15", '16-30', '30-60', '60+'];
        break;
      case 'GETTING UP TIME':
        time = [
          '00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00',
          '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00',
          '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'];
        break;
      case 'HOURS OF SLEEP PER NIGHT':
        time = ["1 hour", "2 hours", "3 hours", "4 hours",
          "5 hours", "6 hours", "7 hours", "8 hours", "9 hours", "10 hours",
          "11 hours", "12 hours", "13 hours", "14 hours", "15 hours", "16 hours",
          "17 hours", "18 hours", "19 hours", "20 hours", "21 hours", "22 hours",
          "23 hours", "24 hours"];
        break;
      default:
    }
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: "Choose one",
        hintStyle: TextStyle(color: Colors.grey),
      ),
      iconSize: 24,
      elevation: 16,
      // underline: Container(
      //   height: 2,
      //   color: Colors.black54,
      // ),
      onChanged: (String newValue) {
        // var val = time.indexOf(newValue);
        setState(() {
          question.data = newValue;
          // answers[index] = newValue;
        });
      },
      items: time.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value, overflow: TextOverflow.clip),
        );
      }).toList(),
      validator: (value) {
        if (value == null) {
          return "Please select one";
        }
        return null;
      },
      value: question.data,
    );

  }


  Widget freeFormWidget(PSQIQuestion question, int index) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Text(
            question.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        Center(
          child: Container(
            margin: EdgeInsets.all(12),
            child: TextFormField(
              focusNode: new FocusNode(),
              decoration: InputDecoration(
                hintText: "Enter text here",
                hintStyle: TextStyle(color: Colors.grey),
                // labelText: 'How old are you (in years)?',
                // border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                setState(() {
                  // answers[index] = value;
                  question.data = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget comboWidget(PSQIQuestion question, int index) {
    return Column(
      children: [
        question.subtitle.length == 0 ? Container() :
        Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Text(
            question.subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: "Choose one",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          iconSize: 24,
          elevation: 16,
          // underline: Container(
          //   height: 2,
          //   color: Colors.black54,
          // ),
          onChanged: (String newValue) {
            setState(() {
              question.data = newValue;
              // answers[index] = newValue;
            });
          },
          items: <String>[
            question.notInPastMonth,
            question.lessThanOnceAWeek,
            question.onceOrTwiceAWeek,
            question.threeOrMoreAWee3k
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, overflow: TextOverflow.clip),
            );
          }).toList(),
          validator: (value) {
            if (question.number.startsWith("10") && question.number.length > 2) {
              return null;
            }
            if (value == null) {
              return "Please select one";
            }
            return null;
          },
          value: question.data,
        ),
        SizedBox(height: 5.0),
      ],
    );
  }

  sendData(Notifications notification, AnimationController animationController) async {
    animationController.forward();

    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('monthly_sleep_survey');
    sheet ??= await ss.addWorksheet('monthly_sleep_survey');

    List<String> values = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");
    questionnaire.getPSQIQuestions().forEach((e) => values.add(e.data));
    values.add(DateTime.now().toString());
    values.add(id);

    var result = await sheet.values.appendRow(values);
    // answers.clear();
    // Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Your entry has been saved.",
            style: TextStyle(color: Colors.white)),
      )).closed
          .then((value) {
        animationController.stop();
        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "Unable to save data. Check your internet connection and try again.",
            style: TextStyle(color: Colors.red)),
      )).closed
          .then((value) {
        animationController.stop();
      });
    }
  }
}
