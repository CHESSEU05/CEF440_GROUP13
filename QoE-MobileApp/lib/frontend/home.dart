import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'issue_reporting.dart';
import 'my_activity.dart';
import 'settings.dart';
import 'feedback_survey.dart';
import 'speed_test.dart';
import 'star_rating_widget.dart';

// Define your primary color (adjust as needed from the image)
const Color primaryColor = Color(0xFF4A90E2);
const Color scaffoldBackgroundColor = Color(0xFFF5F7FA);
const Color cardBackgroundColor = Colors.white;
const Color metricItemColor = Color(0xFF2A3B5C);
const Color realTimeStatusCardColor = Colors.white;
const Color realTimeStatusTitleColor = primaryColor;
const Color realTimeStatusDividerColor = primaryColor;
const Color realTimeStatusMetricsTitleColor = Colors.black87;
const Color metricIconColor = Colors.white70;
const Color metricTextColor = Colors.white;
const Color quickActionTitleColor = primaryColor;
const Color quickActionDescriptionColor = Colors.black;
const Color quickActionArrowColor = Color(0xFF888888);
const Color bottomNavBackgroundColor = Colors.white;
const Color bottomNavSelectedItemColor = primaryColor;
const Color bottomNavUnselectedItemColor = Color(0xFF888888);

class NetworkMetrics {
  final double jitter;
  final String networkType;
  final String signalStrength;
  final double packetLoss;
  final double bandwidth;
  final double latency;
  final DateTime timestamp;

  NetworkMetrics({
    required this.jitter,
    required this.networkType,
    required this.signalStrength,
    required this.packetLoss,
    required this.bandwidth,
    required this.latency,
    required this.timestamp,
  });
}

class NetworkMonitoringService {
  static const String testUrl = 'http://httpbin.org/get';
  static const String speedTestUrl = 'http://httpbin.org/get';
  static const int pingCount = 3;

  static Future<NetworkMetrics> getCurrentMetrics() async {
    try {
      // Get connectivity info
      final connectivity = Connectivity();
      final connectivityResult = await connectivity.checkConnectivity();

      // Test latency with multiple pings
      List<double> latencies = [];
      for (int i = 0; i < pingCount; i++) {
        final latency = await _measureLatency();
        if (latency > 0) latencies.add(latency);
        if (i < pingCount - 1) await Future.delayed(Duration(milliseconds: 100));
      }

      // Calculate jitter (variation in latency)
      double jitter = 0.0;
      double avgLatency = 0.0;
      if (latencies.isNotEmpty) {
        avgLatency = latencies.reduce((a, b) => a + b) / latencies.length;
        if (latencies.length > 1) {
          double variance = latencies
              .map((l) => (l - avgLatency) * (l - avgLatency))
              .reduce((a, b) => a + b) / latencies.length;
          jitter = sqrt(variance);
        }
      }

      // Test bandwidth
      final bandwidth = await _measureBandwidth();

      // Measure packet loss (requires more advanced techniques)
      // For a more accurate implementation, consider using platform-specific APIs
      // or sending ICMP packets. This example still simulates it.
      final packetLoss = _simulatePacketLoss();

      // Get signal strength (requires platform-specific implementation)
      // Consider using plugins like flutter_sim_card or network_info_plus for more accurate results.
      final signalStrength = await _getSignalStrength(connectivityResult);

      return NetworkMetrics(
        jitter: double.parse(jitter.toStringAsFixed(1)),
        networkType: _getNetworkTypeString(connectivityResult),
        signalStrength: signalStrength,
        packetLoss: packetLoss,
        bandwidth: bandwidth,
        latency: avgLatency > 0 ? double.parse(avgLatency.toStringAsFixed(0)) : 0,
        timestamp: DateTime.now(),
      );
    } catch (e) {
      // Return default values on error
      return NetworkMetrics(
        jitter: 0.0,
        networkType: 'Unknown',
        signalStrength: 'N/A',
        packetLoss: 0.0,
        bandwidth: 0.0,
        latency: 0.0,
        timestamp: DateTime.now(),
      );
    }
  }

