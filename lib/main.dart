import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(PaperTradingApp());
}

class PaperTradingApp extends StatefulWidget {
  @override
  _PaperTradingAppState createState() => _PaperTradingAppState();
}

class _PaperTradingAppState extends State<PaperTradingApp> {
  ThemeMode _themeMode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Paper Trading Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      themeMode: _themeMode,
      home: DashboardScreen(onThemeToggle: _toggleTheme),
    );
  }
}
