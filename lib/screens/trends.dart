import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrendScreen extends StatefulWidget {
  @override
  TrendScreenState createState() => TrendScreenState();
}

class TrendScreenState extends State<TrendScreen> {

  Widget weekTab = SingleChildScrollView(
    child: Column(
      children: <Widget>[
        // Row 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep score
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep score",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("8.5",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.stacked_line_chart,
                              color: Colors.blue,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),

            // Sleep duration
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep duration",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("8h 59min",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.waterfall_chart,
                              color: Colors.pink,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep at
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep at",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("21:50",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.nights_stay,
                              color: Colors.deepPurple,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),

            // Wake up at
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Wake up at",
                            style:
                                TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("05:50",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.wb_sunny,
                              color: Colors.yellow,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 3
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sleep Duration",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.purpleAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 4
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sleep at", style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.blueAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 5
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Wake up at",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.greenAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        )
      ],
    ),
  );

  Widget monthTab = SingleChildScrollView(
    child: Column(
      children: <Widget>[
        // Row 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep score
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep score",
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("8.5",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.stacked_line_chart,
                              color: Colors.blue,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),

            // Sleep duration
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep duration",
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("8h 59min",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.waterfall_chart,
                              color: Colors.pink,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep at
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep at",
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("21:50",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.nights_stay,
                              color: Colors.deepPurple,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),

            // Wake up at
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Wake up at",
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("05:50",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.wb_sunny,
                              color: Colors.yellow,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 3
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sleep Duration",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.purpleAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 4
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sleep at", style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.blueAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 5
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Wake up at",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.greenAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        )
      ],
    ),
  );

  Widget allTab = SingleChildScrollView(
    child: Column(
      children: <Widget>[
        // Row 1
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep score
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep score",
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("8.5",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.stacked_line_chart,
                              color: Colors.blue,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),

            // Sleep duration
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep duration",
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("8h 59min",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.waterfall_chart,
                              color: Colors.pink,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 2
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sleep at
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Sleep at",
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("21:50",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.nights_stay,
                              color: Colors.deepPurple,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),

            // Wake up at
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Average",
                            style: TextStyle(color: Colors.white30)),
                        Text("Wake up at",
                            style:
                            TextStyle(color: Colors.white, fontSize: 15.0)),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("05:50",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18.0)),
                            Icon(
                              Icons.wb_sunny,
                              color: Colors.yellow,
                            )
                          ],
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 3
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sleep Duration",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.purpleAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 4
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Sleep at", style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.blueAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        ),

        // Row 5
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Card(
                  elevation: 3.0,
                  color: Color(0xff1F1F1F),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.all(8),
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Wake up at",
                            style: TextStyle(color: Colors.white)),
                        SizedBox(height: 10),
                        Container(
                          color: Colors.greenAccent,
                          height: 200.0,
                        )
                      ],
                    ),
                  )),
            ),
          ],
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Trends"),
              backgroundColor: Color(0xff000000),
              elevation: 0.0,
              brightness: Brightness.dark,
              bottom: TabBar(
                indicatorColor: Colors.white,
                indicatorSize: TabBarIndicatorSize.label,
                tabs: [
                  Padding(padding: EdgeInsets.all(10), child: Text("Week")),
                  Padding(padding: EdgeInsets.all(10), child: Text("Month")),
                  Padding(padding: EdgeInsets.all(10), child: Text("All")),
                ],
              ),
            ),
            backgroundColor: Color(0xff000000),
            extendBodyBehindAppBar: false,
            body: TabBarView(
              children: [weekTab, monthTab, allTab],
            )
        )
    );
  }
}
