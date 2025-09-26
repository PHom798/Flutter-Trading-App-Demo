import 'package:flutter/material.dart';
import '../widgets/candlestick_chart.dart';
import 'dashboard_screen.dart';

class StockDetailsScreen extends StatelessWidget {
  final Stock stock;

  const StockDetailsScreen({Key? key, required this.stock}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${stock.symbol} - ${stock.name}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceCard(),
            SizedBox(height: 20),
            Card(
              child: Container(
                height: 400,
                padding: EdgeInsets.all(16),
                child: CandlestickChart(stock: stock),
              ),
            ),
            SizedBox(height: 20),
            _buildStatsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stock.symbol, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(stock.name, style: TextStyle(color: Colors.grey)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${stock.price.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  '${stock.change >= 0 ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
                  style: TextStyle(
                    fontSize: 16,
                    color: stock.change >= 0 ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            _buildStatRow('Open', '\$${(stock.price - stock.change).toStringAsFixed(2)}'),
            _buildStatRow('High', '\$${(stock.price * 1.02).toStringAsFixed(2)}'),
            _buildStatRow('Low', '\$${(stock.price * 0.98).toStringAsFixed(2)}'),
            _buildStatRow('Volume', '${(1000000 + stock.price * 1000).toStringAsFixed(0)}'),
            _buildStatRow('Market Cap', '\$${(stock.price * 1000000000 / 100).toStringAsFixed(0)}B'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey)),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
