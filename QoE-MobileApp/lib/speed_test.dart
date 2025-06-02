import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';

// Light theme color palette (reusing from previous example)
const Color primaryColor = Color(0xFF4A90E2);
const Color primaryDarkColor = Color(0xFF3A7BC8);
const Color cardBackgroundColor = Colors.white;
const Color surfaceColor = Color(0xFFF5F7FA);
const Color textColor = Color(0xFF2A3B5C);
const Color subtleTextColor = Color(0xFF6D7A8D);
const Color errorColor = Color(0xFFE53935);
const Color successColor = Color(0xFF43A047);
const Color borderColor = Color(0xFFE0E0E0);
const Color accentColor = Color(0xFF00BCD4); // Example accent color

class SpeedTestDialog extends StatefulWidget {
  @override
  _SpeedTestDialogState createState() => _SpeedTestDialogState();
}

class _SpeedTestDialogState extends State<SpeedTestDialog> {
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  String _connectionQuality = 'Testing...';
  bool _isTesting = false;

  @override
  void initState() {
    super.initState();
    _startSpeedTest();
  }

  Future<void> _startSpeedTest() async {
    setState(() {
      _isTesting = true;
      _downloadSpeed = 0.0;
      _uploadSpeed = 0.0;
      _connectionQuality = 'Testing...';
    });

    // Simulate download test
    await Future.delayed(Duration(seconds: 2));
    final randomDownload = Random().nextDouble() * 50; // Simulate up to 50 Mbps
    setState(() {
      _downloadSpeed = double.parse(randomDownload.toStringAsFixed(2));
    });

    await Future.delayed(Duration(seconds: 1));

    // Simulate upload test
    final randomUpload = Random().nextDouble() * 20; // Simulate up to 20 Mbps
    setState(() {
      _uploadSpeed = double.parse(randomUpload.toStringAsFixed(2));
    });

    // Determine connection quality (simplified)
    String quality;
    if (_downloadSpeed > 30 && _uploadSpeed > 10) {
      quality = 'Excellent';
    } else if (_downloadSpeed > 15 && _uploadSpeed > 5) {
      quality = 'Good';
    } else if (_downloadSpeed > 5 && _uploadSpeed > 2) {
      quality = 'Fair';
    } else {
      quality = 'Poor';
    }

    setState(() {
      _connectionQuality = quality;
      _isTesting = false;
    });
  }

  Widget _buildSpeedIndicator({required String title, required double speed, required String unit}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.notoSans(
            color: subtleTextColor,
            fontSize: 14,
          ),
        ),
        SizedBox(height: 4),
        Text(
          '${speed.toStringAsFixed(2)} $unit',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Speed Test',
                  style: GoogleFonts.notoSans(
                    color: textColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: subtleTextColor),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            SizedBox(height: 16),
            _isTesting
                ? Column(
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
                SizedBox(height: 16),
                Text(
                  'Testing your connection...',
                  style: GoogleFonts.notoSans(color: subtleTextColor),
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpeedIndicator(title: 'Download Speed', speed: _downloadSpeed, unit: 'Mbps'),
                SizedBox(height: 16),
                _buildSpeedIndicator(title: 'Upload Speed', speed: _uploadSpeed, unit: 'Mbps'),
                SizedBox(height: 24),
                Text(
                  'Connection Quality:',
                  style: GoogleFonts.notoSans(
                    color: textColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  _connectionQuality,
                  style: GoogleFonts.notoSans(
                    color: _connectionQuality == 'Excellent'
                        ? successColor
                        : _connectionQuality == 'Poor'
                        ? errorColor
                        : accentColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: _startSpeedTest,
                    child: Text(
                      'Test Again',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
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
}