import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/monthly/PSQIQuestion.dart';
import 'package:lbp/model/monthly/PSQIQuestionnaire.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env/.env.dart';

class SleepQuestionnaire extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  SleepQuestionnaire(
      {Key key,
      this.sliderHeight = 48,
      this.max = 10,
      this.min = 0,
      this.fullWidth = false})
      : super(key: key);

  @override
  _SleepQuestionnaireState createState() => _SleepQuestionnaireState();
}

class _SleepQuestionnaireState extends State<SleepQuestionnaire> {
  PSQIQuestionnaire questionnaire = PSQIQuestionnaire();
  GSheets gSheets;
  final _formKey = GlobalKey<FormState>();

  ButtonState submitButtonState = ButtonState.idle;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
        elevation: 0,
        title: Text("Sleep Survey"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: true,
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
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: SingleChildScrollView(
                child: DotsIndicator(
                  mainAxisSize: MainAxisSize.max,
                  dotsCount: questionnaire.getQuestionnaireLength(),
                  position: questionnaire.getPSQIQuestionNumber().toDouble(),
                  decorator: DotsDecorator(
                      size: Size.square(12),
                      activeSize: Size(15, 15),
                      activeColor: Colors.white70,
                      //Theme.of(context).primaryColor,
                      color: Colors.black54 //Theme.of(context).disabledColor,
                      ),
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    questionnaire.getPSQIQuestion().question,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: Center(
                  child: this.answerWidget(questionnaire.getPSQIQuestion()),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    questionnaire.getPSQIQuestionNumber() > 0
                        ? prevButton()
                        : Container(),
                    questionnaire.lastQuestion() ? submitButton() : nextButton()
                  ],
                ),
              ),
            ),
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
          ButtonState.loading: IconedButton(color: Colors.green),
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
          await MyPreferences.saveLastMonthlySleepSurveyDate(
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
            style:
                OutlinedButton.styleFrom(side: BorderSide(color: Colors.white)),
            onPressed: () => prevButtonClickHandler(),
            child: Text(
              'Prev',
              style: TextStyle(color: Colors.white),
            )));
  }

  Widget nextButton() {
    return Padding(
        padding: EdgeInsets.all(10.0),
        child: OutlinedButton(
            style:
                OutlinedButton.styleFrom(side: BorderSide(color: Colors.white)),
            onPressed: () => nextButtonClickHandler(),
            child: Text(
              'Next',
              style: TextStyle(color: Colors.white),
            )));
  }

  void prevButtonClickHandler() {
    setState(() {
      if (questionnaire.prevQuestion() == false) {
      }
    });
  }

  void nextButtonClickHandler() {
    if (questionnaire.getPSQIQuestion().data != null) {
      setState(() {
        if (questionnaire.nextPSQIQuestion() == true) {
        }
      });
    } else
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You must answer the question to proceed"),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        duration: Duration(seconds: 1),
      ));
  }

  Widget answerWidget(PSQIQuestion question) {
    switch (question.type) {
      case "likert":
        return comboWidget(question);
      case "freeformlikert":
        return freeFormWidget(question);
      case "text":
        return textWidget(question);
      default:
        return null;
    }
  }

  Widget textWidget(PSQIQuestion question) {
    return Container(
      margin: EdgeInsets.all(12),
      child: bedTime(question),
    );
  }

  Widget bedTime(PSQIQuestion question) {
    List<String> time;
    switch (question.subtitle) {
      case 'BED TIME':
        time = [
          '00:00',
          '01:00',
          '02:00',
          '03:00',
          '04:00',
          '05:00',
          '06:00',
          '07:00',
          '08:00',
          '09:00',
          '10:00',
          '11:00',
          '12:00',
          '13:00',
          '14:00',
          '15:00',
          '16:00',
          '17:00',
          '18:00',
          '19:00',
          '20:00',
          '21:00',
          '22:00',
          '23:00'
        ];
        break;
      case 'NUMBER OF MINUTES':
        time = ["1-15", '16-30', '30-60', '60+'];
        break;
      case 'GETTING UP TIME':
        // time = [
        //   '00:00', '01:00', '02:00', '03:00', '04:00', '05:00', '06:00', '07:00',
        //   '08:00', '09:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00',
        //   '16:00', '17:00', '18:00', '19:00', '20:00', '21:00', '22:00', '23:00'];
        time = [
          '00:00',
          '01:00',
          '02:00',
          '03:00',
          '04:00',
          '05:00',
          '06:00',
          '07:00',
          '08:00',
          '09:00',
          '10:00',
          '11:00',
          '12:00+'
        ];
        break;
      case 'HOURS OF SLEEP PER NIGHT':
        // time = ["1 hour", "2 hours", "3 hours", "4 hours",
        //   "5 hours", "6 hours", "7 hours", "8 hours", "9 hours", "10 hours",
        //   "11 hours", "12 hours", "13 hours", "14 hours", "15 hours", "16 hours",
        //   "17 hours", "18 hours", "19 hours", "20 hours", "21 hours", "22 hours",
        //   "23 hours", "24 hours"];
        time = [
          "1 hour",
          "2 hours",
          "3 hours",
          "4 hours",
          "5 hours",
          "6 hours",
          "7 hours",
          "8 hours",
          "9 hours",
          "10 hours",
          "11 hours",
          "12 hours",
          "13+ hours"
        ];
        break;
      default:
    }
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        itemBuilder: (context) {
          return time
              .map((value) => PopupMenuItem(
                    value: value,
                    child: Text(value, overflow: TextOverflow.clip),
                  ))
              .toList();
        },
        onSelected: (value) {
          setState(() {
            question.data = value;
          });
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white70),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(question.data ?? "Choose one",
                  style: TextStyle(color: Colors.white)),
              Icon(Icons.arrow_drop_down, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  Widget freeFormWidget(PSQIQuestion question) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Center(
        child: Container(
          child: TextFormField(
            initialValue: question.data != null ? question.data : "",
            decoration: new InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: const OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Colors.white, width: 1.0)),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintStyle: TextStyle(color: Colors.grey),
              hintText: "Enter text here",
              helperStyle: TextStyle(color: Colors.white),
            ),
            keyboardType: TextInputType.text,
            maxLines: 12,
            onChanged: (String value) {
              setState(() {
                question.data = value;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget comboWidget(PSQIQuestion question) {
    var list = [
      question.notInPastMonth,
      question.lessThanOnceAWeek,
      question.onceOrTwiceAWeek,
      question.threeOrMoreAWeek
    ];
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: PopupMenuButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        itemBuilder: (context) {
          return list
              .map((value) => PopupMenuItem(
                    value: value,
                    child: Text(value, overflow: TextOverflow.clip),
                  ))
              .toList();
        },
        onSelected: (value) {
          setState(() {
            question.data = value;
          });
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white70),
              borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(question.data ?? "Choose one",
                  style: TextStyle(color: Colors.white)),
              Icon(Icons.arrow_drop_down, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  sendData() async {
    setState(() {
      submitButtonState = ButtonState.loading;
    });

    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('monthly_sleep_q');
    sheet ??= await ss.addWorksheet('monthly_sleep_q');

    List values = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");
    questionnaire.getPSQIQuestions().forEach((e) => values.add(e.data));
    values.insert(0, DateTime.now().toString());
    values.insert(1, id);

    try {
      var result = await sheet.values.appendRow(values);
      if (result) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: Text("Your entry has been saved.",
                  style: TextStyle(color: Colors.white)),
              duration: Duration(seconds: 1),
            ))
            .closed
            .then((value) {
          // animationController.stop();
          setState(() {
            submitButtonState = ButtonState.success;
          });
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
          // animationController.stop();
          // animationController.reset();
          setState(() {
            submitButtonState = ButtonState.fail;
          });
        });
      }
    } catch (exp) {
      // animationController.stop();
      // animationController.reset();
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
}
