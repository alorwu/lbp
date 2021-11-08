
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
import 'package:progress_indicator_button/progress_button.dart';
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
        backgroundColor: Color(0xff000000),
        elevation: 0,
        // systemOverlayStyle: SystemUiOverlayStyle.dark,
        brightness: Brightness.dark,
        title: Text("Quality of Life Survey"),
      ),
      backgroundColor: Color(0xff000000),
      body: Builder(
        builder: (context) => Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit: FlexFit.loose,
                  child: buildQuestionsPage(),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: ProgressButton(
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.blue,
                    onPressed: (AnimationController controller) async {
                      if (_formKey.currentState.validate()) {
                        await MyPreferences.saveLastMonthlyPainSurveyDate(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                        sendData(controller);
                      }
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildQuestionsPage() {
    var entries = questionnaire.getPromisQuestions();
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(10.0),
      itemCount: entries.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          elevation: 5,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 5),
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
                          activeTrackColor: Colors.blue.withOpacity(1),
                          // inactiveTrackColor: Colors.black,
                          trackHeight: 4.0,
                          thumbShape: CustomSliderThumbCircle(
                            thumbRadius: this.widget.sliderHeight * .4,
                            min: this.widget.min,
                            max: this.widget.max,
                          ),
                          // overlayColor: Colors.black,
                          activeTickMarkColor: Colors.blue,
                          inactiveTickMarkColor: Colors.blue,
                        ),
                        child: Slider(
                            value: sliderValue,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            onChanged: (double value) {
                              // print("Value: $value");
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
    var list = [question.one, question.two, question.three, question.four, question.five];
    return Column(
      children: [
        DropdownButtonFormField(
          decoration: InputDecoration(
            hintText: "Choose one",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          iconSize: 24,
          elevation: 16,
          onChanged: (String newValue) {
            setState(() {
              question.data = newValue;
              // answers[index] = newValue;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, overflow: TextOverflow.clip),
            );
          }).toList(),
          validator: (value) {
            if (null == value) {
              return 'Please select one';
            }
            return null;
          },
          value: question.data,
        ),
        SizedBox(height: 5.0),
      ],
    );
  }

  sendData(AnimationController animationController) async {
    animationController.forward();

    final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    var sheet = ss.worksheetByTitle('monthly_qol_q');
    sheet ??= await ss.addWorksheet('monthly_qol_q');

    List values = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id = prefs.getString("app_id");
    questionnaire.getPromisQuestions().forEach((e) => values.add(e.data));
    values.add(DateTime.now().toString());
    values.add(id);

    try {
      var result = await sheet.values.appendRow(values);
      if (result) {
        ScaffoldMessenger
            .of(context)
            .showSnackBar(SnackBar(
          content: Text(
              "Your entry has been saved.",
              style: TextStyle(color: Colors.white)),
        ))
            .closed
            .then((value) {
          animationController.stop();
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        });
      } else {
        ScaffoldMessenger
            .of(context)
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
    } catch(exp) {
      animationController.stop();
      animationController.reset();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            "An error occurred. Please try again.",
            style: TextStyle(color: Colors.red)),
      ));
    }
  }
}
