
import 'package:flutter/material.dart';

class AuctionScreen extends StatefulWidget {
  final String content;
  AuctionScreen({Key key, this.content}) : super(key: key);

  AuctionScreenState createState() => AuctionScreenState();
}

class AuctionScreenState extends State<AuctionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Auction"),
      ),
      body: Container(
        child: Center(
          child: Text("Auction taking place here: ${widget.content}"),
        ),
      ),
    );
  }

}