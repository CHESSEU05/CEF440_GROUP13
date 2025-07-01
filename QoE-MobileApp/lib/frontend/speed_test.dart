import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

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
const Color accentColor = Color(0xFF00BCD4);

class SpeedTestDialog extends StatefulWidget {
  @override
  _SpeedTestDialogState createState() => _SpeedTestDialogState();
}

class _SpeedTestDialogState extends State<SpeedTestDialog> {
  double _downloadSpeed = 0.0;
  double _uploadSpeed = 0.0;
  double _ping = 0.0;
  String _connectionQuality = 'Testing...';
  bool _isTesting = false;
  String _currentTest = '';

  // Test URLs - you can replace these with your preferred test servers
  static const String downloadTestUrl = 'http://speed.hetzner.de/100MB.bin';
  static const String uploadTestUrl = 'http://httpbin.org/post';
  static const String pingTestUrl = 'http://httpbin.org/get';

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
      _ping = 0.0;
      _connectionQuality = 'Testing...';
    });

    try {
      // Test ping first
      await _testPing();

      // Test download speed
      await _testDownloadSpeed();

      // Test upload speed
      await _testUploadSpeed();

      // Determine connection quality
      _determineConnectionQuality();
    } catch (e) {
      setState(() {
        _connectionQuality = 'Error: ${e.toString()}';
        _isTesting = false;
      });
    }
  }

  Future<void> _testPing() async {
    setState(() {
      _currentTest = 'Testing ping...';
    });

    try {
      final stopwatch = Stopwatch()..start();
      final response = await http.get(
        Uri.parse(pingTestUrl),
      ).timeout(Duration(seconds: 10));

      stopwatch.stop();

      if (response.statusCode == 200) {
        setState(() {
          _ping = stopwatch.elapsedMilliseconds.toDouble();
        });
      }
    } catch (e) {
      setState(() {
        _ping = -1; // Indicate ping test failed
      });
    }
  }

  Future<void> _testDownloadSpeed() async {
    setState(() {
      _currentTest = 'Testing download speed...';
    });

    try {
      final stopwatch = Stopwatch()..start();

      final response = await http.get(
        Uri.parse(downloadTestUrl),
      ).timeout(Duration(seconds: 30));

      stopwatch.stop();

      if (response.statusCode == 200) {
        final bytes = response.bodyBytes.length;
        final seconds = stopwatch.elapsedMilliseconds / 1000.0;
        final bitsPerSecond = (bytes * 8) / seconds;
        final mbps = bitsPerSecond / (1024);

        setState(() {
          _downloadSpeed = double.parse(mbps.toStringAsFixed(2));
        });
      }
    } catch (e) {
      setState(() {
        _downloadSpeed = -1; // Indicate download test failed
      });
    }
  }

  Future<void> _testUploadSpeed() async {
    setState(() {
      _currentTest = 'Testing upload speed...';
    });

    try {
      // Create test data (1MB)
      final testData = Uint8List(1024 * 1024);
      for (int i = 0; i < testData.length; i++) {
        testData[i] = i % 256;
      }

      final stopwatch = Stopwatch()..start();

      final response = await http.post(
        Uri.parse(uploadTestUrl),
        body: testData,
        headers: {'Content-Type': 'application/octet-stream'},
      ).timeout(Duration(seconds: 30));

      stopwatch.stop();

      if (response.statusCode == 200) {
        final bytes = testData.length;
        final seconds = stopwatch.elapsedMilliseconds / 1000.0;
        final bitsPerSecond = (bytes * 8) / seconds;
        final mbps = bitsPerSecond / (1024 * 1024);

        setState(() {
          _uploadSpeed = double.parse(mbps.toStringAsFixed(2));
        });
      }
    } catch (e) {
      setState(() {
        _uploadSpeed = -1; // Indicate upload test failed
      });
    }
  }

  void _determineConnectionQuality() {
    String quality;

    if (_downloadSpeed < 0 || _uploadSpeed < 0) {
      quality = 'Test Failed';
    } else if (_downloadSpeed > 30 && _uploadSpeed > 10 && _ping < 50) {
      quality = 'Excellent';
    } else if (_downloadSpeed > 15 && _uploadSpeed > 5 && _ping < 100) {
      quality = 'Good';
    } else if (_downloadSpeed > 5 && _uploadSpeed > 2 && _ping < 200) {
      quality = 'Fair';
    } else {
      quality = 'Poor';
    }

    setState(() {
      _connectionQuality = quality;
      _isTesting = false;
      _currentTest = '';
    });
  }

  Widget _buildSpeedIndicator({
    required String title,
    required double speed,
    required String unit,
  }) {
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
          speed < 0 ? 'Failed' : '${speed.toStringAsFixed(2)} $unit',
          style: GoogleFonts.notoSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: speed < 0 ? errorColor : textColor,
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
                  _currentTest.isEmpty ? 'Initializing test...' : _currentTest,
                  style: GoogleFonts.notoSans(color: subtleTextColor),
                  textAlign: TextAlign.center,
                ),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSpeedIndicator(
                    title: 'Download Speed',
                    speed: _downloadSpeed,
                    unit: 'kbps'
                ),
                SizedBox(height: 16),
                _buildSpeedIndicator(
                    title: 'Upload Speed',
                    speed: _uploadSpeed,
                    unit: 'Mbps'
                ),
                SizedBox(height: 16),
                _buildSpeedIndicator(
                    title: 'Ping',
                    speed: _ping,
                    unit: 'ms'
                ),
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
                        : _connectionQuality == 'Poor' || _connectionQuality.contains('Failed')
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
                    onPressed: _isTesting ? null : _startSpeedTest,
                    child: Text(
                      _isTesting ? 'Testing...' : 'Test Again',
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