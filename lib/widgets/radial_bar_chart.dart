import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RadialBarChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<WinLossData> data = [
      WinLossData('Wins', 65, Colors.green),
      WinLossData('Losses', 35, Colors.red),
    ];

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Win/Loss Ratio',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SfCircularChart(
            margin: EdgeInsets.zero,
            series: <CircularSeries>[
              RadialBarSeries<WinLossData, String>(
                dataSource: data,
                xValueMapper: (WinLossData data, _) => data.category,
                yValueMapper: (WinLossData data, _) => data.value,
                pointColorMapper: (WinLossData data, _) => data.color,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                dataLabelMapper: (WinLossData data, _) => '${data.value}%',
                cornerStyle: CornerStyle.bothCurve,
                innerRadius: '30%',
                gap: '10%',
              ),
            ],
            annotations: <CircularChartAnnotation>[
              CircularChartAnnotation(
                widget: Container(
                  child: Text(
                    '65%',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WinLossData {
  final String category;
  final double value;
  final Color color;

  WinLossData(this.category, this.value, this.color);
}