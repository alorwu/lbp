
import 'dart:convert';

import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:lbp/data/entity/notification/firebase_notification.dart';
import 'package:lbp/domain/entity/questionnaires/auction/auction_data.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;

import '../../core/notificaton_model.dart';
import '../../env/.env.dart';

class AuctionScreen extends StatefulWidget {
  final FirebaseNotification? notification;
  final VoidCallback onDelete;
  final List<Auction> data;
  AuctionScreen({
    Key? key,
    this.notification,
    required this.onDelete,
    required this.data
  }) : super(key: key);

  AuctionScreenState createState() => AuctionScreenState();
}

class AuctionScreenState extends State<AuctionScreen> {
  ButtonState submitButtonState = ButtonState.idle;

  AuctionData auctionData = AuctionData();
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    setState(() {
      auctionData.addList(widget.data);
    });
  }

  void onTextChanged() {
    setState(() {
      auctionData.getItem().response = double.tryParse(textController.text);
    });
  }


  Widget textResponseWidget() {
    return Center(
        child: Container(
          child: TextFormField(
            key: Key(auctionData.itemPosition().toString()),
            initialValue: auctionData.getItem().response != null ? auctionData.getItem().response.toString() : "",
            // controller: textController,
            autofocus: true,
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
              hintText: "Enter your bid here (£X.XX)",
              helperStyle: TextStyle(color: Colors.white),
              helperText: "* Press 'Skip' if you do not want to sell this data"
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            maxLines: 1,
            onChanged: (String value) {
                value = value.replaceAll(",", ".");
                setState(() {
                  auctionData
                      .getItem()
                      .response = double.tryParse(value);
                });
            },
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
              DecimalTextInputFormatter(decimalRange: 2),
            ],
          ),
        ),
    );
  }

  Widget submitButton() {
    return Container(
      width: 170,
      height: 50,
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
            saveAuction();
          },
          state: submitButtonState,
        ),
    );
  }

  void saveAuction() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var id = preferences.getString("app_id");
    List list = [];
    auctionData.getItems().forEach((element) {
      list.add(element.response);
    });
    AuctionResponse auctionResponse = AuctionResponse(
      userId: id,
      auctionId: auctionData.getItem().auctionId,
      sleepDurationData: list[0],
      sleepQualityData: list[1],
      painIntensityData: list[2],
      numberOfWakeupTimes: list[3],
    );

    final response = await http.post(
      Uri.parse('${environment['remote_url']}/api/auctions'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(auctionResponse.toJson()),
    );
    if (!response.statusCode.toString().startsWith("2")) {
      setState(() {
        submitButtonState = ButtonState.fail;
      });
      showDialog(context, auctionResponse);
    } else {
      await NotificationModel().deleteNotification();
      setState(() {
        submitButtonState = ButtonState.success;
      });
      showSuccessDialog(context);
    }
  }

  showSuccessDialog(BuildContext context) {
    showCupertinoDialog<void>(
        context: context,
        builder: (BuildContext context) =>
            CupertinoAlertDialog(
              title: Text("Data saved successfully"),
              actions: [
                CupertinoDialogAction(
                    child: Text("OK"),
                    onPressed: () async {
                      NotificationModel().deleteNotification().then((value) =>
                        Navigator.pushNamedAndRemoveUntil(context, 'home', (route) => false)
                      );
                    })
              ],
            ));
  }
  showDialog(BuildContext context, AuctionResponse response) {
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
                      Navigator.of(context).pop();
                    }),
              ],
            ));
  }

  Widget buildAuctionUi() {
    return Padding(
      padding: EdgeInsets.only(left: 20.0, top: 10.0, right: 20.0, bottom: 10.0),
      child: Card(
        color: Colors.blueAccent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Center(
              child: DotsIndicator(
                dotsCount: auctionData.getItemListLength(),
                position: auctionData.itemPosition().toDouble(),
                decorator: DotsDecorator(
                    size: Size.square(12),
                    activeSize: Size(15, 15),
                    activeColor: Colors.white70, //Theme.of(context).primaryColor,
                    color: Colors.black54 //Theme.of(context).disabledColor,
                ),
              ),
            ),
            Center(
              child: Text(
                "${auctionData.itemPosition() + 1} / ${auctionData.getItemListLength().toString()}",
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Center(
                  child: Text(
                    auctionData.getItem().question ?? "",
                    // "What money should we pay you for 1 week of your location data? Use X.XX format to enter the amount in EUR",
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Center(
                  child: textResponseWidget(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    auctionData.itemPosition() > 0
                        ? prevButton()
                        : Container(),
                    auctionData.lastItem()
                        ? submitButton()
                        : nextButton()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget prevButton() {
    return Container(
        width: 100,
        height: 50,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white)),
            onPressed: () => prevButtonClickHandler(),
            child: Text(
              'Prev',
              style: TextStyle(color: Colors.white),
            ),
        ),
    );
  }

  void prevButtonClickHandler() {
    setState(() {
      if (auctionData.previousItem() == false) {
        // completed = false;
      }
    });
  }

  Widget nextButton() {
    return Container(
        width: 100,
        height: 50,
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.white)),
            onPressed: () => nextButtonClickHandler(),
            child: Text(
              auctionData.getItem().response != null && auctionData.getItem().response.toString().isNotEmpty ? 'Next' : 'Skip',
              style: TextStyle(color: Colors.white),
            ),
        ),
    );
  }

  void nextButtonClickHandler() {
    setState(() {
      if (auctionData.nextItem() == true) {
        // completed = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Bid now!"),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      body: buildAuctionUi(),
      resizeToAvoidBottomInset: true,
    );
  }

}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({required this.decimalRange})
      : assert(decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, // unused.
      TextEditingValue newValue,
      ) {
    TextSelection newSelection = newValue.selection;
    String truncated = newValue.text;

    String value = newValue.text;

    if (value.contains(".") &&
        value.substring(value.indexOf(".") + 1).length > decimalRange) {
      truncated = oldValue.text;
      newSelection = oldValue.selection;
    } else if (value == ".") {
      truncated = "0.";

      newSelection = newValue.selection.copyWith(
        baseOffset: math.min(truncated.length, truncated.length + 1),
        extentOffset: math.min(truncated.length, truncated.length + 1),
      );
    }

    return TextEditingValue(
      text: truncated,
      selection: newSelection,
      composing: TextRange.empty,
    );
    return newValue;
  }
}