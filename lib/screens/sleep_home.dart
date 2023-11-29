import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:lbp/core/notificaton_model.dart';
import 'package:lbp/data/entity/notification/firebase_notification.dart';
import 'package:lbp/screens/auctions/auction_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipeable_button_view/swipeable_button_view.dart';

import '../domain/entity/questionnaires/auction/auction_data.dart';
import '../features/user/data/entity/user_dto.dart';
import '../screens/questionnaires/daily_questionnaire_screen.dart';

class SleepHome extends StatefulWidget {
  @override
  SleepHomeState createState() => SleepHomeState();
}

class SleepHomeState extends State<SleepHome> {
  String? _timeString;
  String? _amPmString;
  late Timer timer;
  String? todayTakenDate;
  String? nickname;
  bool isFinished = false;

  @override
  void initState() {
    getUserName();
    initializeVariables();
    _timeString = _formatDateTime(DateTime.now());
    _amPmString = _formatTimeOfDay(DateTime.now());
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  Future<void> initializeVariables() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var todayTaken = prefs.getString("notification_taken_date");

    setState(() {
      todayTakenDate = todayTaken;
    });
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

  String greeting() {
    var hour = DateTime
        .now()
        .hour;
    if (hour < 12) {
      return 'Good morning ${nickname ?? ""}';
    }
    if (hour < 17) {
      return 'Good afternoon ${nickname ?? ""}';
    }
    return 'Good evening ${nickname ?? ""}';
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedTime;
      _amPmString = _formatTimeOfDay(now);
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat("hh:mm").format(dateTime);
  }

  String _formatTimeOfDay(DateTime dateTime) {
    return DateFormat("a").format(dateTime);
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget checkIconToShow() {
    if (todayTakenDate == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
      return happyIcon();
    } else {
      return sadIcon();
    }
  }

  Widget sadIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Not completed yet. Click to open",
            style: TextStyle(color: Colors.white, fontSize: 14.0)),
        Icon(Icons.ads_click_outlined, color: Colors.orange),
      ],
    );
  }

  Widget happyIcon() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text("You've completed today's survey. Tap to retake.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.0,
                  overflow: TextOverflow.clip)),
        ),
        Icon(Icons.done_rounded, color: Colors.orange),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<NotificationModel>(context, listen: false);
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("images/sunrise.jpg"),
                        fit: BoxFit.cover)),
              ),
              Container(
                constraints: BoxConstraints.expand(),
                color: Colors.black38,
                margin: EdgeInsets.only(bottom: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    model.notification != null
                        ? showAuctionModal(model)
                        : Container(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              takeTodaySurveyClick(context);
                            },
                            child: Card(
                              elevation: 3.0,
                              color: Colors.grey[850],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              margin: EdgeInsets.all(8),
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Today's survey",
                                        style: TextStyle(
                                            color: Colors.white54)),
                                    SizedBox(height: 5),
                                    checkIconToShow()
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Clock
              Container(
                margin: EdgeInsets.only(top: 120.0),
                child: Align(
                  alignment: FractionalOffset.topCenter,
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("$_timeString",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 60.0,
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          width: 4,
                        ),
                        Text("$_amPmString",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(greeting(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300,
                            )),
                      ],
                    )
                  ]),
                ),
              ),
            ],
          ),
        );
  }

  showDialog(BuildContext context) {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: Text("Retake today's survey?"),
              content: Text(
                  "You've completed today's survey. Taking this survey again today will override your previous response."),
              actions: [
                CupertinoDialogAction(
                    child: Text("Dismiss"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                CupertinoDialogAction(
                    child: Text("Proceed"),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionnairePage()));
                    }),
              ],
            ));
  }

  Widget auctionModal(NotificationModel model) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SwipeableButtonView(
        buttonText: 'SLIDE TO JOIN AUCTION',
        buttonWidget: Container(
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.grey,
          ),
        ),
        activeColor: Color(0xFF009C41),
        isFinished: isFinished,
        onWaitingProcess: () {
          setState(() {
            isFinished = true;
          });
          // Future.delayed(Duration(microseconds: 1), () {
          //   takeTodaySurveyClick(context);
          // });
        },
        onFinish: () async {
          await Navigator.push(
              context,
              PageTransition(
                  type: PageTransitionType.fade,
                  child: AuctionScreen(
                    notification: model.notification,
                    onDelete: model.deleteNotification,
                    data: getAuctionData(model.notification),
                  )));

          setState(() {
            isFinished = false;
          });
        },
      ),
    );
  }

  List<Auction> getAuctionData(FirebaseNotification? notification) {
    List<Auction> list = [];
    notification?.data?.toJson().forEach((key, value) {
      if (key != "auctionId") {
        list.add(Auction(
            auctionId: notification.data?.auctionId,
            name: key,
            question: value,
            response: null));
      }
    });
    return list;
  }

  takeTodaySurveyClick(BuildContext context) {
    if (todayTakenDate == DateFormat("yyyy-MM-dd").format(DateTime.now())) {
      showDialog(context);
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => QuestionnairePage()));
    }
  }

  Widget showAuctionModal(NotificationModel model) {
    if (DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(
            model.notification!.sentTime!)) <
        Duration(hours: 12)) {
      return auctionModal(model);
    } else {
      model.deleteNotification();
      return Container();
    }
  }
}