  static Future<double> _measureLatency() async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await http.get(
        Uri.parse(testUrl),
      ).timeout(Duration(seconds: 5));
      stopwatch.stop();

      if (response.statusCode == 200) {
        return stopwatch.elapsedMilliseconds.toDouble();
      }
    } catch (e) {
      // Handle timeout or network errors
    }
    return 0.0;
  }

  static Future<double> _measureBandwidth() async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await http.get(
        Uri.parse(speedTestUrl),
      ).timeout(Duration(seconds: 10));
      stopwatch.stop();

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes.length;
        final seconds = stopwatch.elapsedMilliseconds / 1000.0;
        final bitsPerSecond = (bytes * 8) / seconds;
        final kbps = bitsPerSecond / 1024;
        return double.parse(kbps.toStringAsFixed(0));
      }
    } catch (e) {
      // Handle errors
    }
    return 0.0;
  }

  static String _getNetworkTypeString(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
      // More detailed mobile network type detection usually requires platform-specific code.
        return 'Mobile';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      default:
        return 'No Connection';
    }
  }

  static Future<String> _getSignalStrength(ConnectivityResult result) async {
    // This is a placeholder as getting accurate signal strength requires
    // platform-specific implementations. You might need to use plugins like:
    // - `flutter_sim_card` (for mobile signal strength)
    // - `network_info_plus` (can provide Wi-Fi signal strength on some platforms)

    // For now, we will simulate based on the connection type.
    if (result == ConnectivityResult.wifi) {
      final random = Random();
      final strength = -30 - random.nextInt(40); // Simulate Wi-Fi strength
      return '${strength} dBm';
    } else if (result == ConnectivityResult.mobile) {
      final random = Random();
      final strength = -50 - random.nextInt(50); // Simulate mobile strength
      return '${strength} dBm';
    } else {
      return 'N/A';
    }
  }

  static double _simulatePacketLoss() {
    // For a real implementation, you would typically send multiple packets
    // and check how many are lost. This often involves using the `ping` command
    // or platform-specific network APIs.
    final random = Random();
    return double.parse((random.nextDouble() * 2).toStringAsFixed(1));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = <Widget>[];

  @override
  void initState() {
    super.initState();
    _widgetOptions.addAll([
      _HomeScreenContent(
        onReportIssue: showReportIssueForm,
        onSubmitFeedback: showSubmitFeedbackForm,
      ),
      MyActivityScreen(),
      SettingsScreen(),
    ]);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void showReportIssueForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return IssueReportingFormDialog();
      },
    );
  }

  void showSubmitFeedbackForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return FeedbackSurveyDialog();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bottomNavBackgroundColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'My Activity',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: bottomNavSelectedItemColor,
        unselectedItemColor: bottomNavUnselectedItemColor,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.notoSans(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: GoogleFonts.notoSans(fontSize: 12),
      ),
    );
  }
}

class _HomeScreenContent extends StatefulWidget {
  final Function(BuildContext) onReportIssue;
  final Function(BuildContext) onSubmitFeedback;

  const _HomeScreenContent({
    required this.onReportIssue,
    required this.onSubmitFeedback,
  });

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<_HomeScreenContent> {
  NetworkMetrics? _currentMetrics;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _updateNetworkMetrics();
  }

