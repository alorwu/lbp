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
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
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

  ButtonState submitButtonState = ButtonState.idle;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
  }

  void resetValues() {
    setState(() {
      timePickerValue = null;
      sliderValue = 0;
      realSliderValue = -1;
      selectedValue = null;
    });
  }
  // void checkAnswer(Question question) {
  //   setState(() {
  //     resetValues();
  //     if (questionnaire.nextQuestion() == true) {
  //       completed = true;
  //     }
  //   });

    // if (question.type == "slider") {
    //   setState(() {
    //     realSliderValue = -1;
    //     sliderValue = 0;
    //     if (questionnaire.nextQuestion() == true) {
    //       completed = true;
    //     }
    //   });
    // } else if (question.type == "likert") {
    //   setState(() {
    //     selectedValue = null;
    //     if (questionnaire.nextQuestion() == true) {
    //       completed = true;
    //     }
    //   });
    // } else if (question.type == "date_picker") {
    //   setState(() {
    //     timePickerValue = null;
    //     if (questionnaire.nextQuestion() == true) {
    //       completed = true;
    //     }
    //   });
    // }
  // }

  // void checkAnswerPrev(Question question) {
  //   setState(() {
  //     resetValues();
  //     if (questionnaire.prevQuestion() == false) {
  //       completed = false;
  //     }
  //   });

    // if (question.type == "slider") {
    //   setState(() {
    //     realSliderValue = -1;
    //     sliderValue = 0;
    //     if (questionnaire.prevQuestion() == false) {
    //       completed = false;
    //     }
    //   });
    // } else if (question.type == "likert") {
    //   setState(() {
    //     selectedValue = null;
    //     if (questionnaire.prevQuestion() == false) {
    //       completed = false;
    //     }
    //   });
    // } else if (question.type == "date_picker") {
    //   setState(() {
    //     timePickerValue = null;
    //     if (questionnaire.prevQuestion() == false) {
    //       completed = false;
    //     }
    //   });
    // }
  // }

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
          title: Text("Today's Survey"),
          automaticallyImplyLeading: false,
      ),
      body: buildQuestionsPage(),
    );
  }

  Widget buildQuestionsPage() {
    // if (completed) {
    //   return Card(
    //     color: Colors.black26,
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.stretch,
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: <Widget>[
    //         Expanded(
    //           flex: 3,
    //           child: Padding(
    //             padding: EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
    //             child: Center(
    //               child: Text(
    //                 // questionnaire.getQuestion().question,
    //                 "About last night, how did your pain affect your sleep and/or how did your sleep affect your pain?",
    //                 textAlign: TextAlign.center,
    //                 style: TextStyle(color: Colors.white, fontSize: 25.0),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           flex: 5,
    //           child: Padding(
    //             padding: EdgeInsets.all(10.0),
    //             child: Center(
    //               child: Container(
    //                 margin: EdgeInsets.fromLTRB(12, 0, 12, 0),
    //                 child: TextField(
    //                   decoration: new InputDecoration(
    //                     filled: true,
    //                     fillColor: Colors.white,
    //                     enabledBorder: const OutlineInputBorder(
    //                         borderSide: const BorderSide(
    //                             color: Colors.white, width: 1.0)),
    //                     focusedBorder: const OutlineInputBorder(
    //                       borderSide: BorderSide(color: Colors.white),
    //                     ),
    //                     hintStyle: TextStyle(color: Colors.grey),
    //                     hintText: "Enter free form text here",
    //                     helperText: "No answer is wrong. Write freely.",
    //                     helperStyle: TextStyle(color: Colors.white),
    //                   ),
    //                   keyboardType: TextInputType.text,
    //                   maxLines: 12,
    //                   onChanged: (String value) {
    //                     setState(() {
    //                       notes = value;
    //                     });
    //                   },
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ),
    //         Expanded(
    //           child: Padding(
    //             padding: EdgeInsets.all(10.0),
    //             child: ProgressButton(
    //               // borderRadius: BorderRadius.circular(50.0),
    //               // color: Colors.green,
    //               // onPressed: (AnimationController controller) async {
    //               //   await MyPreferences.saveDateTaken(
    //               //       DateFormat("yyyy-MM-dd").format(DateTime.now()));
    //               //   answers.add(notes);
    //               //   sendData(controller);
    //               // },
    //               // child: Text(
    //               //   'Submit',
    //               //   style: TextStyle(color: Colors.white, fontSize: 20.0),
    //               // ),
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   );
    // } else {
      return Padding(
        padding: EdgeInsets.all(20.0),
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
                    activeColor: Colors.white70, //Theme.of(context).primaryColor,
                    color: Colors.black54 //Theme.of(context).disabledColor,
                  ),
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
                      questionnaire.getQuestion().question,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 22.0),
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
    // }
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
          await MyPreferences.saveDateTaken(
              DateFormat("yyyy-MM-dd").format(DateTime.now()));
          sendDataNew();
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
    // answers.remove(answers.length -1);
    // if (questionnaire.getQuestion().type ==
    //     "date_picker") {
    //   checkAnswerPrev(questionnaire.getQuestion());
    // } else if (questionnaire.getQuestion().type ==
    //     "slider") {
    //     checkAnswerPrev(questionnaire.getQuestion());
    // } else if (questionnaire.getQuestion().type ==
    //     "likert") {
    //   checkAnswerPrev(questionnaire.getQuestion());
    // }
    // checkAnswerPrev(questionnaire.getQuestion());
    setState(() {
      // question.data = null;
      resetValues();
      if (questionnaire.prevQuestion() == false) {
        completed = false;
      }
    });
  }

  void nextButtonClickHandler() {
    if (questionnaire.getQuestion().data != null) {
      // checkAnswer(questionnaire.getQuestion());
      setState(() {
        resetValues();
        if (questionnaire.nextQuestion() == true) {
          completed = true;
        }
      });
    // if (questionnaire.getQuestion().type ==
    //     "date_picker") {
    //   answers.add(DateFormat("yyyy-MM-dd HH:mm:ss")
    //       .format((timePickerValue)));
    //   // questionnaire.getQuestion().data = DateFormat("yyyy-MM-dd HH:mm:ss").format(timePickerValue);
    //   checkAnswer(questionnaire.getQuestion());
    // } else if (questionnaire.getQuestion().type ==
    //     "slider") {
    //   if (realSliderValue != -1) {
    //     answers.add(realSliderValue.toInt().toString());
    //     // questionnaire.getQuestion().data = realSliderValue.toInt().toString();
    //     checkAnswer(questionnaire.getQuestion());
    //   } else {
    //     ScaffoldMessenger.of(context)
    //         .showSnackBar(SnackBar(
    //       content:
    //       Text("Move the slider to select a value"),
    //       backgroundColor:
    //       Color.fromRGBO(58, 66, 86, 1.0),
    //     ));
    //   }
    // } else if (selectedValue != null) {
    //   answers.add(selectedValue);
    //   // questionnaire.getQuestion().data = selectedValue;
    //   checkAnswer(questionnaire.getQuestion());
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
        return answerNotesWidget();
    }
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
            keyboardType: TextInputType.text,
            maxLines: 12,
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
                // DateFormat("hh:mm a").format(timePickerValue),
                DateFormat("hh:mm a").format(DateTime.parse(questionnaire.getQuestion().data)),
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
              onPressed: () => showDate(context),
              icon: Icon(Icons.access_alarm),
              label: Text(questionnaire.getQuestion().data != null ? 'Change time' : 'Select time', style: TextStyle(color: Colors.white70)),
            style: OutlinedButton.styleFrom(primary: Colors.white70, side: BorderSide(color: Colors.white70)),
          ),
      ],
    );
  }

  showDate(BuildContext context) async {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onConfirm: (date) {
        setState(() {
          questionnaire.getQuestion().data = DateFormat("yyyy-MM-dd HH:mm").format(date);
        });
      },
      currentTime: DateTime.now(),
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
                            value: double.parse(question.data ?? "0"),
                            min: 0,
                            max: 10,
                            divisions: 10,
                            onChanged: (double value) {
                              setState(() {
                                questionnaire.getQuestion().data = value.toInt().toString();
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
            groupValue: question.data,
            activeColor: Colors.white,
            onChanged: (String value) {
              setState(() {
                questionnaire.getQuestion().data = value;
              });
            },
          ),
        );
      });

  sendDataNew() async {
    setState(() {
      submitButtonState = ButtonState.loading;
    });
    await MyPreferences.saveDateTaken(
        DateFormat("yyyy-MM-dd").format(DateTime.now()));
    // saveDataLocally(answers);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");

    List values = [];
    questionnaire.getQuestions().forEach((e) => values.add(e.data));
    values.insert(0, DateTime.now().millisecondsSinceEpoch.toString());
    values.insert(1, id);
    values.add(DateTime.now().toString());

    saveDataLocally(values);

    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('daily_q');
    sheet ??= await ss.addWorksheet('daily_q');

    // List values = [];
    // questionnaire.getQuestions().forEach((e) => values.add(e.data));
    // values.insert(0, DateTime.now().millisecondsSinceEpoch.toString());
    // values.insert(1, id);
    // values.add(DateTime.now().toString());
    //
    // saveDataLocally(values);

    try {
      var result = await sheet.values.appendRow(values);
      if (result) {
        setState(() {
          submitButtonState = ButtonState.success;
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: Text("Your entry has been saved.",
                  style: TextStyle(color: Colors.white)),
            ))
            .closed
            .then((value) {
          answers.clear();
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
      ));
    }
  }

  sendData(AnimationController animationController) async {
    animationController.forward();
    saveDataLocally(answers);
    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('daily_q');
    sheet ??= await ss.addWorksheet('daily_q');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");

    List values = [];
    questionnaire.getQuestions().forEach((e) => values.add(e.data));
    values.insert(0, DateTime.now().millisecondsSinceEpoch.toString());
    values.insert(1, id);
    values.add(DateTime.now().toString());

    // values.add(DateTime.now().millisecondsSinceEpoch.toString());
    // values.add(id);
    // values.add(answers[0]);
    // values.add(answers[1]);
    // values.add(answers[2]);
    // values.add(answers[3]);
    // values.add(answers[4]);
    // values.add(answers[5]);
    // values.add(answers[6]);
    // values.add(DateTime.now().toString());
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

  void saveDataLocally(List<dynamic> values) async {
    print(values);
    var dailyQ = DailyQ(
        dateTaken: DateTime.now(),
        sleepTime: DateTime.parse(values[2]),
        wakeupTime: DateTime.parse(values[3]),
        timeToSleep: values[4],
        numberOfWakeupTimes: int.parse(values[5]),
        wellRestedness: values[6],
        qualityOfSleep: int.parse(values[7]),
        painIntensity: int.parse(values[8]),
        notes: values[9]);
    Box<DailyQ> box = Hive.box("testBox");
    await box.put(DateFormat("yyyy-MM-dd").format(DateTime.now()), dailyQ);
  }
}
