import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tmbi/config/converts.dart';


class ReportPieChart extends StatelessWidget {
  ReportPieChart({super.key});

  final Map<String, double> dataMap = {
    "Pending": 5,
    "Delayed": 3,
    "Completed": 2
  };

  List<Color> colorList = [
    const Color(0xffFA4A42),
    const Color(0xffFE9539),
    const Color(0xff3EE094),
    //const Color(0xff3398F6),
  ];

  @override
  Widget build(BuildContext context) {
    return PieChart(
      dataMap: dataMap,
      animationDuration: const Duration(milliseconds: 1000),
      chartLegendSpacing: Converts.c120,
      colorList: colorList,
      initialAngleInDegree: 0,
    );
  }
}
