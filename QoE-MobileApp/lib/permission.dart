import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PermissionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Removed AppBar completely
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Logo Section - Replace with your actual logo
            Center(
              child: Image.asset(
                'lib/assets/app-logo-long.png', // Update with your logo path
                width: 400,
                height: 50,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Color(0xFF1A80E5).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 40),

            // Permission Request Title Section
            Center(
              child: Text(
                'Permission Request',
                style: GoogleFonts.notoSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Container(
                height: 5,
                width: 400,
                color: Color(0xFF1A80E5), // Using our standard blue
              ),
            ),
            SizedBox(height: 20),

            // Instruction Text
            Center(
              child: Text(
                'We need your permission to collect data for the following purposes:',
                style: GoogleFonts.notoSans(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 30),

            // Permission Items
            Expanded(
              child: ListView(
                children: [
                  PermissionItem(
                    icon: Icons.location_on,
                    title: 'Location Permission',
                    description: 'We use your location to map network experience to geographic regions.',
                  ),
                  PermissionItem(
                    icon: Icons.info_outline,
                    title: 'Phone State / Network Info',
                    description: 'We use this data to monitor network performance and ensure user experience.',
                  ),
                  PermissionItem(
                    icon: Icons.cloud_download,
                    title: 'Background Data Collection',
                    description: 'Collects data silently in the background. The app consumes minimal battery.',
                  ),
                  PermissionItem(
                    icon: Icons.storage,
                    title: 'Storage Access',
                    description: 'Allow the app to store (encrypted) data locally before uploading.',
                  ),
                  PermissionItem(
                    icon: Icons.analytics,
                    title: 'Usage Stats Permission',
                    description: 'To track the app\'s performance and internet behaviour.',
                  ),
                  PermissionItem(
                    icon: Icons.notifications,
                    title: 'Notification Permission',
                    description: 'To send reminders and feedback requests.',
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Accept Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A80E5), // Using our standard blue
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Accept & Continue',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const PermissionItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.grey[600],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.notoSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}