// screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../widgets/candlestick_chart.dart';
import '../widgets/portfolio_pie_chart.dart';
import '../widgets/trends_line_chart.dart';
import '../widgets/gain_loss_bar_chart.dart';
import '../widgets/radial_bar_chart.dart';
import 'stock_details_screen.dart';
import 'analytics_screen.dart';

class DashboardScreen extends StatefulWidget {
  final VoidCallback onThemeToggle;

  const DashboardScreen({Key? key, required this.onThemeToggle}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Timer? _timer;
  final Random _random = Random();

  double portfolioValue = 100000;
  double dayChange = 0;
  double dayChangePercent = 0;

  List<Stock> stocks = [
    Stock('AAPL', 'Apple Inc.', 150.0, 0, 0),
    Stock('GOOGL', 'Alphabet Inc.', 2800.0, 0, 0),
    Stock('TSLA', 'Tesla Inc.', 750.0, 0, 0),
    Stock('MSFT', 'Microsoft Corp.', 350.0, 0, 0),
    Stock('AMZN', 'Amazon.com Inc.', 3300.0, 0, 0),
  ];

  @override
  void initState() {
    super.initState();
    _startPriceSimulation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startPriceSimulation() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        for (var stock in stocks) {
          double changePercent = (_random.nextDouble() - 0.5) * 2;
          stock.changePercent = changePercent;
          stock.change = stock.price * changePercent / 100;
          stock.price += stock.change;
        }

        dayChange = stocks.fold(0, (sum, stock) => sum + stock.change * 100);
        dayChangePercent = dayChange / portfolioValue * 100;
        portfolioValue += dayChange;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Color(0xFF0D1117)
          : Colors.grey[50],
      appBar: AppBar(
        title: Text('Paper Trading Dashboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: widget.onThemeToggle,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPortfolioCard(),
            SizedBox(height: 20),
            _buildStocksList(),
            SizedBox(height: 20),
            _buildChartsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildPortfolioCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Portfolio Value', style: TextStyle(fontSize: 16, color: Colors.grey)),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '\$${portfolioValue.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(width: 8),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: dayChange >= 0 ? Colors.green.withOpacity(0.2) : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          dayChange >= 0 ? Icons.arrow_upward : Icons.arrow_downward,
                          color: dayChange >= 0 ? Colors.green : Colors.red,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${dayChange >= 0 ? '+' : ''}\$${dayChange.abs().toStringAsFixed(2)} (${dayChangePercent.toStringAsFixed(2)}%)',
                            style: TextStyle(
                              color: dayChange >= 0 ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStocksList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Watchlist', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 12),
        ...stocks.map((stock) => _buildStockTile(stock)).toList(),
      ],
    );
  }

  Widget _buildStockTile(Stock stock) {
    return Card(
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StockDetailsScreen(stock: stock),
            ),
          );
        },
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
          child: Text(
            stock.symbol[0],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(stock.symbol, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(stock.name, style: TextStyle(fontSize: 12)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '\$${stock.price.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '${stock.change >= 0 ? '+' : ''}${stock.changePercent.toStringAsFixed(2)}%',
              style: TextStyle(
                fontSize: 12,
                color: stock.change >= 0 ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartsGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Analytics', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton.icon(
              icon: Icon(Icons.analytics, size: 20),
              label: Text('View All'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AnalyticsScreen(stocks: stocks),
                  ),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 12),
        // Show a single featured chart
        Card(
          child: Container(
            height: 250,
            padding: EdgeInsets.all(16),
            child: TrendsLineChart(),
          ),
        ),
        SizedBox(height: 12),
        // Show summary cards with mini visualizations
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Win Rate',
                '65%',
                Colors.green,
                Icons.trending_up,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Best Performer',
                'AAPL +${stocks[0].changePercent.toStringAsFixed(1)}%',
                Colors.blue,
                Icons.star,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, Color color, IconData icon) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Stock {
  final String symbol;
  final String name;
  double price;
  double change;
  double changePercent;

  Stock(this.symbol, this.name, this.price, this.change, this.changePercent);
}