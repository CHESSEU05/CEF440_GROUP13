import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PermissionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final String phone = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Image.asset(
                'lib/assets/app-logo-long.png',
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
                color: Color(0xFF1A80E5),
              ),
            ),
            SizedBox(height: 20),
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
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  Map<Permission, PermissionStatus> statuses = await [
                    Permission.location,
                    Permission.phone,
                    Permission.storage,
                    Permission.notification,
                    Permission.activityRecognition,
                  ].request();

                  bool allGranted = statuses.values.every((status) => status.isGranted);

                  if (allGranted) {
                    await FirebaseFirestore.instance
                        .collection('users')
                        .where('phone', isEqualTo: phone)
                        .limit(1)
                        .get()
                        .then((snapshot) {
                      if (snapshot.docs.isNotEmpty) {
                        snapshot.docs.first.reference.update({
                          'permissionsGranted': true,
                        });
                      }
                    });
                    Navigator.pushNamed(context, '/home');
                  } else {
                    bool permanentlyDenied = statuses.values.any((status) => status.isPermanentlyDenied);

                    if (permanentlyDenied) {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Permissions Required"),
                          content: Text("Some permissions are permanently denied. Please enable them in settings."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () {
                                openAppSettings();
                                Navigator.of(context).pop();
                              },
                              child: Text("Open Settings"),
                            ),
                          ],
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please grant all permissions to continue.'),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1A80E5),
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
