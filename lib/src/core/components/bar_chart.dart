// All rights reserved
// Monikode Mobile Solutions and Draw Your Fight
// Created by MoniK on 2024.
import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample4 extends StatefulWidget {
  const BarChartSample4({
    super.key,
    required this.values,
    this.maxY = 100,
    required this.xLabels,
    this.width,
  });

  static const Color green = Color(0xFF21D97B);
  static const Color yellow = Color(0xFFF7E879);
  static const Color red = Color(0xFFEF3D49);
  final List<double> values;
  final double maxY;
  final List<Widget> xLabels;
  final double? width;

  @override
  State<StatefulWidget> createState() => BarChartSample4State();
}

class BarChartSample4State extends State<BarChartSample4> {
  var pastDays = [];
  var i = 0;
  Widget bottomTitles(double value, TitleMeta meta) {
    Widget xLabel;
    xLabel = widget.xLabels[i];
    if (i < widget.xLabels.length - 1) {
      i++;
    } else {
      i = 0;
    }

    return SideTitleWidget(meta: meta, child: xLabel);
  }

  Widget leftTitles(double value, TitleMeta meta) {
    if (value == 101) {
      return const SizedBox();
    }
    const style = TextStyle(fontSize: 10);

    var val = ((value.toInt() / (widget.maxY == 0.0 ? 1 : widget.maxY)) * 100)
        .toInt();

    return SideTitleWidget(
      meta: meta,
      child: Text(val > 100 ? '' : '$val%', style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.66,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            const barsSpace = 24.0;
            const barsWidth = 24.0;
            return BarChart(
              BarChartData(
                maxY: widget.maxY + 1,
                alignment: BarChartAlignment.center,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 19,
                      getTitlesWidget: bottomTitles,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: max(widget.maxY / 5, 1).toDouble(),
                      getTitlesWidget: leftTitles,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 25,
                  checkToShowHorizontalLine: (value) => value > 0,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.black.withValues(alpha: 0.1),
                    strokeWidth: 1,
                  ),
                  drawVerticalLine: false,
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1,
                    ),
                  ),
                ),
                groupsSpace: barsSpace,
                barGroups: getData(barsWidth, barsSpace),
              ),
            );
          },
        ),
      ),
    );
  }

  List<BarChartGroupData> getData(double barsWidth, double barsSpace) {
    var list = <BarChartGroupData>[];
    for (var value in widget.values) {
      list.add(
        BarChartGroupData(
          x: widget.values.indexOf(value),
          barsSpace: barsSpace,
          barRods: [
            BarChartRodData(
              toY: value,
              color: value > widget.maxY * 0.3
                  ? value > widget.maxY * 0.7
                        ? BarChartSample4.red
                        : BarChartSample4.yellow
                  : BarChartSample4.green,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              width: barsWidth,
            ),
          ],
        ),
      );
    }
    return list;
  }
}
