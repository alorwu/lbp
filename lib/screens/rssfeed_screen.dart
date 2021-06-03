import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RssFeedScreen extends StatefulWidget {
  @override
  RssFeedState createState() => RssFeedState();
}

class RssFeedState extends State<RssFeedScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          title: Text('RSSFeed', style: TextStyle(color: Colors.white)),
        ),
      body: Text("Hello RSS"),
    );
  }

}