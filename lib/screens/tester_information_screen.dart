

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

import '../features/user/data/entity/user_dto.dart';

class TesterInformation extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TesterInformationState();
}

class TesterInformationState extends State<TesterInformation> {
  String? nickname;

  @override
  void initState() {
    super.initState();
    getUserName();
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
        automaticallyImplyLeading: false,
      ),
      body: buildPage(),
    );
  }

  void getUserName() async {
    var boxOpened = Hive.isBoxOpen("userBox");
    Box<User> box;
    var user;
    if (boxOpened) {
      box = Hive.box('userBox');
    } else {
      box = await Hive.openBox('userBox');
    }
    user = box.get('user');
    setState(() {
      nickname = user.nickname;
    });
  }

  Widget buildPage() {
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
              child: Text(
                nickname ?? "",
                style: TextStyle(color: Colors.white70, fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: Text(
                "Enter the above tester ID into the Google Form. You can see this ID on the home screen as well.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 16.0),
              ),
              ),
            ),
            SizedBox(height: 44),
            okButton()
          ],
        ),
      ),
    );
  }

  Widget okButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ProgressButton.icon(
        iconedButtons: {
          ButtonState.idle: IconedButton(
              text: "OK",
              icon: Icon(Icons.check, color: Colors.white),
              color: Colors.blue
          ),
          ButtonState.loading: IconedButton(
              text: "Submitting...",
              color: Colors.green
          ),
          ButtonState.fail: IconedButton(
              text: "Failed",
              icon: Icon(Icons.cancel,color: Colors.white),
              color: Colors.red.shade500
          ),
          ButtonState.success: IconedButton(
              text: "Success",
              icon: Icon(Icons.check_circle,color: Colors.white,),
              color: Colors.green
          )
        },
        progressIndicatorSize: 15.0,
        onPressed: () async {
          Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false);
        },
        state: ButtonState.idle,
      ),
    );
  }

}