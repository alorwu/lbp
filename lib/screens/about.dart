import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('About this app', style: TextStyle(color: Colors.white)),
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
                        "Sleep is a vital biological function essential for the overall health. Ppoor sleep poses a potent risk factor for physical and psychological ailments including obesity, dementia, diabetes, and chronic pain. "
                            "Low back pain impacts one’s functional capacity and has been recognized globally as the most significant condition with respect to the number of years lived with disability. "
                            "\n\nResearch suggests a poor night’s sleep can contribute to an increased pain the next day and low back pain during the day can affect the quality of sleep at night. "
                            "Evidence however suggests that sleep can have a controlling influence on the intensity of pain."),
                  ),
                  Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                          "In this study, we want to investigate the relationship between low back pain and sleep. By using this application, you'll be helping us better understand this relationship while "
                              "offering you an opportunity to better understand the ailment you're suffering with and its interconnectedness to sleep.")),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
