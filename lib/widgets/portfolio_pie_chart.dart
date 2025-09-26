import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PortfolioPieChart extends StatelessWidget {
  final List<PortfolioData> data = [
    PortfolioData('Tech', 45, Colors.blue),
    PortfolioData('Finance', 25, Colors.green),
    PortfolioData('Healthcare', 15, Colors.orange),
    PortfolioData('Energy', 10, Colors.purple),
    PortfolioData('Other', 5, Colors.grey),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Portfolio Allocation',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: SfCircularChart(
            margin: EdgeInsets.zero,
            tooltipBehavior: TooltipBehavior(enable: true),
            series: <CircularSeries>[
              PieSeries<PortfolioData, String>(
                dataSource: data,
                xValueMapper: (PortfolioData data, _) => data.sector,
                yValueMapper: (PortfolioData data, _) => data.value,
                pointColorMapper: (PortfolioData data, _) => data.color,
                dataLabelSettings: DataLabelSettings(
                  isVisible: true,
                  labelPosition: ChartDataLabelPosition.outside,
                ),
                dataLabelMapper: (PortfolioData data, _) => '${data.value}%',
                radius: '80%',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class PortfolioData {
  final String sector;
  final double value;
  final Color color;

  PortfolioData(this.sector, this.value, this.color);
}