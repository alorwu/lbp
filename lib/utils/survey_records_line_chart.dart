import 'package:fl_chart/fl_chart.dart';
import './color_extensions.dart';
import 'package:flutter/material.dart';

class ComponentScoresLineChart extends StatelessWidget {
  const ComponentScoresLineChart({
    this.title,
    this.spots,
    this.backgroundColor,
  });

  final String title;
  final List spots;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.65,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
          color: backgroundColor.darken(), //Color(0xff81e5cd),
        ),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.start,
                ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: LineChart(data),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData get data => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: 12,
        maxY: 3,
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        bottomTitles: bottomTitles,
        rightTitles: SideTitles(showTitles: false),
        topTitles: SideTitles(showTitles: false),
        leftTitles: leftTitles(
          getTitles: (value) {
            switch (value.toInt()) {
              case 0:
                return '0';
              case 1:
                return '1';
              case 2:
                return '2';
              case 3:
                return '3';
            }
            return '';
          },
        ),
      );

  List<LineChartBarData> get lineBarsData => [ lineChartBarData ];

  SideTitles leftTitles({GetTitleFunction getTitles}) => SideTitles(
        getTitles: getTitles,
        showTitles: true,
        margin: 8,
        interval: 1,
        reservedSize: 40,
        getTextStyles: (context, value) => TextStyle(
          color: backgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 22,
        margin: 10,
        interval: 1,
        getTextStyles: (context, value) => TextStyle(
          color: backgroundColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return 'J';
            case 2:
              return 'F';
            case 3:
              return 'M';
            case 4:
              return 'A';
            case 5:
              return 'M';
            case 6:
              return 'J';
            case 7:
              return 'J';
            case 8:
              return 'A';
            case 9:
              return 'S';
            case 10:
              return 'O';
            case 11:
              return 'N';
            case 12:
              return 'D';
          }
          return '';
        },
      );

  FlGridData get gridData => FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: backgroundColor.darken(20), width: 4),
          left: BorderSide(color: Colors.transparent),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData get lineChartBarData => LineChartBarData(
        isCurved: true,
        colors: [backgroundColor],
        barWidth: 6,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: this.spots
      );
}