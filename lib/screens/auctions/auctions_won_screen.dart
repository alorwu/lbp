import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lbp/domain/entity/questionnaires/auction/auction_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../env/.env.dart';

class AuctionsWonScreen extends StatefulWidget {
  AuctionsWonScreenState createState() => AuctionsWonScreenState();
}

const DATE_FORMAT_DAY = "yMMMMd";

class AuctionsWonScreenState extends State<AuctionsWonScreen> {
  var winnings = List<AuctionWinnings>.empty();
  double totalWinnings = 0.0;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<Winnings> load() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString('app_id');
    var response = await http.get(
      Uri.parse('${environment['remote_url']}/api/auctions/winners/$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Winnings win = Winnings.fromJson(json.decode(response.body));
      setState(() {
        winnings = win.data ?? List<AuctionWinnings>.empty();
        totalWinnings = win.totalWinnings ?? 0.0;
      });
      return win;
    } else {
      throw Exception("Error loading data");
    }
  }

  Widget totalCard() {
    return Card(
      color: Color(0xff1f1f1f),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total winnings",
                      style: TextStyle(
                          color: Colors.white,
                        fontSize: 18.0
                      )),
                  Text("£$totalWinnings",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w300))
                ],
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
    );
  }

  Widget winningsCard(int index, AuctionWinnings data) {
    return Card(
      color: Color(0xff1f1f1f),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat(DATE_FORMAT_DAY).format(DateTime.parse(data.createdAt!)),
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Divider(height: 1.0, color: Colors.white70),
            SizedBox(height: 15.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Category", style: TextStyle(color: Colors.white54)),
                Text(
                  "Amount won",
                  style: TextStyle(color: Colors.white54),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    "${data.auctionDataType}",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.w300)),
                Text(
                    "£${data.winningValue.toString()}",
                    style: TextStyle(
                        color: Colors.white54,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300))
              ],
            ),
            SizedBox(height: 15.0),
          ],
        ),
      ),
    );
  }

  Widget winningsList() {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: winnings.length,
        itemBuilder: (context, index) {
          return winningsCard(index, winnings[index]);
        },
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Auction winnings'),
        backgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      body: FutureBuilder<Winnings>(
        future: load(),
        builder: (BuildContext context, AsyncSnapshot<Winnings> snapShot) {
          if (snapShot.hasData) {
            if (winnings.isNotEmpty) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  totalCard(),
                  winningsList()
                ],
              );
            } else {
              return Center(child: Text("You have not won any auctions yet. Keep bidding."));
            }
          } else if (snapShot.hasError) {
            return Center(
              child: Text("There was an error retrieving data. Please try again later."),
            );
          } else {
            return Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(
                  color: Colors.black54,
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
