import 'package:flutter/material.dart';
import 'screens/access_request_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/feedback_insights_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/view_report_screen.dart';
import 'screens/profile_screen.dart';
import 'models/app_state.dart';

void main() {
  runApp(const QoSMonitoringApp());
}

class QoSMonitoringApp extends StatelessWidget {
  const QoSMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QoS Monitoring Portal',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final AppState _appState = AppState();

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, child) {
        switch (_appState.currentScreen) {
          case Screen.accessRequest:
            return AccessRequestScreen(appState: _appState);
          case Screen.login:
            return LoginScreen(appState: _appState);
          case Screen.dashboard:
            return DashboardScreen(appState: _appState);
          case Screen.feedbackInsights:
            return FeedbackInsightsScreen(appState: _appState);
          case Screen.reports:
            return ReportsScreen(appState: _appState);
          case Screen.viewReport:
            return ViewReportScreen(appState: _appState);
          case Screen.profile:
            return ProfileScreen(appState: _appState);
        }
      },
    );
  }
}
