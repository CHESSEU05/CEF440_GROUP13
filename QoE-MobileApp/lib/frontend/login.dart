import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController(text: '6');
  final TextEditingController otpController = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _username;
  String? _generatedOTP;
  bool _isLoading = false;
  bool showOTPField = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_formatPhoneNumber);
  }

  @override
  void dispose() {
    phoneController.removeListener(_formatPhoneNumber);
    phoneController.dispose();
    otpController.dispose();
    super.dispose();
  }

  void _formatPhoneNumber() {
    final text = phoneController.text.replaceAll(' ', '');
    if (text.length > 9) {
      final truncated = text.substring(0, 9);
      String formatted = '6';
      if (truncated.length > 1) {
        String remainingDigits = truncated.substring(1);
        for (int i = 0; i < remainingDigits.length; i++) {
          if (i > 0 && i % 2 == 0) formatted += ' ';
          formatted += remainingDigits[i];
        }
      }
      phoneController.value = phoneController.value.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
      return;
    }
    String formatted = '6';
    if (text.length > 1) {
      String remainingDigits = text.substring(1).replaceAll(RegExp(r'[^0-9]'), '');
      for (int i = 0; i < remainingDigits.length; i++) {
        if (i > 0 && i % 2 == 0) formatted += ' ';
        formatted += remainingDigits[i];
      }
    }
    if (phoneController.text != formatted) {
      phoneController.value = phoneController.value.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }
  }

  String _generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> _verifyAndSendOTP() async {
    final phone = '+237' + phoneController.text.replaceAll(' ', '');

    setState(() => _isLoading = true);

    final userDoc = await _firestore.collection('users').where('phone', isEqualTo: phone).get();
    if (userDoc.docs.isEmpty) {
      _showError('Phone number not registered. Please sign up first.');
      return;
    }

    _username = userDoc.docs.first['username'];
    _generatedOTP = _generateOTP();

    await _firestore.collection('otps').doc(phone).set({
      'otp': _generatedOTP,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Show OTP in terminal for testing/debugging
    print('OTP sent to $phone: $_generatedOTP');

    setState(() {
      showOTPField = true;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to $phone')),
    );
  }

  Future<void> _verifyOTP() async {
    final phone = '+237' + phoneController.text.replaceAll(' ', '');
    final enteredOtp = otpController.text.trim();

    if (enteredOtp.length != 6) {
      _showError('Please enter a valid 6-digit OTP');
      return;
    }

    setState(() => _isLoading = true);

    final doc = await _firestore.collection('otps').doc(phone).get();
    if (!doc.exists) {
      _showError('No OTP found. Please request again.');
      return;
    }

    final data = doc.data()!;
    final savedOtp = data['otp'];
    final timestamp = data['timestamp']?.toDate();

    if (savedOtp == enteredOtp && timestamp != null && DateTime.now().difference(timestamp).inMinutes <= 5) {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('phone', isEqualTo: phone)
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final data = userDoc.docs.first.data();
        final permissionsGranted = data['permissionsGranted'] == true;

        if (permissionsGranted) {
          Navigator.pushNamed(context, '/home');
        } else {
          Navigator.pushNamed(context, '/permission', arguments: phone);
        }
      }

    } else {
      _showError('Invalid or expired OTP');
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() {
      _isLoading = false;
      showOTPField = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final welcomeText = _username != null ? 'Welcome Back $_username !' : 'Welcome Back!';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Center(
                child: Image.asset(
                  'lib/assets/app-logo-long.png',
                  width: 400,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) => Icon(Icons.network_check),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  welcomeText,
                  style: GoogleFonts.notoSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Container(height: 5, width: 400, color: const Color(0xFF1A80E5)),
              const SizedBox(height: 30),
              Text(
                'Please enter your phone number',
                style: GoogleFonts.notoSans(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 30),
              _buildPhoneInputField(),
              const SizedBox(height: 20),
              if (!showOTPField) _buildSendOTPButton() else _buildOTPField(),
              const SizedBox(height: 20),
              Container(height: 5, width: 400, color: const Color(0xFF1A80E5)),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/signup'),
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    style: GoogleFonts.notoSans(color: Colors.grey[600], fontSize: 12),
                    children: [
                      TextSpan(
                        text: 'Signup',
                        style: GoogleFonts.notoSans(
                          color: const Color(0xFF1A80E5),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Text('+237 ', style: GoogleFonts.notoSans(color: Colors.black87)),
              Expanded(
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(hintText: '7 50 20 45 99', border: InputBorder.none),
                  style: GoogleFonts.notoSans(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSendOTPButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: _isLoading ? null : _verifyAndSendOTP,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1A80E5),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 0,
          ),
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              : Text('Login', style: GoogleFonts.notoSans(color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildOTPField() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: 'Enter 6-digit OTP',
                  border: InputBorder.none,
                  counterText: '',
                ),
                style: GoogleFonts.notoSans(),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _verifyOTP,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A80E5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: Text('Continue', style: GoogleFonts.notoSans(color: Colors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
