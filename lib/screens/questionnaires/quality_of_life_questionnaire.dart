
import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/entity/qol/quality_of_life.dart';
import '../../data/entity/qol/quality_of_life_score.dart';
import '../../env/.env.dart';
import '../../domain/entity/questionnaires/monthly/qol_question.dart';
import '../../domain/entity/questionnaires/monthly/qol_questionnaire.dart';
import '../../domain/entity/remote/QolSurvey.dart';
import '../../utils/custom_slider_thumb_circle.dart';
import '../../utils/preferences.dart';


class QualityOfLifeQuestionnaire extends StatefulWidget {

  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  QualityOfLifeQuestionnaire(
      {Key? key,
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
  QoLQuestionnaire questionnaire = QoLQuestionnaire();
  late GSheets gSheets;
  final _formKey = GlobalKey<FormState>();
  ButtonState submitButtonState = ButtonState.idle;

  double sliderValue = 0;
  double realSliderValue = -1;

  String? appId;

  @override
  initState() {
    super.initState();
    gSheets = GSheets(environment['credentials']);
    getAppId();
  }

  void getAppId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      appId = prefs.getString("app_id");
    });
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
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Center(
                  child: Text(
                    questionnaire.getPromisQuestion().question!,
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
          await Preferences.saveLastMonthlyPainSurveyDate(DateFormat("yyyy-MM-dd").format(DateTime.now()));
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

  Widget? answerWidget(QoLQuestion question) {
    switch (question.type) {
      case "likert":
        return answerRadioWidget(question); //comboWidget(question);
      case "slider":
        return sliderWidget(question);
      default:
        return null;
    }
  }

  Widget sliderWidget(QoLQuestion question) {
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

  Widget answerRadioWidget(QoLQuestion question) => ListView.builder(
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
            onChanged: (String? value) {
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

    saveLocally();

    final ss = await gSheets.spreadsheet(environment['spreadsheetId'] as String);
    var sheet = ss.worksheetByTitle('monthly_qol_survey');
    sheet ??= await ss.addWorksheet('monthly_qol_survey');

    List values = [];

    questionnaire.getPromisQuestions().forEach((e) => values.add(e.data));
    values.insert(0, DateTime.now().toString());
    values.insert(1, appId);

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
          setState(() {
            submitButtonState = ButtonState.fail;
          });
        });
      }
    } catch(exp) {
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

  void saveLocally() async {
    List<String?> values = [];
    questionnaire.getPromisQuestions().forEach((e) => values.add(e.data));

    var qol = QoL(
      generalHealth: values[0],
      qualityOfLife: values[1],
      physicalHealth: values[2],
      mentalHealth: values[3],
      socialSatisfaction: values[4],
      carryOutSocialActivities: values[5],
      carryOutPhysicalActivities: values[6],
      emotionalProblems: values[7],
      fatigue: values[8],
      pain: values[9],
      dateTaken: DateTime.now()
    );

    calculateQoLScore(qol);

    Box<QoL> box;
    var isBoxOpened = Hive.isBoxOpen("qolBox");
    if (isBoxOpened) {
      box = Hive.box("qolBox");
    } else {
      box = await Hive.openBox("qolBox");
    }
    await box.put(DateFormat("yyyy-MM").format(DateTime.now()), qol);
  }

  void calculateQoLScore(QoL qol) async {
    int global03 = poorToExcellentResponse(qol.physicalHealth!);
    int global07 = notAtAllToCompletely(qol.carryOutPhysicalActivities!);
    int global09 = severeToNone(qol.fatigue!);
    int global10 = calculatePain(qol.pain!);

    int global02 = poorToExcellentResponse(qol.qualityOfLife!);
    int global04 = poorToExcellentResponse(qol.mentalHealth!);
    int global05 = poorToExcellentResponse(qol.socialSatisfaction!);
    int global08 = alwaysToNever(qol.emotionalProblems!);

    int globalPhysicalHealth = global03 + global07 + global09 + global10;
    int globalMentalHealth = global02 + global04 + global05 + global08;

    var qolSurvey = QolSurvey(
      global02: global02,
      global03: global03,
      global04: global04,
      global05: global05,
      global07: global07,
      global08: global08,
      global09: global09,
      global10: global10,
      globalPhysicalHealth: globalPhysicalHealth,
      globalMentalHealth: globalMentalHealth,
      dateTaken: DateTime.now(),
      userId: appId
    );

    saveQolSurveyToRemoteDb(qolSurvey);

    var qolScore = QoLScore(
      physicalHealth: globalPhysicalHealth,
      mentalHealth: globalMentalHealth,
      dateTaken: DateTime.now(),
    );

    Box<QoLScore> box;
    var isBoxOpened = Hive.isBoxOpen("qolScoreBox");
    if (isBoxOpened) {
      box = Hive.box("qolScoreBox");
    } else {
      box = await Hive.openBox("qolScoreBox");
    }
    await box.put(DateFormat("yyyy-MM").format(DateTime.now()), qolScore);
  }

  int poorToExcellentResponse(String str) {
    switch (str.trim()) {
      case "Poor":
        return 1;
      case "Fair":
        return 2;
      case "Good":
        return 3;
      case "Very good":
        return 4;
      default:
        return 5;
    }
  }

  int notAtAllToCompletely(String str) {
    switch (str.trim()) {
      case "Not at all":
        return 1;
      case "A little":
        return 2;
      case "Moderately":
        return 3;
      case "Mostly":
        return 4;
      default:
        return 5;
    }
  }

  int alwaysToNever(String str) {
    switch (str.trim()) {
      case "Always":
        return 1;
      case "Often":
        return 2;
      case "Sometimes":
        return 3;
      case "Rarely":
        return 4;
      default:
        return 5;
    }
  }

  int severeToNone(String str) {
    switch (str.trim()) {
      case "Very severe":
        return 1;
      case "Severe":
        return 2;
      case "Moderate":
        return 3;
      case "Mild":
        return 4;
      default:
        return 5;
    }
  }

  int calculatePain(String str) {
    switch(str.trim()) {
      case "0": return 5;
      case "1": return 4;
      case "2": return 4;
      case "3": return 4;
      case "4": return 3;
      case "5": return 3;
      case "6": return 3;
      case "7": return 2;
      case "8": return 2;
      case "9": return 2;
      default: return 1;
    }
  }

  Future<http.Response> saveQolSurveyToRemoteDb(QolSurvey survey) async {
    return http.post(
      Uri.parse('${environment['remote_url']}/api/surveys/qol'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(survey.toJson()),
    );
  }
}
