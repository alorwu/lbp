import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('About this app'),
        backgroundColor: Color(0xff000000),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Builder(
        builder: (context) => SingleChildScrollView(
          child: Card(
            elevation: 5.0,
            margin: EdgeInsets.all(20.0),
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        "Do you have low back pain and trouble sleeping? The Sleep Better with Back Pain app is part of international research that will ultimately help you and people just like you to sleep better."),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          "There is power in the consolidation of ideas: your ideas. This app collects data on your sleep and back pain via daily and monthly surveys. You can also donate ideas on how to sleep better and rate and discover ideas by other app users!"),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        "Additionally, if you have an Oura ring, you may join an Oura team managed by the researchers to provide us with more detailed sleep data."),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                        "At the end of the study, your data are combined with others and analyzed to learn more about low back pain and find the best ways to help you sleep better."),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