  Future<void> _updateNetworkMetrics() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final metrics = await NetworkMonitoringService.getCurrentMetrics();
      if (mounted) {
        setState(() {
          _currentMetrics = metrics;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme);
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Home',
          style: GoogleFonts.notoSans(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _updateNetworkMetrics,
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(), // Ensure scroll even when content is short
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRealTimeNetworkStatusCard(textTheme),
                SizedBox(height: 20),
                _buildQuickActionsSection(context, textTheme),
                SizedBox(height: 20),
                _buildLocationBasedInsights(textTheme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRealTimeNetworkStatusCard(TextTheme textTheme) {
    return Card(
      color: realTimeStatusCardColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Real-time Network Status',
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(width: 8),
                if (_isLoading)
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                    ),
                  )
                else
                  Icon(
                    Icons.refresh,
                    color: Colors.green,
                    size: 16,
                  ),
              ],
            ),
            if (_currentMetrics?.timestamp != null)
              Text(
                'Last updated: ${_formatTime(_currentMetrics!.timestamp)}',
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            Divider(color: realTimeStatusDividerColor, thickness: 2, height: 20),
            SizedBox(height: 10),
            _buildMetricItem(
                Icons.waves,
                'Jitter',
                _isLoading ? '--' : '${_currentMetrics?.jitter ?? 0} ms',
                textTheme
            ),
            _buildMetricItem(
                Icons.wifi,
                'Network Type',
                _isLoading ? '--' : _currentMetrics?.networkType ?? 'Unknown',
                textTheme
            ),
            _buildMetricItem(
                Icons.signal_cellular_alt,
                'Signal Strength',
                _isLoading ? '--' : _currentMetrics?.signalStrength ?? 'N/A',
                textTheme
            ),
            _buildMetricItem(
                Icons.sync_problem_outlined,
                'Packet Loss',
                _isLoading ? '--' : '${_currentMetrics?.packetLoss ?? 0}%',
                textTheme
            ),
            _buildMetricItem(
                Icons.download_outlined,
                'Bandwidth',
                _isLoading ? '--' : '${_currentMetrics?.bandwidth ?? 0} Kbps',
                textTheme
            ),
            _buildMetricItem(
                Icons.timer_outlined,
                'Latency',
                _isLoading ? '--' : '${_currentMetrics?.latency ?? 0} ms',
                textTheme
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
  }

  Widget _buildMetricItem(IconData icon, String title, String value, TextTheme textTheme) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.0),
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: metricItemColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: metricIconColor, size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: textTheme.titleSmall?.copyWith(
                color: metricTextColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: textTheme.titleSmall?.copyWith(
              color: metricTextColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionsSection(BuildContext context, TextTheme textTheme) {
    return Card(
      color: cardBackgroundColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Quick Actions',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: quickActionTitleColor,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(color: quickActionTitleColor, thickness: 2, height: 20),
            SizedBox(height: 10),
            _buildQuickActionItem(
              context: context,
              icon: Icons.report_problem_outlined,
              title: 'Report an Issue',
              description: 'Connection issue, speed, call drop, etc',
              textTheme: textTheme,
              onTap: () => widget.onReportIssue(context),
            ),
            SizedBox(height: 12),
            _buildQuickActionItem(
              context: context,
              icon: Icons.feedback_outlined,
              title: 'Submit Feedback',
              description: 'Feedback about the network quality',
              textTheme: textTheme,
              onTap: () => widget.onSubmitFeedback(context),
            ),
            SizedBox(height: 12),
            _buildQuickActionItem(
              context: context,
              icon: Icons.speed,
              title: 'Speed Test',
              description: 'Test your current connection speed',
              textTheme: textTheme,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => SpeedTestDialog(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required TextTheme textTheme,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Icon(icon, color: primaryColor, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: quickActionTitleColor,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    description,
                    style: textTheme.bodySmall?.copyWith(
                      color: quickActionDescriptionColor,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: quickActionArrowColor, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationBasedInsights(TextTheme textTheme) {
    return Card(
      color: cardBackgroundColor,
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Location-Based Insights',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(color: primaryColor, thickness: 2, height: 20),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.location_on, color: primaryColor, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Location Quality',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Good coverage in your area',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Good',
                    style: textTheme.bodySmall?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.trending_up, color: Colors.blue, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Peak Hours Analysis',
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Best performance: 2 AM - 6 AM',
                        style: textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}