
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../env/.env.dart';
import '../features/user/data/entity/user_dto.dart';
import '../screens/settings/consent.dart';
import '../screens/settings/privacy_policy.dart';
import '../utils/preferences.dart';


class OnBoarding extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new OnBoardingState();
}

class OnBoardingState extends State<OnBoarding> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  String? appId;
  String? userToken;

  String? diagnosedOfLbp;
  String? username;
  String? gender;
  String? employment;
  String? exercise;
  String? academic;
  String? lbpTreatment;
  String? hasHadBackSurgery;
  String? hasHadLowBackPain;
  String? sciatica;
  String? painIntensity;
  double activeLifeStyleLevel = -1;

  ButtonState submitButtonState = ButtonState.idle;

  var sliderHeight = 48.0;
  var max = 10;
  var min = 0;
  var fullWidth = false;

  bool? consentCheck = false;
  var diagnosedOfLbpByDoctor = ["No", "Yes"];
  var defaultNotificationTimeString = "07:00";

  double sliderValue = 0;

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


  late GSheets gSheets;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getId();
    getUserToken();
    // gSheets = GSheets(environment['credentials']);
    gSheets = GSheets(credentials);
  }

  // Widget sliderWidget() {
  //   return Column(
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         Container(
  //           width: double.infinity,
  //           height: (sliderHeight),
  //           decoration: new BoxDecoration(
  //             borderRadius: new BorderRadius.all(
  //               Radius.circular((sliderHeight * .3)),
  //             ),
  //           ),
  //           child: Padding(
  //             padding: EdgeInsets.all(1.0),
  //             child: Row(
  //               children: <Widget>[
  //                 Text(
  //                   '$min',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: sliderHeight * .3,
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: sliderHeight * .1,
  //                 ),
  //                 Expanded(
  //                   child: Center(
  //                     child: SliderTheme(
  //                       data: SliderTheme.of(context).copyWith(
  //                         activeTrackColor: Colors.blue.withOpacity(1),
  //                         trackHeight: 4.0,
  //                         thumbShape: CustomSliderThumbCircle(
  //                           thumbRadius: sliderHeight * .4,
  //                           min: min,
  //                           max: max,
  //                         ),
  //                         activeTickMarkColor: Colors.blue,
  //                         inactiveTickMarkColor: Colors.blue,
  //                       ),
  //                       child: Slider(
  //                           value: sliderValue,
  //                           min: 0,
  //                           max: 10,
  //                           divisions: 10,
  //                           onChanged: (double value) {
  //                             setState(() {
  //                               sliderValue = value;
  //                               activeLifeStyleLevel = value;
  //                             });
  //                           }),
  //                     ),
  //                   ),
  //                 ),
  //                 Text(
  //                   '$max',
  //                   textAlign: TextAlign.center,
  //                   style: TextStyle(
  //                     fontSize: sliderHeight * .3,
  //                     fontWeight: FontWeight.w700,
  //                     color: Colors.black,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.all(1.0),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Text(
  //                 'Not at all active',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: sliderHeight * .3,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //               Text(
  //                 'Extremely active',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontSize: sliderHeight * .3,
  //                   color: Colors.black,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ]);
  // }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text('Getting Started'),
      //   backgroundColor: Color(0xff000000),
      //   elevation: 0.0,
      //   brightness: Brightness.dark,
      // ),
      body: Padding(
          padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(40.0),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(250.0),
                      child: Image.asset(
                        'images/logo.png',
                        height: 140.0,
                        width: 140.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        value: this.consentCheck,
                        onChanged: (bool? value) {
                          setState(() {
                            this.consentCheck = value;
                          });
                        },
                      ),
                      Expanded(
                          child: RichText(
                              text: TextSpan(
                                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
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
                SizedBox(height: 50.0),
                consentCheck == true
                ? Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ProgressButton.icon(
                      iconedButtons: {
                        ButtonState.idle: IconedButton(
                            text: "Get started",
                            icon: Icon(Icons.thumb_up, color: Colors.white),
                            color: Colors.blue),
                        ButtonState.loading: IconedButton(
                            text: "Submitting...", color: Colors.blue),
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
                            color: Colors.green)
                      },
                      progressIndicatorSize: 20.0,
                      onPressed: () async {
                        await getUserToken();
                        sendData(context);
                      },
                      state: submitButtonState,
                    ),
                  )
                : Container(),
          ],
            ),
      ),
          // Form(
          //   key: _formKey,
          //   child: SingleChildScrollView(
          //     child: ListView(
          //       shrinkWrap: true,
          //       physics: NeverScrollableScrollPhysics(),
          //       children: <Widget>[
          //         Container(
          //           alignment: Alignment.center,
          //           padding: EdgeInsets.all(10.0),
          //           child: Text(
          //             "Let's get acquainted!",
          //             style: TextStyle(
          //               color: Colors.blue,
          //               fontWeight: FontWeight.w500,
          //               fontSize: 20,
          //             ),
          //             textAlign: TextAlign.center,
          //           ),
          //         ),
          //         SizedBox(height: 10),
          //         Divider(),
          //         SizedBox(height: 20),
          //         // Text("Enter your nickname", style: TextStyle(color: Colors.blue)),
          //         // TextFormField(
          //         //   focusNode: new FocusNode(),
          //         //   decoration: InputDecoration(
          //         //     hintText: "e.g. Murvin",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   keyboardType: TextInputType.text,
          //         //   controller: nicknameController,
          //         //   validator: (value) {
          //         //     if (value!.isEmpty) {
          //         //       return 'Please enter a nickname';
          //         //     }
          //         //     return null;
          //         //   },
          //         // ),
          //         // SizedBox(height: 20),
          //         // Text("How old are you (in years)?", style: TextStyle(color: Colors.blue)),
          //         // TextFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "e.g. 24",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   keyboardType: TextInputType.number,
          //         //   maxLength: 2,
          //         //   controller: ageController,
          //         //   validator: (value) {
          //         //     if (value!.isEmpty) {
          //         //       return 'Please enter an age';
          //         //     }
          //         //     if (int.parse(value) < 18) {
          //         //       return 'Persons 18 and above only';
          //         //     }
          //         //     return null;
          //         //   },
          //         // ),
          //         // SizedBox(height: 20),
          //         // Text("What is your gender?", style: TextStyle(color: Colors.blue)),
          //         // DropdownButtonFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "Choose one",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   items: ["Male", "Female", "Other", "Do not disclose"]
          //         //       .map<DropdownMenuItem<String>>((String value) {
          //         //     return DropdownMenuItem<String>(
          //         //       value: value,
          //         //       child: Text(value, overflow: TextOverflow.clip),
          //         //     );
          //         //   }).toList(),
          //         //   onChanged: (String? value) {
          //         //     setState(() {
          //         //       gender = value;
          //         //     });
          //         //   },
          //         //   validator: (dynamic value) {
          //         //     if (value == null) {
          //         //       return 'Please select a gender';
          //         //     }
          //         //     return null;
          //         //   },
          //         //   value: gender,
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Text("What is your employment status?", style: TextStyle(color: Colors.blue)),
          //         // DropdownButtonFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "Choose one",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   items: ["Full-time work", "Part-time work", "Retired",
          //         //     "Unemployed", "I do not wish to disclose"]
          //         //       .map<DropdownMenuItem<String>>((String value) {
          //         //     return DropdownMenuItem<String>(
          //         //       value: value,
          //         //       child: Text(value),
          //         //     );
          //         //   }).toList(),
          //         //   onChanged: (String? value) {
          //         //     setState(() {
          //         //       employment = value;
          //         //     });
          //         //   },
          //         //   validator: (dynamic value) {
          //         //     if (value == null) {
          //         //       return 'Please select one';
          //         //     }
          //         //     return null;
          //         //   },
          //         //   value: employment,
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Text("What is your highest academic qualification?",
          //         //     style: TextStyle(color: Colors.blue)),
          //         // DropdownButtonFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "Choose one",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   items: ["Master's degree or higher", "Bachelor's degree",
          //         //     "High school", "International master's degree",
          //         //     "Vocational degree", "Dual qualification",
          //         //     "Primary school", "I do not wish to disclose"]
          //         //       .map<DropdownMenuItem<String>>((String value) {
          //         //     return DropdownMenuItem<String>(
          //         //       value: value,
          //         //       child: Text(value),
          //         //     );
          //         //   }).toList(),
          //         //   onChanged: (String? value) {
          //         //     setState(() {
          //         //       academic = value;
          //         //     });
          //         //   },
          //         //   validator: (dynamic value) {
          //         //     if (value == null) {
          //         //       return 'Please select one';
          //         //     }
          //         //     return null;
          //         //   },
          //         //   value: academic,
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Container(
          //         //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
          //         //   child: Column(
          //         //     children: <Widget>[
          //         //       Text(
          //         //         "How active is your lifestyle in general?",
          //         //         style: TextStyle(color: Colors.blue),
          //         //       ),
          //         //       SizedBox(height: 5.0),
          //         //       sliderWidget(),
          //         //     ],
          //         //   ),
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Text("Have you previously experienced lower back pain?", style: TextStyle(color: Colors.blue)),
          //         // DropdownButtonFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "Choose one",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   items: ["No", "Yes, it is chronic or it renews easily",
          //         //     "Yes, but it is not chronic or it does not renew easily"]
          //         //       .map<DropdownMenuItem<String>>((String value) {
          //         //     return DropdownMenuItem<String>(
          //         //       value: value,
          //         //       child: Text(value, overflow: TextOverflow.clip),
          //         //     );
          //         //   }).toList(),
          //         //   onChanged: (String? value) {
          //         //     setState(() {
          //         //       hasHadLowBackPain = value;
          //         //     });
          //         //   },
          //         //   isExpanded: true,
          //         //   itemHeight: 50.0,
          //         //   validator: (dynamic value) {
          //         //     if (value == null) {
          //         //       return 'Please select one';
          //         //     }
          //         //     return null;
          //         //   },
          //         //   value: hasHadLowBackPain,
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Text("Have you had or do you have sciatica?", style: TextStyle(color: Colors.blue)),
          //         // DropdownButtonFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "Choose one",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   items: ["No", "Yes, it is chronic or it renews easily",
          //         //     "Yes, but it is not chronic or it does not renew easily"]
          //         //       .map<DropdownMenuItem<String>>((String value) {
          //         //     return DropdownMenuItem<String>(
          //         //       value: value,
          //         //       child: Text(value),
          //         //     );
          //         //   }).toList(),
          //         //   onChanged: (String? value) {
          //         //     setState(() {
          //         //       sciatica = value;
          //         //     });
          //         //   },
          //         //   isExpanded: true,
          //         //   itemHeight: 50.0,
          //         //   validator: (dynamic value) {
          //         //     if (value == null) {
          //         //       return 'Please select one';
          //         //     }
          //         //     return null;
          //         //   },
          //         //   value: sciatica,
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Text("Are you experiencing back pain right now? How intense is it?", style: TextStyle(color: Colors.blue)),
          //         // DropdownButtonFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "Choose one",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   items: ["0 - no recognizable pain", "1", "2", "3", "4", "5",
          //         //     "6", "7", "8", "9", "10 - unbearable pain"]
          //         //       .map<DropdownMenuItem<String>>((String value) {
          //         //     return DropdownMenuItem<String>(
          //         //       value: value,
          //         //       child: Text(value),
          //         //     );
          //         //   }).toList(),
          //         //   onChanged: (String? value) {
          //         //     setState(() {
          //         //       painIntensity = value;
          //         //     });
          //         //   },
          //         //   validator: (dynamic value) {
          //         //     if (value == null) {
          //         //       return 'Please select one';
          //         //     }
          //         //     return null;
          //         //   },
          //         //   value: painIntensity,
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Text("Has your back ever been surgically operated?", style: TextStyle(color: Colors.blue)),
          //         // DropdownButtonFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "Choose one",
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //   ),
          //         //   items: ["No", "Yes"]
          //         //       .map<DropdownMenuItem<String>>((String value) {
          //         //     return DropdownMenuItem<String>(
          //         //       value: value,
          //         //       child: Text(value),
          //         //     );
          //         //   }).toList(),
          //         //   onChanged: (String? value) {
          //         //     setState(() {
          //         //       hasHadBackSurgery = value;
          //         //     });
          //         //   },
          //         //   validator: (dynamic value) {
          //         //     if (value == null) {
          //         //       return 'Please select one';
          //         //     }
          //         //     return null;
          //         //   },
          //         //   value: hasHadBackSurgery,
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Text("How long have you had Low Back Pain? (in years)",
          //         //     style: TextStyle(color: Colors.blue)),
          //         // TextFormField(
          //         //   decoration: InputDecoration(
          //         //     hintText: "e.g. 10",
          //         //     hintStyle: TextStyle(color: Colors.grey)
          //         //   ),
          //         //   focusNode: new FocusNode(),
          //         //   keyboardType: TextInputType.number,
          //         //   controller: durationController,
          //         //   validator: (value) {
          //         //     if (value!.isEmpty) {
          //         //       return "Tell us how long you've had low back pain";
          //         //     }
          //         //     return null;
          //         //   },
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Container(
          //         //   child: Column(
          //         //     children: <Widget>[
          //         //       Text(
          //         //         'Have you been clinically diagnosed with Low Back Pain by a doctor?',
          //         //         style: TextStyle(color: Colors.blue),
          //         //       ),
          //         //       radioWidget(),
          //         //     ],
          //         //   ),
          //         // ),
          //         // SizedBox(height: 20.0),
          //         // Text("In your own words please describe how you treat and maintain your lower back in your everyday life.",
          //         //     style: TextStyle(color: Colors.blue)),
          //         // SizedBox(height: 10.0),
          //         // TextFormField(
          //         //   decoration: new InputDecoration(
          //         //     enabledBorder: const OutlineInputBorder(
          //         //         borderSide: const BorderSide(color: Colors.grey, width: 1.0)
          //         //     ),
          //         //     focusedBorder: const OutlineInputBorder(
          //         //       borderSide: BorderSide(color: Colors.grey),
          //         //     ),
          //         //     hintStyle: TextStyle(color: Colors.grey),
          //         //     hintText: "Enter text here",
          //         //     helperText: "No answer is wrong. Write freely.",
          //         //     helperStyle: TextStyle(color: Colors.grey),
          //         //     errorBorder: const OutlineInputBorder(
          //         //       borderSide: BorderSide(color: Colors.red),
          //         //     ),
          //         //     focusedErrorBorder: const OutlineInputBorder(
          //         //       borderSide: BorderSide(color: Colors.grey),
          //         //     ),
          //         //   ),
          //         //   keyboardType: TextInputType.multiline,
          //         //   maxLines: 6,
          //         //   onChanged: (String value) {
          //         //     setState(() {
          //         //       lbpTreatment = value;
          //         //     });
          //         //   },
          //         // ),
          //         SizedBox(height: 20.0),
          //         Container(
          //           padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          //           child: Row(
          //             children: <Widget>[
          //               Checkbox(
          //                 value: this.consentCheck,
          //                 onChanged: (bool? value) {
          //                   setState(() {
          //                     this.consentCheck = value;
          //                   });
          //                 },
          //               ),
          //               Expanded(
          //                 child: RichText(
          //                   text: TextSpan(
          //                     style: TextStyle(color: Colors.grey),
          //                     children: <TextSpan>[
          //                       TextSpan(text: "I have read and agree to the terms and conditions as outlined in the "),
          //                       TextSpan(
          //                         text: "user consent agreement ",
          //                         style: TextStyle(color: Colors.blue),
          //                         recognizer: TapGestureRecognizer()..onTap = () {
          //                           Navigator.push(context, MaterialPageRoute(builder: (context) => ConsentScreen()));
          //                         }
          //                       ),
          //                       TextSpan(text: "and "),
          //                       TextSpan(
          //                           text: "privacy policy.",
          //                           style: TextStyle(color: Colors.blue),
          //                           recognizer: TapGestureRecognizer()..onTap = () {
          //                             Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyDisclaimerScreen()));
          //                           }
          //                       )
          //                     ]
          //                   )
          //                 )
          //               ),
          //                 ],
          //           ),
          //         ),
          //         SizedBox(height: 20.0),
          //         Container(
          //           height: 50,
          //           padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          //           child: ProgressButton.icon(
          //             iconedButtons: {
          //               ButtonState.idle: IconedButton(
          //                   text: "Submit",
          //                   icon: Icon(Icons.send, color: Colors.white),
          //                   color: Colors.green
          //               ),
          //               ButtonState.loading: IconedButton(
          //                   text: "Submitting...",
          //                   color: Colors.green
          //               ),
          //               ButtonState.fail: IconedButton(
          //                   text: "Failed",
          //                   icon: Icon(Icons.cancel,color: Colors.white),
          //                   color: Colors.red.shade500
          //               ),
          //               ButtonState.success: IconedButton(
          //                   text: "Success",
          //                   icon: Icon(Icons.check_circle,color: Colors.white,),
          //                   color: Colors.green
          //               )
          //             },
          //             progressIndicatorSize: 20.0,
          //             onPressed: () async {
          //               if (this.consentCheck!) {
          //                 validateAndSend();
          //               }
          //             },
          //             state: submitButtonState,
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
    );
  }

  showSnackBar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
          message,
          style: TextStyle(color: Colors.white)),
    ));
  }

  Future<void> sendData(BuildContext context) async {
    setState(() {
      submitButtonState = ButtonState.loading;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('segment', '07:00');
    var segment = getSegment(defaultNotificationTimeString.substring(0,2));
    var user = User(
      id: appId,
      token: userToken,
      nickname: null,
      date: DateTime.now().toIso8601String(),
      segment: segment,
    );

    var registeredUser = await registerUser(user);
    user.nickname = registeredUser.nickname;
    await saveDataLocally(user);
    sendDataToGoogleSheets(registeredUser.nickname, appId);
    sendDataToGoogleSheets(user.nickname, appId); // remove after

    await Preferences.updateOnboarding(false);
    await Preferences.saveNotificationTime(defaultNotificationTimeString);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(
          content: Text(
              "Your notification time has been set to 07:00. You can change this in the settings screen later.",
              style: TextStyle(color: Colors.white)),
        ))
        .closed
        .then((value) {
          Navigator.pushNamedAndRemoveUntil(
              context, 'testerinformation', (route) => false);
          setState(() {
            submitButtonState = ButtonState.success;
          });
        });
  }

  Future<void> sendDataToGoogleSheets(String? testerId, String? appId) async {
    List values = [appId, testerId, DateTime.now().toString()];

    final ss = await gSheets
        .spreadsheet('1b5AmPGPqgUASo_BrNBUnWVn0e2BYOc7t8VSqllOc6MQ');
    var sheet = ss.worksheetByTitle('user_info');
    sheet ??= await ss.addWorksheet('user_info');
    sheet.values.appendRow(values);
  }

  Future<String?> getId() async {
    var deviceInfo = DeviceInfoPlugin();
    var id;
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      id = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      id = androidDeviceInfo.androidId; // unique ID on Android
    }
    if (id == null) {
      getId();
    }
    setState(() {
      appId = id;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("app_id", id);
    return id;
  }

  Future<void> getUserToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    setState(() {
      userToken = token;
    });
  }

  String getSegment(String segmentString) {
    var now = DateTime.now();
    var d = DateTime(now.year, now.month, now.day, int.parse(segmentString)).toUtc();
    return DateFormat("HH").format(d);
  }

  Future<User> registerUser(User user) async {
    final response = await http.post(
      Uri.parse('${environment['remote_url']}/api/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toJson())
    );
    return if(!response.statusCode.toString().startsWith("2"))
       showDialog(context, user);
    else User.fromJson(jsonDecode(response.body));
  }

  Future<void> saveDataLocally(User user) async {
    Box<User> box = Hive.box("userBox");
    await box.put("user", user);
  }

  showDialog(BuildContext context, User user) {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: Text("Could not save data"),
              content: Text(
                  "There was an error saving your data."),
              actions: [
                CupertinoDialogAction(
                    child: Text("Dismiss"),
                    onPressed: () {
                      setState(() {
                        submitButtonState = ButtonState.idle;
                      });
                      Navigator.of(context).pop();
                    }),
                CupertinoDialogAction(
                    child: Text("Try again"),
                    onPressed: () {
                      registerUser(user);
                    }),
              ],
            ));
  }
}