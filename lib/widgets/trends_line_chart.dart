import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class TrendsLineChart extends StatefulWidget {
  @override
  _TrendsLineChartState createState() => _TrendsLineChartState();
}

class _TrendsLineChartState extends State<TrendsLineChart> {
  List<TrendData> chartData = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    double value = 100000;
    DateTime now = DateTime.now();

    for (int i = 7; i >= 0; i--) {
      value += (_random.nextDouble() - 0.45) * 2000;
      chartData.add(TrendData(
        now.subtract(Duration(days: i)),
        value,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Portfolio Trend',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SfCartesianChart(
            margin: EdgeInsets.all(8),
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeAxis(
              majorGridLines: MajorGridLines(width: 0),
              intervalType: DateTimeIntervalType.days,
              dateFormat: DateFormat.E(),
            ),
            primaryYAxis: NumericAxis(
              isVisible: false,
              majorGridLines: MajorGridLines(width: 0),
            ),
            tooltipBehavior: TooltipBehavior(
              enable: true,
              header: 'Portfolio Value',
            ),
            series: <CartesianSeries>[
              AreaSeries<TrendData, DateTime>(
                dataSource: chartData,
                xValueMapper: (TrendData data, _) => data.date,
                yValueMapper: (TrendData data, _) => data.value,
                color: Colors.blue.withOpacity(0.3),
                borderColor: Colors.blue,
                borderWidth: 2,
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.withOpacity(0.5),
                    Colors.blue.withOpacity(0.1),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TrendData {
  final DateTime date;
  final double value;

  TrendData(this.date, this.value);
}
