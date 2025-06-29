import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController(text: '6');
  final TextEditingController otpController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool showOTPField = false;
  bool _isLoading = false;
  bool _isPhoneValid = false;
  String? _generatedOTP;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validatePhoneNumber);
  }

  @override
  void dispose() {
    phoneController.removeListener(_validatePhoneNumber);
    phoneController.dispose();
    otpController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  void _validatePhoneNumber() {
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

    bool isValid = text.length == 9 &&
        ['62', '65', '67', '68', '69'].any((prefix) => text.startsWith(prefix));

    // if (!isValid) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //       content: Text(
    //         'Enter a valid phone number',
    //         style: GoogleFonts.notoSans(),
    //         textAlign: TextAlign.center,
    //       ),
    //     ),
    //   );
    // }

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

    setState(() {
      _isPhoneValid = isValid;
    });
  }

  String _generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  Future<void> _sendOTP() async {
    setState(() => _isLoading = true);
    final phone = '+237' + phoneController.text.replaceAll(' ', '');

    final existingUser = await _firestore
        .collection('users')
        .where('phone', isEqualTo: phone)
        .limit(1)
        .get();

    if (existingUser.docs.isNotEmpty) {
      _showError('This phone number is already registered. Please log in.');
      setState(() => _isLoading = false);
      return;
    }

    _generatedOTP = _generateOTP();

    await _firestore.collection('otps').doc(phone).set({
      'otp': _generatedOTP,
      'timestamp': FieldValue.serverTimestamp(),
    });

    print('OTP sent to $phone: $_generatedOTP');

    setState(() {
      showOTPField = true;
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('OTP sent to $phone')),
    );
  }

  Future<void> _continueToLogin() async {
    final phone = '+237' + phoneController.text.replaceAll(' ', '');
    final username = usernameController.text.trim();
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

    if (savedOtp == enteredOtp &&
        timestamp != null &&
        DateTime.now().difference(timestamp).inMinutes <= 5) {
      final userRef = _firestore.collection('users').doc();
      await userRef.set({
        'userId': userRef.id,
        'username': username,
        'phone': phone,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Navigator.pushNamed(context, '/login');
    } else {
      _showError('Invalid or expired OTP');
    }

    setState(() => _isLoading = false);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
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
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A80E5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Signup',
                  style: GoogleFonts.notoSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Container(
                  height: 5,
                  width: 400,
                  color: const Color(0xFF1A80E5),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  'Please fill the following information to sign up',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Mobile Number (+237)'),
                ),
              ),
              const SizedBox(height: 20),
              if (!showOTPField)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isPhoneValid ? _sendOTP : null,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Send OTP'),
                    ),
                  ),
                ),
              if (showOTPField) ...[
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: TextField(
                    controller: otpController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    decoration: InputDecoration(labelText: 'Enter 6-digit OTP'),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _continueToLogin,
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Continue'),
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'By clicking on this button, you agree to\n security and privacy terms.',
                  style: GoogleFonts.notoSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: 5,
                width: 400,
                color: const Color(0xFF1A80E5),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/login'),
                  child: Text.rich(
                    TextSpan(
                      text: 'Do you already have an account? ',
                      style: GoogleFonts.notoSans(
                        color: Colors.grey[600],
                        fontSize: 12,
                        height: 2,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: GoogleFonts.notoSans(
                            color: const Color(0xFF1A80E5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
