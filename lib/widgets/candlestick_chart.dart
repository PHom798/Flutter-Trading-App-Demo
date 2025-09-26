import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'dart:math';
import '../screens/dashboard_screen.dart';

class CandlestickChart extends StatefulWidget {
  final Stock stock;

  const CandlestickChart({Key? key, required this.stock}) : super(key: key);

  @override
  _CandlestickChartState createState() => _CandlestickChartState();
}

class _CandlestickChartState extends State<CandlestickChart> {
  List<CandleData> chartData = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _generateData();
  }

  void _generateData() {
    double basePrice = widget.stock.price;
    DateTime now = DateTime.now();

    for (int i = 30; i >= 0; i--) {
      double open = basePrice + (_random.nextDouble() - 0.5) * 10;
      double close = open + (_random.nextDouble() - 0.5) * 5;
      double high = max(open, close) + _random.nextDouble() * 3;
      double low = min(open, close) - _random.nextDouble() * 3;

      chartData.add(CandleData(
        now.subtract(Duration(days: i)),
        open,
        high,
        low,
        close,
      ));

      basePrice = close;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Price Chart (30 Days)',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Expanded(
          child: SfCartesianChart(
            plotAreaBorderWidth: 0,
            primaryXAxis: DateTimeAxis(
              majorGridLines: MajorGridLines(width: 0),
              dateFormat: DateFormat.MMMd(),
            ),
            primaryYAxis: NumericAxis(
              numberFormat: NumberFormat.currency(symbol: '\$', decimalDigits: 0),
              majorGridLines: MajorGridLines(width: 0.5, dashArray: [5, 5]),
            ),
            trackballBehavior: TrackballBehavior(
              enable: true,
              activationMode: ActivationMode.singleTap,
            ),
            zoomPanBehavior: ZoomPanBehavior(
              enablePinching: true,
              enablePanning: true,
            ),
            series: <CandleSeries<CandleData, DateTime>>[
              CandleSeries<CandleData, DateTime>(
                dataSource: chartData,
                xValueMapper: (CandleData data, _) => data.date,
                lowValueMapper: (CandleData data, _) => data.low,
                highValueMapper: (CandleData data, _) => data.high,
                openValueMapper: (CandleData data, _) => data.open,
                closeValueMapper: (CandleData data, _) => data.close,
                bearColor: Colors.red,
                bullColor: Colors.green,
                enableSolidCandles: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CandleData {
  final DateTime date;
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData(this.date, this.open, this.high, this.low, this.close);
}