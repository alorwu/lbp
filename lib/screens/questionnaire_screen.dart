
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/daily/Question.dart';
import 'package:lbp/model/daily/Questionnaire.dart';
import 'package:lbp/model/notifications.dart';
import 'package:lbp/utils/CustomSliderThumbCircle.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../env/.env.dart';

class QuestionnairePage extends StatefulWidget {
  final Notifications notification;

  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  QuestionnairePage(
      {Key key,
        @required this.notification,
        this.sliderHeight = 48,
        this.max = 10,
        this.min = 0,
        this.fullWidth = false})
      : super(key: key);

  @override
  _QuestionnairePageState createState() => _QuestionnairePageState();
}

class _QuestionnairePageState extends State<QuestionnairePage> {
  Questionnaire questionnaire = Questionnaire();
  bool completed = false;
  String selectedValue;
  String notes;
  double sliderValue = 0;
  double realSliderValue = -1;
  Notifications _notification;
  List<String> answers = List();
  GSheets gSheets;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
  }

  void checkAnswer(Question question) {
    if (question.type == "slider") {
      setState(() {
        if (questionnaire.nextQuestion() == true) {
          completed = true;
          _notification = widget.notification;
        }
      });
    } else if (question.type == "likert") {
      setState(() {
        selectedValue = null;
        if (questionnaire.nextQuestion() == true) {
          completed = true;
          _notification = widget.notification;
        }
      });
    }
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
            flex: 3,
            child: Padding(
              padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
              child: Center(
                child: Text(
                  questionnaire.getQuestion().question,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 25.0),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: TextField(
                    decoration: new InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[700],
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white, width: 1.0)
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: "Enter free form text here",
                      helperText: "No answer is wrong. Write freely.",
                      helperStyle: TextStyle(color: Colors.white),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 12,
                    onChanged: (String value) {
                      setState(() {
                        notes = value;
                      });
                    },
                  ),
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
                  color: Colors.green.shade500,
                  onPressed: () async {
                    await MyPreferences.saveDateTaken(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                    answers.add(notes);
                    sendData(_notification);
                    setState(() {
                      completed = false;
                      Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
                    });
                  },
                  child: Text(
                    'Submit',
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
                  questionnaire.getQuestion().question,
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
                child: this.answerWidget(questionnaire.getQuestion()),
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
                        if (questionnaire.getQuestion().type == "slider") {
                          if (realSliderValue != -1) {
                            answers.add(realSliderValue.toInt().toString());
                            checkAnswer(questionnaire.getQuestion());
                          } else {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                              Text("Move the slider to select a value"),
                              backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
                            ));
                          }
                        } else if (selectedValue != null) {
                          answers.add(selectedValue);
                          checkAnswer(questionnaire.getQuestion());
                        } else
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                            Text("You must answer the question to proceed"),
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

  Widget answerWidget(Question question) {
    if (question.type == "slider") {
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
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      width: this.widget.sliderHeight * .1,
                    ),
                    Expanded(
                      child: Center(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: Colors.white.withOpacity(1),
                            inactiveTrackColor: Colors.white.withOpacity(.5),
                            trackHeight: 4.0,
                            thumbShape: CustomSliderThumbCircle(
                              thumbRadius: this.widget.sliderHeight * .4,
                              min: this.widget.min,
                              max: this.widget.max,
                            ),
                            overlayColor: Colors.white.withOpacity(.4),
                            activeTickMarkColor: Colors.white,
                            inactiveTickMarkColor: Colors.red.withOpacity(.7),
                          ),
                          child: Slider(
                              value: sliderValue,
                              min: 0,
                              max: 10,
                              divisions: 10,
                              onChanged: (double value) {
                                print("Value: $value");
                                setState(() {
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
                        color: Colors.white,
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
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      '${question.high}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: this.widget.sliderHeight * .3,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ]);
    } else if (question.type == "likert") {
      return answerRadioWidget(question);
    } else {
      return null;
    }
  }

  Widget answerRadioWidget(Question question) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, index) {
        return RadioListTile(
          title: Text(
              '${index + 1 == 1 ? " ${index + 1} ${question.low}" : index + 1 == 5 ? "${index + 1} ${question.high}" : "${index + 1}"}',
              style: TextStyle(color: Colors.white)),
          value: '${index + 1}',
          groupValue: selectedValue,
          activeColor: Colors.white,
          onChanged: (String value) {
            setState(() {
              selectedValue = value;
            });
          },
        );
      });

  sendData(Notifications notification) async {
    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('survey');
    sheet ??= await ss.addWorksheet('survey');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");

    List<String> values = List();
    values.add(DateTime.now().millisecondsSinceEpoch.toString());
    values.add(id);
    values.add(answers[0]);
    values.add(answers[1]);
    values.add(answers[2]);
    values.add(answers[3]);
    values.add(answers[4]);
    values.add(answers[5]);
    values.add(answers[6]);
    await sheet.values.appendRow(values);
    answers.clear();
  }

}

