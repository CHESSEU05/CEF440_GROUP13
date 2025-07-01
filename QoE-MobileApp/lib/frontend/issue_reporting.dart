import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

// Light theme color palette
const Color primaryColor = Color(0xFF4A90E2);
const Color primaryDarkColor = Color(0xFF3A7BC8);
const Color cardBackgroundColor = Colors.white;
const Color surfaceColor = Color(0xFFF5F7FA);
const Color textColor = Color(0xFF2A3B5C);
const Color subtleTextColor = Color(0xFF6D7A8D);
const Color errorColor = Color(0xFFE53935);
const Color successColor = Color(0xFF43A047);
const Color borderColor = Color(0xFFE0E0E0);

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

  Map<String, dynamic> toJson() {
    return {
      'jitter': jitter,
      'networkType': networkType,
      'signalStrength': signalStrength,
      'packetLoss': packetLoss,
      'bandwidth': bandwidth,
      'latency': latency,
      'timestamp': timestamp.toIso8601String(),
    };
  }
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
        final kbps = bitsPerSecond / 1000;
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

class IssueReportingFormDialog extends StatefulWidget {
  @override
  _IssueReportingFormDialogState createState() => _IssueReportingFormDialogState();
}

class _IssueReportingFormDialogState extends State<IssueReportingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();
  final _issueDetailsController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _selectedOperator;
  String? _selectedIssueType;
  String? _selectedActivity;
  bool _isSubmitting = false;
  Position? _currentPosition;
  NetworkMetrics? _networkMetrics;

  final List<String> _operators = ['MTN', 'ORANGE', 'CAMTEL', 'Nexttel'];
  final List<String> _issueTypes = ['No Service', 'Poor Signal', 'Slow Internet Speed', 'Call Drop', 'Others'];
  final List<String> _activities = [
    'Social Media (Instagram, Facebook, X...)',
    'Video Streaming (YouTube, Netflix...)',
    'Online Gaming',
    'Messaging (WhatsApp, SMS...)',
    'Online Work (Zoom, Google Meet...)',
    'Web Browse',
    'Others'
  ];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return;
      }

      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _submitIssueReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      _formKey.currentState!.save();

      // Fetch current network metrics
      _networkMetrics = await NetworkMonitoringService.getCurrentMetrics();

      // Get current user ID from Firebase Auth
      String userId = _auth.currentUser?.uid ?? 'anonymous_user';

      // In a real application, you might fetch more user details from your database
      // using this userId. For example:
      // DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      // String? userName = userDoc.data()?['name'];
      // String? userEmail = userDoc.data()?['email'];

      Map<String, dynamic> issueData = {
        'userId': userId,
        // You can add other user details fetched from your database here
        // 'userName': userName,
        // 'userEmail': userEmail,
        'timestamp': FieldValue.serverTimestamp(),
        'networkOperator': _selectedOperator,
        'issueType': _selectedIssueType,
        'activityDuringIssue': _selectedActivity,
        'issueDescription': _issueDetailsController.text.trim(),
        'location': _currentPosition != null ? {
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'accuracy': _currentPosition!.accuracy,
        } : null,
        'deviceInfo': {
          'platform': 'mobile', // You can get more detailed device info if needed
          'appVersion': '1.0.0', // Replace with actual app version
        },
        'networkMetrics': _networkMetrics?.toJson(), // Attach network metrics
        'status': 'reported',
        'priority': _calculatePriority(),
        'submissionSource': 'issue_report_form',
      };

      await _firestore.collection('userIssues').add(issueData);

      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Issue reported successfully!'),
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } catch (e) {
      print('Error submitting issue report: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit issue report. Please try again.'),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  String _calculatePriority() {
    switch (_selectedIssueType) {
      case 'No Service':
        return 'high';
      case 'Call Drop':
        return 'high';
      case 'Poor Signal':
        return 'medium';
      case 'Slow Internet Speed':
        return 'medium';
      default:
        return 'low';
    }
  }

  Widget _buildDropdown({
    required String label,
    required String? currentValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSans(
            color: textColor.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: surfaceColor,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: errorColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: errorColor, width: 1.5),
              ),
            ),
            dropdownColor: Colors.white,
            style: GoogleFonts.notoSans(color: textColor),
            value: currentValue,
            isExpanded: true,
            hint: Text(
              'Select an option',
              style: GoogleFonts.notoSans(color: subtleTextColor),
            ),
            icon: Icon(Icons.arrow_drop_down, color: subtleTextColor),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.notoSans(color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: _isSubmitting ? null : onChanged,
            validator: (value) => value == null ? 'This field is required' : null,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _issueDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Report Network Issue',
                      style: GoogleFonts.notoSans(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: subtleTextColor),
                      onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Help us improve by reporting network problems you encounter',
                  style: GoogleFonts.notoSans(
                    color: subtleTextColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 24),
                _buildDropdown(
                  label: 'Network Operator',
                  currentValue: _selectedOperator,
                  items: _operators,
                  onChanged: (value) => setState(() => _selectedOperator = value),
                ),
                _buildDropdown(
                  label: 'Issue Type',
                  currentValue: _selectedIssueType,
                  items: _issueTypes,
                  onChanged: (value) => setState(() => _selectedIssueType = value),
                ),
                _buildDropdown(
                  label: 'Activity During Issue',
                  currentValue: _selectedActivity,
                  items: _activities,
                  onChanged: (value) => setState(() => _selectedActivity = value),
                ),
                Text(
                  'Issue Description',
                  style: GoogleFonts.notoSans(
                    color: textColor.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: _issueDetailsController,
                  focusNode: _focusNode,
                  enabled: !_isSubmitting,
                  style: GoogleFonts.notoSans(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Describe what happened...',
                    hintStyle: GoogleFonts.notoSans(color: subtleTextColor),
                    filled: true,
                    fillColor: surfaceColor,
                    contentPadding: EdgeInsets.all(16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: borderColor, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: primaryColor, width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: errorColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: errorColor, width: 1.5),
                    ),
                  ),
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe the issue';
                    }
                    if (value.length < 10) {
                      return 'Please provide more details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                Text(
                  'Provide as much detail as possible about when and where the issue occurred',
                  style: GoogleFonts.notoSans(
                    color: subtleTextColor,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isSubmitting
                          ? subtleTextColor.withOpacity(0.6)
                          : primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: _isSubmitting ? null : _submitIssueReport,
                    child: _isSubmitting
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Submitting...',
                          style: GoogleFonts.notoSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                        : Text(
                      'Submit Report',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}