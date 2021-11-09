
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:lbp/screens/settings/consent.dart';
import 'package:lbp/screens/settings/privacy_policy.dart';
import 'package:lbp/utils/CustomSliderThumbCircle.dart';
import 'package:lbp/utils/MyPreferences.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:lbp/env/.env.dart';

class OnBoarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new OnBoardingState();
}

class OnBoardingState extends State<OnBoarding> {
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  String appId;

  int clinicalDiagnosisRadio = -1;
  String gender;
  String employment;
  String exercise;
  String academic;
  String lbpTreatment;
  String surgicalOp;
  String previewBackPain;
  String sciatica;
  String painIntensity;
  double exerciseRadio = -1;

  var sliderHeight = 48.0;
  var max = 10;
  var min = 0;
  var fullWidth = false;

  var consentCheck = false;

  double sliderValue = 0;
  // double realSliderValue = -1;

  var credentials = r'''{
    "type": "service_account",
    "project_id": "lbp-study",
    "private_key_id": "4f685b0fee76e22cf61eb0d5c20e643197d680d3",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDZul05q+OSGGxH\nNLJmxygV2Sxj4crN9A+q+ACb8TNGTXyYGDfoO5I3VUGnVJxdhDD5tKFlfeesJmm0\nbE0F+Gr44nRUsaJkLKtKTVjH7D9NsICpznnOW+q5fGKcBDX/AQaK3IUnMzoXa5jY\n4lMMV7Nql9R+sjjDvVaJdKc7sNXez7GXcNy5GnHF6BcCtF6lXHpGkfd9MncOuYBH\np5s4QmZ6oAWsJkXDd0EGXFBW4UOexdGxAq8qwTbRFtyn7HX/RCgvkHncKvBbiTW+\ns8vtTjXDj3WF4vTh//z2UBXmnpZYR0bslJAaLKFtq7kdD9onSSdTTZRr/Uq7UBie\nJ8crU54rAgMBAAECggEAEhkrY1OGINXGN7ZfV1XEtOmO3A/1HguPOy9O9ad7aKOg\n8LpKo2jtmDXjtYy99rQPUiJmrBtmz5OIg9vgxyyaz8IbLhMZ+ZO7pVB/9Gu56LOm\n7kvgf3vP1h1LIRw51M75WT+daIsZ5Wp8k8K0aTk9C7uVM/bilbq+X8ICSLREAuI/\nkv0bPwoORIU8veQsIZIlQBaStYCbjgqswtW8j7kYWIPqIAdBDPK9R8Dfs7lzaxeQ\noVltsQXb8hm472q3PIKm0IcSgUBG8CUBKs/9y7rLAINLeSNh5fUj+uy4Xyehg8p5\ncGusBygkvrOn5RVaMLcgjq+56+6EsAct5r3qakuCWQKBgQDvWr8U8a0sLKsfEjIS\nj6ijpbaEWByJYPsiz7VKenczHmmpg0fUvLF8uMPyo17Mjrzunh9cv/7+PPSbQ0nY\nEO6Fz03J8qa3A+NP4hqkBhYNZ7E3cSZmSreCFoH+UQN3m+E5R/NoDSwVWh5UMdlZ\n8SNza6o+1akiLb7cptbjFQCrRQKBgQDo3plVTFbLhB1gjfw16pTk8zpWXb5s73m3\n27xFXP1OolwssyZ6Oj1CHEbsD4eUoHWcDmvBVGVJa2glvT+SpGObbaig0/kJ6DMw\norIonwbX/LW4SdRNXWrxsyUTwKaqGJ1CP5cYOOqfNapwXazcwJ6aFVU0PRGyi2lz\nU7pJuOgCrwKBgQCMloKx7JpI3hvM7kUW/eaR6J3h8lcgoiQgeFwF2RT2o6BwfrnM\nTOD7XxNJC4h9IkH67kmBkwxVjLwoDkfrb1aKpg8M1UfzK4dyvl3jheeiDAvdgsqJ\nPs22zT2hgThGIvsRSB/COCpyiDJURctitu6Ztt2SdrEXcEMxG5YQX5+6+QKBgHwK\nXkimQjFj7TYKS4b4rlkKClAI3S8vnHlIDZAxCSjCqTCSOPOwZAL8BvclCoYrtpnq\nwJEZgF5MXQyFMwDMmdYn4kPQxX32dpX4g8fJdZ7FGJLSmMig8x9N2nkcDGrcc5/f\nOX+IiclGj8QM0dBAtfrDVEBgKzYcto3c0oUEfmk3AoGACcPgZLTeuF1GhGYzCJQV\n5WeYvCo/sYy87CHFUe+yn88PgpT9OJx4//9OIKRH7NUWqUmlyidxhjEHKWoLBuna\n6k+M9jgMySLNyRARcWIszoM94/uZcVKJohumpIZrqN51hbgSZ3w6t0zIFm02zNtH\n5m1JVK4/MNU5tmsXooHQotE=\n-----END PRIVATE KEY-----\n",
    "client_email": "lpb-service-account@lbp-study.iam.gserviceaccount.com",
    "client_id": "100165315429074862049",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/lpb-service-account%40lbp-study.iam.gserviceaccount.com"
  }''';


