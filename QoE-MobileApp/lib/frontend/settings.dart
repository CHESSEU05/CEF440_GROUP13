import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


// Define your primary color (adjust as needed)
const Color primaryColor = Color(0xFF4A90E2);
const Color bottomNavBackgroundColor = Color(0xFF1E1E1E);
const Color bottomNavSelectedItemColor = primaryColor;
const Color bottomNavUnselectedItemColor = Color(0xFF888888);

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedIndex = 2; // To keep "Settings" selected

  // Toggle states for notifications
  bool _pushNotifications = true;
  bool _issueResolutionAlerts = false;
  bool _networkQualityAlerts = true;
  bool _maintenanceAlerts = false;
  bool _weeklyReports = true;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF4A90E2),
        title: Text(
          'Settings & Notifications',
          style: GoogleFonts.notoSans(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // User Profile Section
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: primaryColor.withOpacity(0.1),
                        child: Icon(
                          Icons.person,
                          color: primaryColor,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User Profile',
                            style: GoogleFonts.notoSans(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'View your account settings',
                            style: GoogleFonts.notoSans(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildInfoRow(Icons.badge, 'User ID:', 'OQiXhaGLlAGtPIe3YZ0U'),
                  SizedBox(height: 12),
                  _buildInfoRow(Icons.phone, 'Mobile:', '(237) 699 53 89 39'),
                ],
              ),
            ),

            // Notification Preferences Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notifications, color: primaryColor, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Notification Preferences',
                        style: GoogleFonts.notoSans(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _buildToggleOption(
                    'Push Notifications',
                    'Receive general app notifications',
                    _pushNotifications,
                        (value) => setState(() => _pushNotifications = value),
                  ),
                  _buildToggleOption(
                    'Issue Resolution Alerts',
                    'Get notified when network issues are resolved',
                    _issueResolutionAlerts,
                        (value) => setState(() => _issueResolutionAlerts = value),
                  ),
                  _buildToggleOption(
                    'Network Quality Alerts',
                    'Alerts about network quality changes',
                    _networkQualityAlerts,
                        (value) => setState(() => _networkQualityAlerts = value),
                  ),
                  _buildToggleOption(
                    'Maintenance Alerts',
                    'Notifications about scheduled maintenance',
                    _maintenanceAlerts,
                        (value) => setState(() => _maintenanceAlerts = value),
                  ),
                  _buildToggleOption(
                    'Weekly Reports',
                    'Receive weekly network performance summaries',
                    _weeklyReports,
                        (value) => setState(() => _weeklyReports = value),
                    isLast: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Notification History Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.history, color: primaryColor, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Notification History',
                        style: GoogleFonts.notoSans(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildNotificationItem(
                    Icons.check_circle_outline,
                    Colors.green,
                    '6/17, 9:20 AM',
                    'Read',
                    'Your network quality has improved from fair to good.',
                    true,
                  ),
                  Divider(height: 24, color: Colors.grey[200]),
                  _buildNotificationItem(
                    Icons.info_outline,
                    Colors.blue,
                    '6/16, 11:20 PM',
                    'Unread',
                    'Your network speed has been improved. Enjoy!',
                    false,
                  ),
                  Divider(height: 24, color: Colors.grey[200]),
                  _buildNotificationItem(
                    Icons.warning_outlined,
                    Colors.orange,
                    '6/15, 2:15 PM',
                    'Read',
                    'Network maintenance scheduled for tonight.',
                    true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Help and Documentation Section
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.help_outline, color: primaryColor, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Help and Documentation',
                        style: GoogleFonts.notoSans(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  _buildHelpItem(
                    Icons.quiz,
                    'Understanding Report Symbols',
                    'Learn about app navigation and report symbols',
                  ),
                  _buildHelpItem(
                    Icons.support_agent,
                    'Contact Support',
                    'Get help from our support team',
                  ),
                  _buildHelpItem(
                    Icons.description,
                    'User Guide',
                    'Complete guide to using the app',
                    isLast: true,
                  ),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Logout Button
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16.0),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red.withOpacity(0.3)),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Logout',
                      style: GoogleFonts.notoSans(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildToggleOption(
      String title,
      String subtitle,
      bool value,
      ValueChanged<bool> onChanged, {
        bool isLast = false,
      }) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: primaryColor,
              activeTrackColor: primaryColor.withOpacity(0.3),
              inactiveThumbColor: Colors.grey[400],
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(
      IconData icon,
      Color iconColor,
      String time,
      String status,
      String message,
      bool isRead,
      ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 20),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    time,
                    style: GoogleFonts.notoSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isRead ? Colors.grey[200] : primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status,
                      style: GoogleFonts.notoSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: isRead ? Colors.grey[600] : primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 4),
              Text(
                message,
                style: GoogleFonts.notoSans(
                  fontSize: 13,
                  color: Colors.grey[700],
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String subtitle, {bool isLast = false}) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
      child: InkWell(
        onTap: () {
          // Handle help item tap
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: primaryColor, size: 22),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Logout',
            style: GoogleFonts.notoSans(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: GoogleFonts.notoSans(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.notoSans(color: Colors.grey[600]),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // Redirect to LoginPage and remove all previous routes
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                      (Route<dynamic> route) => false, // This removes all previous routes
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(
                'Logout',
                style: GoogleFonts.notoSans(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }
}