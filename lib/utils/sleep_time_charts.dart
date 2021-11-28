import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SleepTimeChart extends StatelessWidget {

  const SleepTimeChart({
    this.data,
    this.title,
  });

  final List<BarChartGroupData> data;
  final String title;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Container(
        decoration: BoxDecoration(
          borderRadius:  BorderRadius.all(Radius.circular(6)),
          color: Color(0xff2c4260),
        ),
        child: Stack(
          children: <Widget> [
            Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold
                ),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 16.0, right: 16.0),
                child: BarChart(
                  BarChartData(
                    barTouchData: barTouchData,
                    titlesData: titlesData(data),
                    borderData: borderData,
                    barGroups: data,
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 24,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
         ],
        ),
        ],
        ),
      ),
    );

  }

  BarTouchData get barTouchData => BarTouchData(
    enabled: false,
    touchTooltipData: BarTouchTooltipData(
      tooltipBgColor: Colors.transparent,
      tooltipPadding: const EdgeInsets.all(0),
      tooltipMargin: 8,
      getTooltipItem: (
          BarChartGroupData group,
          int groupIndex,
          BarChartRodData rod,
          int rodIndex,
          ) {
        return BarTooltipItem(
          rod.y.round() > 0 ? "${rod.y.round()}h" : "",
          TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.normal,
            fontSize: data.length == 7 ? 12 : 8,
          ),
        );
      },
    ),
  );

  FlTitlesData titlesData(List<BarChartGroupData> groupData) => FlTitlesData(
    show: true,
    bottomTitles: SideTitles(
      showTitles: true,
      getTextStyles: (context, value) => const TextStyle(
        color: Color(0xff7589a2),
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
      margin: 20,
      getTitles: (double value) {
        if (groupData.length == 7) {
          switch (value.toInt()) {
            case 0:
              return 'M';
            case 1:
              return 'T';
            case 2:
              return 'W';
            case 3:
              return 'T';
            case 4:
              return 'F';
            case 5:
              return 'S';
            case 6:
              return 'S';
            default:
              return '';
          }
        } else {
          return (value + 1) % 2 == 0 ? '' : (value + 1).toInt().toString();
        }
      },
    ),
    leftTitles: SideTitles(showTitles: false),
    topTitles: SideTitles(showTitles: false),
    rightTitles: SideTitles(showTitles: false),
  );

  FlBorderData get borderData => FlBorderData(
    show: false,
  );

}