  GSheets gSheets;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getId();
    // gSheets = GSheets(environment['credentials']);
    gSheets = GSheets(credentials);
  }

  Widget sliderWidget() {
    double paddingFactor = .2;
    if (fullWidth) paddingFactor = .3;

    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity, //this.widget.fullWidth ? double.infinity : (this.widget.sliderHeight) * 5.5,
            height: (sliderHeight),
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.all(
                Radius.circular((sliderHeight * .3)),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.all(1.0),
              child: Row(
                children: <Widget>[
                  Text(
                    '$min',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: sliderHeight * .3,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    width: sliderHeight * .1,
                  ),
                  Expanded(
                    child: Center(
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: Colors.blue.withOpacity(1),
                          // inactiveTrackColor: Colors.black,
                          trackHeight: 4.0,
                          thumbShape: CustomSliderThumbCircle(
                            thumbRadius: sliderHeight * .4,
                            min: min,
                            max: max,
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
                                sliderValue = value;
                                exerciseRadio = value;
                              });
                            }),
                      ),
                    ),
                  ),
                  Text(
                    '$max',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: sliderHeight * .3,
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
                  'Not at all active',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: sliderHeight * .3,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Extremely active',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: sliderHeight * .3,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ]);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome - Sleep Better'),
        backgroundColor: Color.fromRGBO(64, 75, 96, 0.9),
      ),
      body: Builder(
        builder: (context) => Padding(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "Hello and welcome! Tell us a little about yourself.",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(),
                  SizedBox(height: 20),
                  Text("How old are you (in years)?", style: TextStyle(color: Colors.blue)),
                  TextFormField(
                    focusNode: new FocusNode(),
                    decoration: InputDecoration(
                      hintText: "Enter age here",
                      hintStyle: TextStyle(color: Colors.grey),
                      // labelText: 'How old are you (in years)?',
                      // border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    controller: ageController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter an age';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text("What is your gender?", style: TextStyle(color: Colors.blue)),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Choose one",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    items: ["Male", "Female", "Other", "Do not disclose"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, overflow: TextOverflow.clip),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        gender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select a gender';
                      }
                      return null;
                    },
                    value: gender,
                  ),
                  SizedBox(height: 20.0),
                  Text("What is your employment status?", style: TextStyle(color: Colors.blue)),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Choose one",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    items: ["Full-time work", "Part-time work", "Retired",
                      "Unemployed", "I do not wish to disclose"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        employment = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select one';
                      }
                      return null;
                    },
                    value: employment,
                  ),
                  SizedBox(height: 20.0),
                  Text("What is your highest academic qualification?",
                      style: TextStyle(color: Colors.blue)),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Choose one",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    items: ["Master's degree or higher", "Bachelor's degree",
                      "High school", "International master's degree",
                      "Vocational degree", "Dual qualification",
                      "Primary school", "I do not wish to disclose"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        academic = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select one';
                      }
                      return null;
                    },
                    value: academic,
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          // "How often do you exercise or strain yourself physically "
                          //     "in your free time?",
                          "In your own words, how active is your lifestyle in general?",
                          style: TextStyle(color: Colors.blue),
                        ),
                        SizedBox(height: 5.0),
                          sliderWidget(),
                        //   RadioListTile(
                        //     title: Text("I mostly read, watch tv and perform tasks that do not"
                        //         " require me to move around much and do not strain me "
                        //         "physically."),
                        //     value: 0,
                        //     groupValue: exerciseRadio,
                        //     onChanged: (int value) {
                        //       setState(() {
                        //         exerciseRadio = value;
                        //       });
                        //     },
                        // ),
                        //   SizedBox(height: 5.0),
                        //   RadioListTile(
                        //     title: Text("I walk, cycle or move in some ways for at least 4 hours "
                        //         "each week. This could include walking, fishing, "
                        //         "hunting, gardening, etc., but excluding travelling to "
                        //         "work."),
                        //     value: 1,
                        //     groupValue: exerciseRadio,
                        //     onChanged: (int value) {
                        //       setState(() {
                        //         exerciseRadio = value;
                        //       });
                        //     },
                        // ),
                        // SizedBox(height: 5.0),
                        //   RadioListTile(
                        //     title: Text("I exercise on my free time for at least two hours each "
                        //         "week. This could include running, jogging, skiing, "
                        //         "swimming, team sports, going to the gym, or heavy "
                        //         "gardening work."),
                        //     value: 2,
                        //     groupValue: exerciseRadio,
                        //     onChanged: (int value) {
                        //       setState(() {
                        //         exerciseRadio = value;
                        //       });
                        //     },
                        // ),
                        // SizedBox(height: 5.0),
                        //   RadioListTile(
                        //     title: Text("I practise competitively multiple times per week in "
                        //         "running, orienteering, skiing, swimming, team sports, "
                        //         "or other strenuous activities."),
                        //     value: 3,
                        //     groupValue: exerciseRadio,
                        //     onChanged: (int value) {
                        //       setState(() {
                        //         exerciseRadio = value;
                        //       });
                        //     },
                        // ),
                        //   RadioListTile(
                        //     title: Text("Do not disclose"),
                        //     value: 4,
                        //     groupValue: exerciseRadio,
                        //     onChanged: (int value) {
                        //       setState(() {
                        //         exerciseRadio = value;
                        //       });
                        //     },
                        //   ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text("Have you previously experienced lower back pain?", style: TextStyle(color: Colors.blue)),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Choose one",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    items: ["No", "Yes, it is chronic or it renews easily",
                      "Yes, but it is not chronic or it does not renew easily"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, overflow: TextOverflow.clip),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        previewBackPain = value;
                      });
                    },
                    isExpanded: true,
                    itemHeight: 50.0,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select one';
                      }
                      return null;
                    },
                    value: previewBackPain,
                  ),
                  SizedBox(height: 20.0),
                  Text("Have you had or do you have sciatica?", style: TextStyle(color: Colors.blue)),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Choose one",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    items: ["No", "Yes, it is chronic or it renews easily",
                      "Yes, but it is not chronic or it does not renew easily"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        sciatica = value;
                      });
                    },
                    isExpanded: true,
                    itemHeight: 50.0,
                    validator: (value) {
                      if (value == null) {
                        return 'Please select one';
                      }
                      return null;
                    },
                    value: sciatica,
                  ),
                  SizedBox(height: 20.0),
                  Text("Are you experiencing back pain right now? How intense is it?", style: TextStyle(color: Colors.blue)),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Choose one",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    items: ["0 - no recognizable pain", "1", "2", "3", "4", "5",
                      "6", "7", "8", "9", "10 - unbearable pain"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        painIntensity = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select one';
                      }
                      return null;
                    },
                    value: painIntensity,
                  ),
                  SizedBox(height: 20.0),
                  Text("Has your back ever been surgically operated?", style: TextStyle(color: Colors.blue)),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      hintText: "Choose one",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    items: ["No", "Yes"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String value) {
                      setState(() {
                        surgicalOp = value;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Please select one';
                      }
                      return null;
                    },
                    value: surgicalOp,
                  ),
                  SizedBox(height: 20.0),
                  Text("How long have you had Low Back Pain? (in years)",
                      style: TextStyle(color: Colors.blue)),
                  TextFormField(
                    decoration: InputDecoration(
                      // labelText: 'How long have you had Low Back Pain? (months)',
                      // border: OutlineInputBorder(),
                      hintText: "e.g. 10",
                      hintStyle: TextStyle(color: Colors.grey)
                    ),
                    focusNode: new FocusNode(),
                    keyboardType: TextInputType.number,
                    controller: durationController,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Tell us how long you've had low back pain";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    // padding: EdgeInsets.fr(10.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Have you been clinically diagnosed with Low Back Pain by a doctor?',
                          style: TextStyle(color: Colors.blue),
                        ),
                          RadioListTile(
                            title: Text('No'),
                            value: 0,
                            groupValue: clinicalDiagnosisRadio,
                            onChanged: (int value) {
                              setState(() {
                                clinicalDiagnosisRadio = value;
                              });
                            },
                        ),
                          RadioListTile(
                            title: Text('Yes'),
                            value: 1,
                            groupValue: clinicalDiagnosisRadio,
                            onChanged: (int value) {
                              setState(() {
                                clinicalDiagnosisRadio = value;
                              });
                            },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Text("In your own words please describe how to treat and maintain your lower back in your everyday life?",
                      style: TextStyle(color: Colors.blue)),
                  SizedBox(height: 10.0),
                  TextFormField(
                    decoration: new InputDecoration(
                      // filled: true,
                      enabledBorder: const OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey, width: 1.0)
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      hintStyle: TextStyle(color: Colors.grey),
                      hintText: "Enter text here",
                      helperText: "No answer is wrong. Write freely.",
                      helperStyle: TextStyle(color: Colors.grey),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLines: 6,
                    onChanged: (String value) {
                      setState(() {
                        lbpTreatment = value;
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return "Tell us how you treat or maintain your low back pain";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: <Widget>[
                        Checkbox(
                          value: this.consentCheck,
                          onChanged: (bool value) {
                            setState(() {
                              this.consentCheck = value;
                            });
                          },
                        ),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(color: Colors.grey),
                              children: <TextSpan>[
                                TextSpan(text: "I have read and agree to the terms and conditions as outlined in the "),
                                TextSpan(
                                  text: "user consent agreement ",
                                  style: TextStyle(color: Colors.blue),
                                  recognizer: TapGestureRecognizer()..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ConsentScreen()));
                                  }
                                ),
                                TextSpan(text: "and "),
                                TextSpan(
                                    text: "privacy policy.",
                                    style: TextStyle(color: Colors.blue),
                                    recognizer: TapGestureRecognizer()..onTap = () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyDisclaimerScreen()));
                                    }
                                )
                              ]
                            )
                          )
                        ),
                          ],
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ProgressButton(
                      borderRadius: BorderRadius.circular(8.0),
                      color: this.consentCheck ? Colors.blue : Colors.grey,
                      child: Text('Get started', style: TextStyle(color: Colors.white)),
                      onPressed: (AnimationController controller) async {
                        if (this.consentCheck) {
                          validateAndSend(controller);
                        }
                        // if (_formKey.currentState.validate()) {
                        //   // await MyPreferences.updateOnboarding(false);
                        //   // await MyPreferences.saveMonthlyDateTaken(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                        //   // await MyPreferences.saveNotificationTime("07:00");
                        //
                        //   if (exerciseRadio < 0) {
                        //     showSnackBar('Please select an answer on how active is your lifestyle', context);
                        //   } else if (clinicalDiagnosisRadio < 0) {
                        //     showSnackBar('Please select an answer on whether you have been clinically diagnosed of back pain', context);
                        //   } else {
                        //     sendData(
                        //         context,
                        //         controller
                        //     );
                        //   }
                        // }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showConsentDialog(BuildContext context, AnimationController controller) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                validateAndSend(controller);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  validateAndSend(AnimationController controller) {
    if (_formKey.currentState.validate()) {
      // await MyPreferences.updateOnboarding(false);
      // await MyPreferences.saveMonthlyDateTaken(DateFormat("yyyy-MM-dd").format(DateTime.now()));
      // await MyPreferences.saveNotificationTime("07:00");

      if (exerciseRadio < 0) {
        showSnackBar('Please select an answer on how active is your lifestyle', context);
      } else if (clinicalDiagnosisRadio < 0) {
        showSnackBar('Please select an answer on whether you have been clinically diagnosed of back pain', context);
      } else {
        sendData(
            context,
            controller
        );
      }
    }
  }
  showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          message,
          style: TextStyle(color: Colors.white)),
    ));
  }

  Future<void> sendData(BuildContext context, AnimationController animationController) async {
    animationController.forward();

    // final ss = await gSheets.spreadsheet(environment['spreadsheetId']);
    final ss = await gSheets.spreadsheet(
        '1b5AmPGPqgUASo_BrNBUnWVn0e2BYOc7t8VSqllOc6MQ');
    var sheet = ss.worksheetByTitle('user_info');
    sheet ??= await ss.addWorksheet('user_info');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // var id = prefs.getString("app_id");
    prefs.setString('segment', '07:00');

    List values = [];
    values.add(appId);
    values.add(ageController.value.text);
    values.add(gender);
    values.add(employment);
    values.add(academic);
    values.add(exerciseRadio);
    values.add(previewBackPain);
    values.add(sciatica);
    values.add(painIntensity);
    values.add(surgicalOp);
    values.add(durationController.value.text);
    values.add(clinicalDiagnosisRadio);
    values.add(lbpTreatment);
    values.add(DateTime.now().toString());
    print(values);
    try {
      var result = await sheet.values.appendRow(values);
      if (result) {
        await MyPreferences.updateOnboarding(false);
        // await MyPreferences.saveMonthlyDateTaken(
        //     DateFormat("yyyy-MM-dd").format(DateTime.now()));
        await MyPreferences.saveNotificationTime("07:00");
        ScaffoldMessenger
            .of(context)
            .showSnackBar(SnackBar(
          content: Text(
              "Your notification time has been set to 07:00. You can change this in the settings screen later.",
              style: TextStyle(color: Colors.white)),
        ))
            .closed
            .then((value) {
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
          animationController.stop();
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

  Future<String> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    var id;
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      id = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      id = androidDeviceInfo.androidId; // unique ID on Android
    }
    setState(() {
      appId = id;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("app_id", id);

    if (id == null) {
      getId();
    }
    return id;
  }
}