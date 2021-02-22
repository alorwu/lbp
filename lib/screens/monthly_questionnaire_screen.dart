import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/monthly/PSQIQuestion.dart';
import 'package:lbp/model/monthly/PSQIQuestionnaire.dart';
import 'package:lbp/model/notifications.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../env/.env.dart';

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
  List<String> answers = List();
  GSheets gSheets;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
    answers.length = questionnaire
        .getPSQIQuestions()
        .length;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        elevation: 0,
        title: Text("Monthly sleep survey"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: buildQuestionsPage(),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                textColor: Colors.white,
                color: Colors.green.shade500,
                onPressed: () async {
                  sendData(_notification);
                  setState(() {
                    // Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                  });
                },
                child: Text(
                  'Submit',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                )),
          ),
        ],
      ),
    );
  }

  Widget buildQuestionsPage() {
    var entries = questionnaire.getPSQIQuestions();
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: entries.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 5,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: Colors.amber[200],
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
        time = ["",
          '00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00',
          '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00',
          '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'];
        break;
      case 'NUMBER OF MINUTES':
        time = ["", "1-15", '16-30', '30-60', '60+'];
        break;
      case 'GETTING UP TIME':
        time = ["",
          '00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00',
          '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00',
          '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'];
        break;
      case 'HOURS OF SLEEP PER NIGHT':
        time = ["", "1 hour", "2 hours", "3 hours", "4 hours",
          "5 hours", "6 hours", "7 hours", "8 hours", "9 hours", "10 hours",
          "11 hours", "12 hours", "13 hours", "14 hours", "15 hours", "16 hours",
          "17 hours", "18 hours", "19 hours", "20 hours", "21 hours", "22 hours",
          "23 hours", "24 hours"];
        break;
      default:
    }
    return DropdownButton<String>(
      value: question.data,
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.black54,
      ),
      onChanged: (String newValue) {
        // var val = time.indexOf(newValue);
        setState(() {
          question.data = newValue;
          answers[index] = newValue;
        });
      },
      items: time.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
            child: TextField(
              keyboardType: TextInputType.text,
              onChanged: (String value) {
                setState(() {
                  answers[index] = value;
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
        DropdownButton<String>(
          value: question.data,
          iconSize: 24,
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.black54,
          ),
          onChanged: (String newValue) {
            setState(() {
              question.data = newValue;
              answers[index] = newValue;
            });
          },
          items: <String>[
            "",
            question.notInPastMonth,
            question.lessThanOnceAWeek,
            question.onceOrTwiceAWeek,
            question.threeOrMoreAWee3k
          ].map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  sendData(Notifications notification) async {
    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('monthly_sleep_survey');
    sheet ??= await ss.addWorksheet('monthly_sleep_survey');

    List<String> values = List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");
    questionnaire.getPSQIQuestions().forEach((e) => values.add(e.data));
    values.add(DateTime.now().toString());
    values.add(id);

    await sheet.values.appendRow(values);
    answers.clear();
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }
}
