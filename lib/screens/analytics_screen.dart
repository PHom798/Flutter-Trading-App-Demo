import 'package:flutter/material.dart';
import '../widgets/portfolio_pie_chart.dart';
import '../widgets/trends_line_chart.dart';
import '../widgets/gain_loss_bar_chart.dart';
import '../widgets/radial_bar_chart.dart';
import 'dashboard_screen.dart';

class AnalyticsScreen extends StatefulWidget {
  final List<Stock> stocks;

  const AnalyticsScreen({Key? key, required this.stocks}) : super(key: key);

  @override
  _AnalyticsScreenState createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: [
            Tab(text: 'Portfolio', icon: Icon(Icons.pie_chart)),
            Tab(text: 'Performance', icon: Icon(Icons.trending_up)),
            Tab(text: 'Win/Loss', icon: Icon(Icons.analytics)),
            Tab(text: 'Daily P&L', icon: Icon(Icons.bar_chart)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildChartPage(
            'Portfolio Allocation',
            'Your investments by sector',
            PortfolioPieChart(),
            _buildPortfolioInsights(),
          ),
          _buildChartPage(
            'Portfolio Performance',
            '7-day trend of your portfolio value',
            TrendsLineChart(),
            _buildPerformanceInsights(),
          ),
          _buildChartPage(
            'Win/Loss Analysis',
            'Your trading success rate',
            RadialBarChart(),
            _buildWinLossInsights(),
          ),
          _buildChartPage(
            'Daily Gains & Losses',
            'Today\'s performance by stock',
            GainLossBarChart(stocks: widget.stocks),
            _buildDailyPLInsights(),
          ),
        ],
      ),
    );
  }

  Widget _buildChartPage(String title, String subtitle, Widget chart, Widget insights) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(subtitle, style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20),
          Card(
            child: Container(
              height: 350,
              padding: EdgeInsets.all(16),
              child: chart,
            ),
          ),
          SizedBox(height: 20),
          insights,
        ],
      ),
    );
  }

  Widget _buildPortfolioInsights() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Insights', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _insightRow('Largest Holding', 'Technology (45%)'),
            _insightRow('Diversification', 'Good - 5 sectors'),
            _insightRow('Risk Level', 'Moderate'),
            _insightRow('Recommendation', 'add more' ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceInsights() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Performance Metrics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _insightRow('7-Day Return', '+2.5%'),
            _insightRow('Best Day', 'Thursday (+1.2%)'),
            _insightRow('Worst Day', 'Tuesday (-0.8%)'),
            _insightRow('Trend', 'Upward momentum'),
          ],
        ),
      ),
    );
  }

  Widget _buildWinLossInsights() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Trading Statistics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _insightRow('Total Trades', '47'),
            _insightRow('Winning Trades', '31 (65%)'),
            _insightRow('Average Win', '+\$245'),
            _insightRow('Average Loss', '-\$180'),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyPLInsights() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Today\'s Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _insightRow('Best Performer', widget.stocks.reduce((a, b) => a.changePercent > b.changePercent ? a : b).symbol),
            _insightRow('Worst Performer', widget.stocks.reduce((a, b) => a.changePercent < b.changePercent ? a : b).symbol),
            _insightRow('Positive Stocks', '${widget.stocks.where((s) => s.changePercent > 0).length}/5'),
            _insightRow('Market Sentiment', 'Mixed'),
          ],
        ),
      ),
    );
  }

  Widget _insightRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
