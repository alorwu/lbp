import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/monthly/PSQIQuestion.dart';
import 'package:lbp/model/monthly/PSQIQuestionnaire.dart';
import 'package:lbp/model/monthly/PromisQuestion.dart';
import 'package:lbp/model/monthly/PromisQuestionnaire.dart';
import 'package:lbp/model/notifications.dart';
import 'package:lbp/utils/CustomSliderThumbCircle.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../env/.env.dart';

class MonthlyPainQuestionnairePage extends StatefulWidget {
  final Notifications notification;

  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  MonthlyPainQuestionnairePage(
      {Key key,
        @required this.notification,
        this.sliderHeight = 48,
        this.max = 10,
        this.min = 0,
        this.fullWidth = false})
      : super(key: key);

  @override
  _MonthlyPainQuestionnairePageState createState() =>
      _MonthlyPainQuestionnairePageState();
}

class _MonthlyPainQuestionnairePageState extends State<MonthlyPainQuestionnairePage> {
  PromisQuestionnaire questionnaire = PromisQuestionnaire();
  Notifications _notification;
  List<String> answers = List();
  GSheets gSheets;

  double sliderValue = 0;
  double realSliderValue = -1;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
    answers.length = questionnaire
        .getPromisQuestions()
        .length;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        elevation: 0,
        title: Text("Monthly pain survey"),
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
    var entries = questionnaire.getPromisQuestions();
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

  Widget answerWidget(PromisQuestion question, int index) {
    switch (question.type) {
      case "likert":
        return comboWidget(question, index);
      case "slider":
        return sliderWidget(question, index);
      default:
        return null;
    }
  }

  Widget sliderWidget(PromisQuestion question, int index) {
      double paddingFactor = .2;
      if (this.widget.fullWidth) paddingFactor = .3;

      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity, //this.widget.fullWidth ? double.infinity : (this.widget.sliderHeight) * 5.5,
              height: (this.widget.sliderHeight),
              decoration: new BoxDecoration(
                borderRadius: new BorderRadius.all(
                  Radius.circular((this.widget.sliderHeight * .3)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.all(1.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '${this.widget.min}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: this.widget.sliderHeight * .3,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      width: this.widget.sliderHeight * .1,
                    ),
                    Expanded(
                      child: Center(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.black.withOpacity(1),
                            inactiveTrackColor: Colors.black,
                            trackHeight: 4.0,
                            thumbShape: CustomSliderThumbCircle(
                              thumbRadius: this.widget.sliderHeight * .4,
                              min: this.widget.min,
                              max: this.widget.max,
                            ),
                            overlayColor: Colors.black,
                            activeTickMarkColor: Colors.black,
                            inactiveTickMarkColor: Colors.black,
                          ),
                          child: Slider(
                              value: sliderValue,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              onChanged: (double value) {
                                print("Value: $value");
                                setState(() {
                                  question.data = value.toString();
                                  sliderValue = value;
                                  realSliderValue = value;
                                });
                              }),
                        ),
                      ),
                    ),
                    Text(
                      '${this.widget.max}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: this.widget.sliderHeight * .3,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${question.low}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: this.widget.sliderHeight * .3,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    '${question.high}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: this.widget.sliderHeight * .3,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ]);
  }

  Widget comboWidget(PromisQuestion question, int index) {
    var list = ["", question.one, question.two, question.three, question.four, question.five];
    return Column(
      children: [
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
            question.one,
            question.two,
            question.three,
            question.four,
            question.five
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
    var sheet = ss.worksheetByTitle('monthly_pain_survey');
    sheet ??= await ss.addWorksheet('monthly_pain_survey');

    List<String> values = List();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");
    questionnaire.getPromisQuestions().forEach((e) => values.add(e.data));
    values.add(DateTime.now().toString());
    values.add(id);

    await sheet.values.appendRow(values);
    answers.clear();
    Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
  }
}
