import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gsheets/gsheets.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/daily/Question.dart';
import 'package:lbp/model/daily/Questionnaire.dart';
import 'package:lbp/model/hive/daily/DailyQ.dart';
import 'package:lbp/utils/CustomSliderThumbCircle.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env/.env.dart';

class QuestionnairePage extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  QuestionnairePage(
      {Key key,
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
  DateTime timePickerValue;
  String selectedValue;
  String notes;
  double sliderValue = 0;
  double realSliderValue = -1;
  List<String> answers = [];
  GSheets gSheets;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
  }

  void checkAnswer(Question question) {
    if (question.type == "slider") {
      setState(() {
        realSliderValue = -1;
        sliderValue = 0;
        if (questionnaire.nextQuestion() == true) {
          completed = true;
        }
      });
    } else if (question.type == "likert") {
      setState(() {
        selectedValue = null;
        if (questionnaire.nextQuestion() == true) {
          completed = true;
        }
      });
    } else if (question.type == "date_picker") {
      setState(() {
        timePickerValue = null;
        if (questionnaire.nextQuestion() == true) {
          completed = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff000000),
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Color(0xff000000),
          elevation: 0,
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          brightness: Brightness.dark,
          title: Text("Today's Survey")),
      body: buildQuestionsPage(),
    );
  }

  Widget buildQuestionsPage() {
    if (completed) {
      return Card(
        color: Colors.black26,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
                child: Center(
                  child: Text(
                    // questionnaire.getQuestion().question,
                    "About last night, how did your pain affect your sleep and/or how did your sleep affect your pain?",
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
                    margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
                    child: TextField(
                      decoration: new InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.white, width: 1.0)),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        hintText: "Enter free form text here",
                        helperText: "No answer is wrong. Write freely.",
                        helperStyle: TextStyle(color: Colors.white),
                      ),
                      keyboardType: TextInputType.text,
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
                child: ProgressButton(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Colors.green,
                  onPressed: (AnimationController controller) async {
                    await MyPreferences.saveDateTaken(
                        DateFormat("yyyy-MM-dd").format(DateTime.now()));
                    answers.add(notes);
                    sendData(controller);
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.all(20.0),
        child: Card(
          color: Colors.white60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 16,
              ),
              Center(
                child: DotsIndicator(
                  dotsCount: questionnaire.getQuestionnaireLength(),
                  position: questionnaire.questionNumber().toDouble(),
                  decorator: DotsDecorator(
                    size: Size.square(15),
                    activeSize: Size(18, 18),
                    activeColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
              SizedBox(
                height: 24,
              ),
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
                  padding:
                      EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                  child: Center(
                    child: this.answerWidget(questionnaire.getQuestion()),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  questionnaire.questionNumber() > 0
                      ? TextButton(
                          onPressed: () => prevButtonClickHandler(),
                          child: Text(
                            'Prev',
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ))
                      : Container(),
                  TextButton(
                      onPressed: () => nextButtonClickHandler(),
                      child: Text(
                        'Next',
                        style:
                        TextStyle(color: Colors.white, fontSize: 20.0),
                      )
                  ),
                ],
                // padding: Padding(
                //     padding: EdgeInsets.all(10.0),
                //     child: Builder(
                //       builder: (context) => TextButton(
                //           onPressed: () => nextButtonClickHandler(),
                //           child: Text(
                //             'Next',
                //             style:
                //                 TextStyle(color: Colors.white, fontSize: 20.0),
                //           )),
                //     )),
              ),
            ],
          ),
        ),
      );
    }
  }

  void prevButtonClickHandler() {
    // answers.remove(answers.length -1);
    questionnaire.prevQuestion();
  }

  void nextButtonClickHandler() {
    if (questionnaire.getQuestion().type ==
        "date_picker") {
      answers.add(DateFormat("yyyy-MM-dd HH:mm:ss")
          .format((timePickerValue)));
      checkAnswer(questionnaire.getQuestion());
    } else if (questionnaire.getQuestion().type ==
        "slider") {
      if (realSliderValue != -1) {
        answers.add(realSliderValue.toInt().toString());
        checkAnswer(questionnaire.getQuestion());
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
          content:
          Text("Move the slider to select a value"),
          backgroundColor:
          Color.fromRGBO(58, 66, 86, 1.0),
        ));
      }
    } else if (selectedValue != null) {
      answers.add(selectedValue);
      checkAnswer(questionnaire.getQuestion());
    } else
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text(
            "You must answer the question to proceed"),
        backgroundColor:
        Color.fromRGBO(58, 66, 86, 1.0),
      ));
  }

  Widget answerWidget(Question question) {
    switch (question.type) {
      case "slider":
        return answerSliderWidget(question);
      case "likert":
        return answerRadioWidget(question);
      case "date_picker":
        return answerDatePickerWidget();
      default:
        return null;
    }
  }

  Widget answerDatePickerWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        timePickerValue != null
            ? Text(
                DateFormat("hh:mm a").format(timePickerValue),
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              )
            : Container(),
        SizedBox(
          height: 20.0,
        ),
        SizedBox(
          width: 200.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(20.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                )),
            onPressed: () => showDate(context),
            child: Text(
              timePickerValue != null ? 'Change time' : 'Select time',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  showDate(BuildContext context) async {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        print(date);
        setState(() {
          timePickerValue = date;
        });
      },
      currentTime: DateTime.now(),
    );
  }

  Widget answerSliderWidget(Question question) {
    // double paddingFactor = .2;
    // if (this.widget.fullWidth) paddingFactor = .3;
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            //this.widget.fullWidth ? double.infinity : (this.widget.sliderHeight) * 5.5,
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
  }

  Widget answerRadioWidget(Question question) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, index) {
        return Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.white, disabledColor: Colors.white),
          child: RadioListTile(
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
          ),
        );
      });

  sendData(AnimationController animationController) async {
    animationController.forward();
    saveDataLocally(answers);
    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('daily_q');
    sheet ??= await ss.addWorksheet('daily_q');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");

    List values = [];
    values.add(DateTime.now().millisecondsSinceEpoch.toString());
    values.add(id);
    values.add(answers[0]);
    values.add(answers[1]);
    values.add(answers[2]);
    values.add(answers[3]);
    values.add(answers[4]);
    values.add(answers[5]);
    values.add(answers[6]);
    values.add(DateTime.now().toString());
    try {
      var result = await sheet.values.appendRow(values);
      if (result) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: Text("Your entry has been saved.",
                  style: TextStyle(color: Colors.white)),
            ))
            .closed
            .then((value) {
          answers.clear();
          animationController.stop();
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: Text(
                  "Unable to save data. Check your internet connection and try again.",
                  style: TextStyle(color: Colors.red)),
            ))
            .closed
            .then((value) {
          animationController.stop();
          animationController.reset();
        });
      }
    } catch (exp) {
      animationController.stop();
      animationController.reset();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred. Please try again.",
            style: TextStyle(color: Colors.red)),
      ));
    }
  }

  void saveDataLocally(List<String> answers) async {
    var dailyQ = DailyQ(
        dateTaken: DateTime.now(),
        sleepTime: DateTime.parse(answers[0]),
        wakeupTime: DateTime.parse(answers[1]),
        timeToSleep: answers[2],
        numberOfWakeupTimes: int.parse(answers[3]),
        wellRestedness: answers[4],
        qualityOfSleep: int.parse(answers[5]),
        painIntensity: int.parse(answers[6]),
        notes: answers[7]);
    Box<DailyQ> box = Hive.box("testBox");
    await box.put(DateFormat("yyyy-MM-dd").format(DateTime.now()), dailyQ);
  }
}
