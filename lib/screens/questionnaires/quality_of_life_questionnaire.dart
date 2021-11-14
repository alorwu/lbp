
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:lbp/model/monthly/PromisQuestion.dart';
import 'package:lbp/model/monthly/PromisQuestionnaire.dart';
import 'package:lbp/utils/CustomSliderThumbCircle.dart';
import 'package:lbp/utils/MyPreferences.dart';
// import 'package:progress_indicator_button/progress_button.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env/.env.dart';

class QualityOfLifeQuestionnaire extends StatefulWidget {

  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  QualityOfLifeQuestionnaire(
      {Key key,
        this.sliderHeight = 48,
        this.max = 10,
        this.min = 0,
        this.fullWidth = false})
      : super(key: key);

  @override
  _QualityOfLifeQuestionnaireState createState() =>
      _QualityOfLifeQuestionnaireState();
}

class _QualityOfLifeQuestionnaireState extends State<QualityOfLifeQuestionnaire> {
  PromisQuestionnaire questionnaire = PromisQuestionnaire();
  GSheets gSheets;
  final _formKey = GlobalKey<FormState>();
  ButtonState submitButtonState = ButtonState.idle;

  double sliderValue = 0;
  double realSliderValue = -1;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
    // answers.length = questionnaire
    //     .getPromisQuestions()
    //     .length;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
        title: Text("Quality of Life Survey"),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: buildQuestionsPage(),
                ),
              ],
            ),
          ),
      ),
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
              height: 25,
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
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    questionnaire.getPromisQuestion().question,
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
                  child: this.answerWidget(questionnaire.getPromisQuestion()),
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
          await MyPreferences.saveLastMonthlyPainSurveyDate(DateFormat("yyyy-MM-dd").format(DateTime.now()));
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
      if (questionnaire.prevQuestion() == false) {
      }
    });
  }

  void nextButtonClickHandler() {
    if (questionnaire.getPromisQuestion().data != null) {
      setState(() {
        if (questionnaire.nextPromisQuestion() == true) {
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

  Widget answerWidget(PromisQuestion question) {
    switch (question.type) {
      case "likert":
        return answerRadioWidget(question); //comboWidget(question);
      case "slider":
        return sliderWidget(question);
      default:
        return null;
    }
  }

  Widget sliderWidget(PromisQuestion question) {
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
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '${question.high}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: this.widget.sliderHeight * .3,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ]);
  }

  Widget answerRadioWidget(PromisQuestion question) => ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (BuildContext context, index) {
        var text;
        switch(index) {
          case 0: {
            text = question.one;
          }
          break;
          case 1: {
            text = question.two;
          }
          break;
          case 2: {
            text = question.three;
          }
          break;
          case 3: {
            text = question.four;
          }
          break;
          case 4: {
            text = question.five;
          }
          break;
          default: text = "";
          break;
        }
        return Theme(
          data: Theme.of(context).copyWith(
              unselectedWidgetColor: Colors.white, disabledColor: Colors.white),
          child: RadioListTile(
            title: Text(text, overflow: TextOverflow.clip, style: TextStyle(color: Colors.white)),
            value: "$text",
            groupValue: question.data,
            activeColor: Colors.white,
            onChanged: (String value) {
              setState(() {
                questionnaire.getPromisQuestion().data = value;
              });
            },
          ),
        );
      });

  sendData() async {
    // animationController.forward();
    setState(() {
      submitButtonState = ButtonState.loading;
    });

    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('monthly_qol_q');
    sheet ??= await ss.addWorksheet('monthly_qol_q');

    List values = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");
    questionnaire.getPromisQuestions().forEach((e) => values.add(e.data));
    values.insert(0, DateTime.now().toString());
    values.insert(1, id);

    try {
      var result = await sheet.values.appendRow(values);
      if (result) {
        ScaffoldMessenger
            .of(context)
            .showSnackBar(SnackBar(
          content: Text(
              "Your entry has been saved.",
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
        ScaffoldMessenger
            .of(context)
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
    } catch(exp) {
      // animationController.stop();
      // animationController.reset();
      setState(() {
        submitButtonState = ButtonState.fail;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "An error occurred. Please try again.",
            style: TextStyle(color: Colors.red)),
        duration: Duration(seconds: 1),
      ));
    }
  }
}
