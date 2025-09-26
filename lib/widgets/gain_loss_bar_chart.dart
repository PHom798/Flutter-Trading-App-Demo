import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../screens/dashboard_screen.dart';

class GainLossBarChart extends StatelessWidget {
  final List<Stock> stocks;

  const GainLossBarChart({Key? key, required this.stocks}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Daily Gain/Loss',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SfCartesianChart(
            margin: EdgeInsets.symmetric(horizontal: 8),
            plotAreaBorderWidth: 0,
            primaryXAxis: CategoryAxis(
              majorGridLines: MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              isVisible: false,
              majorGridLines: MajorGridLines(width: 0),
            ),
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CartesianSeries>[
              ColumnSeries<Stock, String>(
                dataSource: stocks,
                xValueMapper: (Stock stock, _) => stock.symbol,
                yValueMapper: (Stock stock, _) => stock.changePercent,
                pointColorMapper: (Stock stock, _) =>
                stock.changePercent >= 0 ? Colors.green : Colors.red,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  textStyle: TextStyle(fontSize: 10),
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}