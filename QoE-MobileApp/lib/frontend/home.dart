import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'issue_reporting.dart';
import 'my_activity.dart';
import 'settings.dart';
import 'feedback_survey.dart';
import 'speed_test.dart';
import 'star_rating_widget.dart';

// Define your primary color (adjust as needed from the image)
const Color primaryColor = Color(0xFF4A90E2);
const Color scaffoldBackgroundColor = Color(0xFFF5F7FA); // Light contrasting background
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

  // Method to show the Issue Reporting Form Dialog
  void showReportIssueForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return IssueReportingFormDialog();
      },
    );
  }

  // Method to show the Feedback Survey Form Dialog
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
    final textTheme = GoogleFonts.notoSansTextTheme(Theme.of(context).textTheme);

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

class _HomeScreenContent extends StatelessWidget {
  final Function(BuildContext) onReportIssue;
  final Function(BuildContext) onSubmitFeedback;

  const _HomeScreenContent({
    required this.onReportIssue,
    required this.onSubmitFeedback,
  });

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
        child: SingleChildScrollView(
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
            Text(
              'Real-time Network Status',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            Divider(color: realTimeStatusDividerColor, thickness: 2, height: 20),
            SizedBox(height: 10),
            _buildMetricItem(Icons.waves, 'Jitter', '5 ms', textTheme),
            _buildMetricItem(Icons.wifi, 'Network Type', '4G LTE', textTheme),
            _buildMetricItem(Icons.signal_cellular_alt, 'Signal Strength', '-75 dBm', textTheme),
            _buildMetricItem(Icons.sync_problem_outlined, 'Packet Loss', '0.1%', textTheme),
            _buildMetricItem(Icons.download_outlined, 'Bandwidth', '870 Kbps', textTheme),
            _buildMetricItem(Icons.timer_outlined, 'Latency', '25 ms', textTheme),
          ],
        ),
      ),
    );
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
              onTap: () => onReportIssue(context),
            ),
            SizedBox(height: 12),
            _buildQuickActionItem(
              context: context,
              icon: Icons.feedback_outlined,
              title: 'Submit Feedback',
              description: 'Feedback about the network quality',
              textTheme: textTheme,
              onTap: () => onSubmitFeedback(context),
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

  Widget _buildScoreItem(String label, String score, Color color, TextTheme textTheme) {
    return Column(
      children: [
        Text(
          score,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
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