import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:lbp/db/database.dart';
import 'package:lbp/model/notifications.dart';
import 'package:lbp/model/Questionnaire.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


import '../env/.env.dart';


class QuestionnairePage extends StatefulWidget {
  final Notifications notification;
  QuestionnairePage({Key key, @required this.notification}) : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}


class _QuestionnairePageState extends State<QuestionnairePage> {

  Questionnaire questionnaire = Questionnaire();
  bool completed = false;
  String selectedValue;
  Notifications _notification;
  List<String> answers = List();
  GSheets gSheets;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
  }

  void checkAnswer(bool userAnswer) {
    setState(() {
      selectedValue = null;
      if (questionnaire.nextQuestion() == true) {
        completed = true;
        _notification = widget.notification;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        elevation: 0,
      ),
      body: buildQuestionsPage(),
    );
  }


  Column buildQuestionsPage() {
    if (completed) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'You have successfully completed this questionnaire.\nThank you.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textColor: Colors.white,
                  color: Colors.blue.shade500,
                  onPressed: () async {
                    sendData(_notification);
                    deleteNotification(_notification);
                    setState(() {
                      completed = false;
                      print("Answers: $answers");
                      Navigator.pop(context);
                    });
                  },
                  child: Text(
                    'Finish',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            ),
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: Center(
                child: Text(
                  questionnaire.getQuestionText(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
              child: Center(
                child: this.answerWidget(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Builder(
                builder: (context) => FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  textColor: Colors.white,
                  color: Colors.green.shade500,
                  onPressed: () {
                    if (selectedValue != null)
                      checkAnswer(true);
                    else
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text("You must answer the question to proceed"),
                        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                      ));
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  )),
            )),
          ),
        ],
      );
    }
  }


  Widget answerWidget() => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, index) {
        return RadioListTile(
          title: Text('${index+1 == 1 ? " ${index+1} Not at all" : index+1 == 5 ? "${index+1} Extremely" : "${index+1}" }', style: TextStyle(color: Colors.white)),
          value: '${index+1}',
          groupValue: selectedValue,
          activeColor: Colors.white,
          onChanged: (String value) {
            setState(() {
              selectedValue = value;
              answers.add(value);
            });
          },
        );
      }
    );

  sendData(Notifications notification) async {
    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('survey');
    sheet ??= await ss.addWorksheet('survey');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");

    List<String> values = List();
    values.add(notification.timestamp);
    values.add(DateTime.now().millisecondsSinceEpoch.toString());
    values.add(id);
    values.add(answers[0]);
    values.add(answers[1]);
    await sheet.values.appendRow(values);
  }


  Future<void> deleteNotification(Notifications notification) async {
    final database = await $FloorAppDatabase.databaseBuilder('database.db').build();
    final notificationDao = database.notificationDao;
    await notificationDao.delete(notification.id);
  }
}
