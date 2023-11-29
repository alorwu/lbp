import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lbp/features/mobility/domain/entity/mobility_data.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/entity/daily/daily_q.dart';
import '../../domain/entity/questionnaires/daily/question.dart';
import '../../domain/entity/questionnaires/daily/questionnaire.dart';
import '../../domain/entity/remote/DailySurvey.dart';
import '../../env/.env.dart';
import '../../utils/custom_slider_thumb_circle.dart';
import '../../utils/preferences.dart';


class QuestionnairePage extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  QuestionnairePage(
      {Key? key,
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
  DateTime? timePickerValue;
  String? selectedValue;
  String? notes;
  late GSheets gSheets;

  ButtonState submitButtonState = ButtonState.idle;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
  }

  void resetValues() {
    setState(() {
      timePickerValue = null;
      selectedValue = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          elevation: 0,
          // systemOverlayStyle: SystemUiOverlayStyle.dark,
          brightness: Brightness.dark,
          title: Text("Today's Survey"),
          automaticallyImplyLeading: false,
      ),
      body: buildQuestionsPage(),
    );
  }

  Widget buildQuestionsPage() {
      return Padding(
        padding: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
        child: Card(
          color: Colors.white24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Center(
                child: DotsIndicator(
                  dotsCount: questionnaire.getQuestionnaireLength(),
                  position: questionnaire.questionNumber().toDouble(),
                  decorator: DotsDecorator(
                    size: Size.square(12),
                    activeSize: Size(15, 15),
                    activeColor: Colors.white70,
                    color: Colors.black54,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "${questionnaire.questionNumber() + 1} / ${questionnaire.getQuestionnaireLength().toString()}",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
              SizedBox(
                height: 24,
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text(
                      questionnaire.getQuestion().question!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18.0),
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
              Expanded(
                child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    questionnaire.questionNumber() > 0
                        ? prevButton()
                        : Container(),
                    questionnaire.lastQuestion()
                        ? submitButton()
                        : nextButton()
                  ],
                ),
              ),),
            ],
          ),
        ),
      );
  }

  Widget submitButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ProgressButton.icon(
        iconedButtons: {
          ButtonState.idle: IconedButton(
              text: "Submit",
              icon: Icon(Icons.send, color: Colors.white),
              color: Colors.green),
          ButtonState.loading: IconedButton(
              color: Colors.green
          ),
          ButtonState.fail: IconedButton(
              text: "Failed",
              icon: Icon(Icons.cancel, color: Colors.white),
              color: Colors.red.shade500),
          ButtonState.success: IconedButton(
              text: "Success",
              icon: Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              color: Colors.green.shade400)
        },
        progressIndicatorSize: 15.0,
        onPressed: () async {
          await Preferences.saveDateTaken(
              DateFormat("yyyy-MM-dd").format(DateTime.now()));
          sendData();
        },
        state: submitButtonState,
      ),
    );
  }

  Widget prevButton() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white)),
            onPressed: () => prevButtonClickHandler(),
            child: Text(
              'Prev',
              style: TextStyle(color: Colors.white),
            ))
    );
  }

  Widget nextButton() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white)),
            onPressed: () => nextButtonClickHandler(),
            child: Text(
              'Next',
              style: TextStyle(color: Colors.white),
            ))
    );
  }

  void prevButtonClickHandler() {
    setState(() {
      resetValues();
      if (questionnaire.prevQuestion() == false) {
        // completed = false;
      }
    });
  }

  void nextButtonClickHandler() {
    if (questionnaire.getQuestion().data != null) {
      setState(() {
        resetValues();
        if (questionnaire.nextQuestion() == true) {
          // completed = true;
        }
      });
    } else
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(
        content: Text(
            "You must answer the question to proceed"),
        backgroundColor:
        Color.fromRGBO(58, 66, 86, 1.0),
        duration: Duration(seconds: 1),
      ));
  }

  Widget answerWidget(Question question) {
    switch (question.type) {
      case "slider":
        return answerSliderWidget(question);
      case "likert":
        return answerLikertWidget(question);
      case "date_picker":
        return answerDatePickerWidget();
      case "radio":
        return answerRadioWidget(question);
      default:
        return answerNotesWidget();
    }
  }

  Widget answerRadioWidget(Question question) {
    var list = ["Both affected each other", "Sleep affected back pain", "Back pain affected sleep", "Neither sleep nor pain affected the other", "I do not know"];
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, index) {
          return Theme(
            data: Theme.of(context).copyWith(
                unselectedWidgetColor: Colors.white,
                disabledColor: Colors.white),
            child: RadioListTile(
              title: Text(
                  '${index == 0
                      ? list[index]
                      : index == 1
                      ? list[index]
                  : index == 2
                      ? list[index]
                  : index == 3
                      ? list[index]
                      : list[index] }',
                  style: TextStyle(color: Colors.white)),
              value: "${list[index]}",
              groupValue: question.data,
              activeColor: Colors.white,
              onChanged: (String? value) {
                setState(() {
                  question.data = value;
                });
              },
            ),
          );
        });
  }

    Widget answerNotesWidget() {
      return Padding(
        padding: EdgeInsets.all(10.0),
        child: Center(
          child: Container(
            child: TextFormField(
              initialValue: questionnaire.getQuestion().data != null ? questionnaire.getQuestion().data : "",
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
              autocorrect: false,
              keyboardType: TextInputType.text,
              enableSuggestions: false,
              maxLines: 6,
              onChanged: (String value) {
                setState(() {
                  questionnaire.getQuestion().data = value;
                });
              },
            ),
          ),
        ),
      );
    }

    Widget answerDatePickerWidget() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          questionnaire.getQuestion().data != null
              ? Text(
            DateFormat("hh:mm a").format(DateTime.parse(questionnaire.getQuestion().data!)),
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white),
          )
              : Container(),
          SizedBox(
            height: 20.0,
          ),
          OutlinedButton.icon(
            onPressed: () => showCupertinoDatePicker(),//showDate(context),
            icon: Icon(Icons.access_alarm),
            label: Text(questionnaire.getQuestion().data != null ? 'Change time' : 'Select time', style: TextStyle(color: Colors.white70)),
            style: OutlinedButton.styleFrom(primary: Colors.white70, side: BorderSide(color: Colors.white70)),
          ),
        ],
      );
    }

    showCupertinoDatePicker() {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext builder) {
            return Container(
              height: MediaQuery
                  .of(context)
                  .copyWith()
                  .size
                  .height * 0.25,
              color: Colors.white,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                onDateTimeChanged: (value) {
                  setState(() {
                    questionnaire.getQuestion().data = DateFormat("yyyy-MM-dd HH:mm").format(value);
                  });
                },
                  initialDateTime: questionnaire.questionNumber() == 0
                    ? DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        21,
                        0,
                        0)
                    : DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day, 06, 0, 0), //DateTime.now(),
              ),
            );
          }
      );
    }

    Widget answerSliderWidget(Question question) {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
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
                            activeTrackColor: Colors.blue.withOpacity(1),
                            trackHeight: 4.0,
                            thumbShape: CustomSliderThumbCircle(
                              thumbRadius: this.widget.sliderHeight * .4,
                              min: this.widget.min,
                              max: this.widget.max,
                            ),
                            activeTickMarkColor: Colors.blue,
                            inactiveTickMarkColor: Colors.white,
                          ),
                          child: Slider(
                              value: double.parse(question.data ?? "0"),
                              min: 0,
                              max: 10,
                              divisions: 10,
                              onChanged: (double value) {
                                setState(() {
                                  question.data = value.toInt().toString();
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

    Widget answerLikertWidget(Question question) => ListView.builder(
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
              groupValue: question.data,
              activeColor: Colors.white,
              onChanged: (String? value) {
                setState(() {
                  question.data = value;
                });
              },
            ),
          );
        });

    sendData() async {
      setState(() {
        submitButtonState = ButtonState.loading;
      });
      await Preferences.saveDateTaken(
          DateFormat("yyyy-MM-dd").format(DateTime.now()));
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var id = prefs.getString("app_id");

      List values = [];
      questionnaire.getQuestions().forEach((e) => values.add(e.data));
      values.insert(0, DateTime.now().millisecondsSinceEpoch.toString());
      values.insert(1, id);
      values.add(DateTime.now().toString());

      final ss = await gSheets.spreadsheet(environment['spreadsheetId'] as String);
      var sheet = ss.worksheetByTitle('daily_survey');
      sheet ??= await ss.addWorksheet('daily_survey');
      saveDataLocally(values);
      try {

        var dailyQ = DailyQ(
            dateTaken: DateTime.now(),
            sleepTime: DateTime.parse(values[2]),
            wakeupTime: DateTime.parse(values[3]),
            numberOfWakeupTimes: int.parse(values[4]),
            qualityOfSleep: int.parse(values[5]),
            painIntensity: int.parse(values[6]),
            painAffectSleep: values[7],
            notes: values[8],
        );
        values.add(dailyQ.sleepPeriod.toString());

        var surveyData = DailySurvey(
          sleepTime: DateTime.parse(values[2]),
          wakeupTime: DateTime.parse(values[3]),
          numberOfWakeupTimes: int.parse(values[4]),
          qualityOfSleep: int.parse(values[5]),
          painIntensity: int.parse(values[6]),
          painSleepRelationship: values[7],
          notes: values[8],
          sleepDuration: dailyQ.sleepPeriod[0].toString() + "." + dailyQ.sleepPeriod[1].toString(),
          dateTaken: DateTime.now(),
          userId: id,
        );
        saveDailySurveyToRemoteDb(surveyData);

        var result = await sheet.values.appendRow(values);
        if (result) {
          setState(() {
            submitButtonState = ButtonState.success;
          });
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
            content: Text("Your entry has been saved.",
                style: TextStyle(color: Colors.white)),
            duration: Duration(seconds: 1),
          ))
              .closed
              .then((value) {
            Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
          });
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(
            content: Text(
                "Unable to save data. Check your internet connection and try again.",
                style: TextStyle(color: Colors.red)),
            duration: Duration(seconds: 1),
          ))
              .closed
              .then((value) {
            setState(() {
              submitButtonState = ButtonState.fail;
            });
          });
        }
      } catch (exp) {
        setState(() {
          submitButtonState = ButtonState.fail;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("An error occurred. Please try again.",
              style: TextStyle(color: Colors.red)),
          duration: Duration(seconds: 1),
        ));
      }
    }

    void saveDataLocally(List<dynamic> values) async {
      var dailyQ = DailyQ(
          dateTaken: DateTime.now(),
          sleepTime: DateTime.parse(values[2]),
          wakeupTime: DateTime.parse(values[3]),
          numberOfWakeupTimes: int.parse(values[4]),
          qualityOfSleep: int.parse(values[5]),
          painIntensity: int.parse(values[6]),
          painAffectSleep: values[7],
          notes: values[8],
      );
      Box<DailyQ> box = Hive.box("dailyBox");
      await box.put(DateFormat("yyyy-MM-dd").format(DateTime.now()), dailyQ);
    }

    MobilityData? getYesterdayMobilityData() {
      final df = new DateFormat("dd-MM-yyyy");
      final key = df.format(DateTime.now().subtract(Duration(days: 1)));
      Box<MobilityData> box = Hive.box("mobility_data");
      return box.values.firstWhereOrNull((element) => df.format(element.date!) == key);
    }

  Future<http.Response> saveDailySurveyToRemoteDb(DailySurvey survey) async {
    return http.post(
      Uri.parse('${environment['remote_url']}/api/surveys/daily'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(survey.toJson()),
    );
  }
}


