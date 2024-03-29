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

import '../../data/entity/sleep/psqi.dart';
import '../../data/entity/sleep/sleep_component_score.dart';
import '../../env/.env.dart';
import '../../domain/entity/questionnaires/monthly/psqi_question.dart';
import '../../domain/entity/questionnaires/monthly/psqi_questionnaire.dart';
import '../../domain/entity/remote/PsqiSurvey.dart';
import '../../utils/preferences.dart';

class SleepQuestionnaire extends StatefulWidget {
  final double sliderHeight;
  final int min;
  final int max;
  final fullWidth;

  SleepQuestionnaire(
      {Key? key,
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
  late GSheets gSheets;

  ButtonState submitButtonState = ButtonState.idle;
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
                    color: Colors.black54,
                  ),
                ),
                scrollDirection: Axis.horizontal,
              ),
            ),
            Center(
              child: Text(
                "${questionnaire.getPSQIQuestionNumber() + 1} / ${questionnaire.getQuestionnaireLength().toString()}",
                style: TextStyle(color: Colors.white70, fontSize: 16),
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
                    questionnaire.getPSQIQuestion().question!,
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

                  child: questionnaire.lastQuestion()
                      ? Container()
                      : this.answerWidget(questionnaire.getPSQIQuestion()),
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
          await Preferences.saveLastMonthlySleepSurveyDate(
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
      if (questionnaire.prevQuestion() == false) {}
    });
  }

  void nextButtonClickHandler() {
    if (questionnaire.getPSQIQuestion().data != null) {
      setState(() {
        if (questionnaire.nextPSQIQuestion() == true) {}
      });
    } else if (questionnaire.getPSQIQuestion().number == "5j-i") {
      setState(() {
        if (questionnaire.nextPSQIQuestion() == true) {}
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("You must answer the question to proceed"),
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        duration: Duration(seconds: 1),
      ));
    }
  }

  Widget? answerWidget(PSQIQuestion question) {
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
    late List<String> time;
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
        time = ["≤15 minutes", '16-30 minutes', '31-60 minutes', '>60 minutes'];
        break;
      case 'GETTING UP TIME':
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
      case 'HOURS OF SLEEP PER NIGHT':
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
          "13 hours",
          "14 hours",
          "15 hours",
          "16 hours",
          "17 hours",
          "18 hours",
          "19 hours",
          "20 hours",
          "21 hours",
          "22 hours",
          "23 hours",
          "24 hours"
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
        onSelected: (dynamic value) {
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
                    child: Text(value!, overflow: TextOverflow.clip),
                  ))
              .toList();
        },
        onSelected: (dynamic value) {
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

    saveLocally();

    final ss = await gSheets.spreadsheet(environment['spreadsheetId'] as String);
    var sheet = ss.worksheetByTitle('monthly_sleep_survey');
    sheet ??= await ss.addWorksheet('monthly_sleep_survey');

    List values = [];

    questionnaire.getPSQIQuestions().forEach((e) => values.add(e.data));
    values.insert(0, DateTime.now().toString());
    values.insert(1, appId);

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

  void saveLocally() async {
    List<String?> values = [];
    questionnaire.getPSQIQuestions().forEach((e) => values.add(e.data));
    var psqi = PSQI(
      timeToBed: values[0],
      timeToSleep: values[1],
      wakeUpTime: values[2],
      hoursSlept: values[3],
      sleepIn30Mins: values[4],
      wakeUpNightOrMorning: values[5],
      bathroomUse: values[6],
      cannotBreatheComfortably: values[7],
      coughOrSnoreLoudly: values[8],
      feelCold: values[9],
      feelHot: values[10],
      badDreams: values[11],
      havePain: values[12],
      otherReasonsUnableToSleep: values[13],
      troubleSleepingDueToOtherReason: values[14],
      sleepQuality: values[15],
      medicineToSleep: values[16],
      troubleStayingAwake: values[17],
      enthusiasm: values[18],
      dateTaken: DateTime.now(),
    );

    calculateSleepComponentScore(psqi);

    Box<PSQI> box;
    var isBoxOpened = Hive.isBoxOpen("psqiBox");
    if (isBoxOpened) {
      box = Hive.box("psqiBox");
    } else {
      box = await Hive.openBox("psqiBox");
    }
    await box.put(DateFormat("yyyy-MM").format(DateTime.now()), psqi);
  }

  void calculateSleepComponentScore(PSQI psqi) async {
    int dayTimeDysfunctionComponent = calculateDayTimeDysfunction(psqi);
    int sleepMedicationComponent = weekMonthDefault(psqi.medicineToSleep!);
    int sleepDisturbanceComponent = sleepDisturbance(psqi);
    int sleepEfficiencyComponent = sleepEfficiency(psqi);
    int sleepDurationComponent = sleepDuration(psqi.hoursSlept!);
    int sleepLatencyComponent = sleepLatency(psqi);
    int sleepQualityComponent = sleepQuality(psqi.sleepQuality!);

    int pSQIScore = dayTimeDysfunctionComponent +
        sleepMedicationComponent +
        sleepDisturbanceComponent +
        sleepEfficiencyComponent +
        sleepDurationComponent +
        sleepLatencyComponent +
        sleepQualityComponent;

    savePsqiSurveyToRemoteDb(
      PsqiSurvey(
        sleepQualityComponent: sleepQualityComponent,
        sleepLatencyComponent: sleepLatencyComponent,
        sleepDurationComponent: sleepDurationComponent,
        sleepEfficiencyComponent: sleepEfficiencyComponent,
        sleepDisturbanceComponent: sleepDisturbanceComponent,
        sleepMedicationComponent: sleepMedicationComponent,
        dayTimeDysfunctionComponent: dayTimeDysfunctionComponent,
        psqiScore: pSQIScore,
        dateTaken: DateTime.now(),
        userId: appId
      )
    );
    var sleepComponentScore = SleepComponentScores(
        sleepQuality: sleepQualityComponent,
        sleepLatency: sleepLatencyComponent,
        sleepDuration: sleepDurationComponent,
        sleepEfficiency: sleepEfficiencyComponent,
        sleepDisturbance: sleepDisturbanceComponent,
        sleepMedication: sleepMedicationComponent,
        dayTimeDysfunction: dayTimeDysfunctionComponent,
        pSQIScore: pSQIScore,
        dateTaken: DateTime.now());

    Box<SleepComponentScores> box;
    var isBoxOpened = Hive.isBoxOpen("psqiScore");
    if (isBoxOpened) {
      box = Hive.box("psqiScore");
    } else {
      box = await Hive.openBox("psqiScore");
    }
    await box.put(
        DateFormat("yyyy-MM").format(DateTime.now()), sleepComponentScore);
  }

  int calculateDayTimeDysfunction(PSQI pSQI) {
    int q8 = -1;
    switch (pSQI.troubleStayingAwake!.trim()) {
      case "Never":
        q8 = 0;
        break;
      case "Once or twice":
        q8 = 1;
        break;
      case "Once or twice each week":
        q8 = 2;
        break;
      default:
        q8 = 3;
    }

    int q9 = -1;
    switch (pSQI.troubleStayingAwake!.trim()) {
      case "No problem at all":
        q8 = 0;
        break;
      case "Only a very slight problem":
        q8 = 1;
        break;
      case "Somewhat of a problem":
        q8 = 2;
        break;
      default:
        q8 = 3;
    }

    int sum = q8 + q9;
    if (sum == 0)
      return 0;
    else if (sum <= 2)
      return 1;
    else if (sum <= 4)
      return 2;
    else
      return 3;
  }

  int weekMonthDefault(String str) {
    switch (str.trim()) {
      case "Not during the past month":
        return 0;
      case "Less than once a week":
        return 1;
      case "Once or twice a week":
        return 2;
      default:
        return 3;
    }
  }

  int sleepDisturbance(PSQI pSQI) {
    int q5b = weekMonthDefault(pSQI.wakeUpNightOrMorning!);
    int q5c = weekMonthDefault(pSQI.bathroomUse!);
    int q5d = weekMonthDefault(pSQI.cannotBreatheComfortably!);
    int q5e = weekMonthDefault(pSQI.coughOrSnoreLoudly!);
    int q5f = weekMonthDefault(pSQI.feelCold!);
    int q5g = weekMonthDefault(pSQI.feelHot!);
    int q5h = weekMonthDefault(pSQI.badDreams!);
    int q5i = weekMonthDefault(pSQI.havePain!);
    int q5j = weekMonthDefault(pSQI.troubleSleepingDueToOtherReason!);
    int sum = q5b + q5c + q5d + q5e + q5f + q5g + q5h + q5i + q5j;

    if (sum == 0)
      return 0;
    else if (sum <= 9)
      return 1;
    else if (sum <= 18)
      return 2;
    else
      return 3;
  }

  int sleepEfficiency(PSQI pSQI) {
    int hoursSlept = int.parse(pSQI.hoursSlept!.substring(0, 2).trim());
    int getUpTime = int.parse(pSQI.wakeUpTime!.substring(0, 2).trim());
    int bedTime = int.parse(pSQI.timeToBed!.substring(0, 2).trim());
    int hoursInBed;
    if ((bedTime - getUpTime) > 0) {
      hoursInBed = 24 - (bedTime - getUpTime);
    } else {
      hoursInBed = getUpTime - bedTime;
    }
    var habitualSleepEfficiency = ((hoursSlept / hoursInBed) * 100).round();
    if (habitualSleepEfficiency > 85)
      return 0;
    else if (habitualSleepEfficiency >= 75)
      return 1;
    else if (habitualSleepEfficiency >= 65)
      return 2;
    else
      return 3;
  }

  int sleepDuration(String hoursSlept) {
    int hours = int.parse(hoursSlept.substring(0, 2).trim());
    if (hours > 7)
      return 0;
    else if (hours >= 6)
      return 1;
    else if (hours >= 5)
      return 2;
    else
      return 3;
  }

  int sleepLatency(PSQI psqi) {
    int q5a = weekMonthDefault(psqi.sleepIn30Mins!);
    int q2 = 0;
    switch (psqi.timeToSleep!.trim()) {
      case "≤15 minutes":
        q2 = 0;
        break;
      case "16-30 minutes":
        q2 = 1;
        break;
      case "31-60 minutes":
        q2 = 2;
        break;
      default:
        q2 = 3;
    }
    int sum = q5a + q2;
    if (sum == 0)
      return 0;
    else if (sum <= 2)
      return 1;
    else if (sum <= 4)
      return 2;
    else
      return 3;
  }

  int sleepQuality(String sleepQuality) {
    switch (sleepQuality.trim()) {
      case "Very good":
        return 0;
      case "Fairly good":
        return 1;
      case "Fairly bad":
        return 2;
      default:
        return 3;
    }
  }

  Future<http.Response> savePsqiSurveyToRemoteDb(PsqiSurvey survey) async {
    return http.post(
      Uri.parse('${environment['remote_url']}/api/surveys/psqi'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(survey.toJson()),
    );
  }
}
