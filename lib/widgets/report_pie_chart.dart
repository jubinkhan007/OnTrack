import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:tmbi/config/converts.dart';

class ReportPieChart extends StatelessWidget {
  const ReportPieChart({super.key, required this.dataMap, required this.colorList});

  final Map<String, double> dataMap;
  final List<Color> colorList;

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
