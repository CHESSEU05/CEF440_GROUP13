import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController phoneController = TextEditingController(text: '6');
  final TextEditingController otpController = TextEditingController();
  bool showOTPField = false;
  bool _isLoading = false;
  bool _isPhoneValid = false;

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
    super.dispose();
  }

  void _validatePhoneNumber() {
    final text = phoneController.text.replaceAll(' ', '');

    // Prevent input beyond 9 digits
    if (text.length > 9) {
      // Truncate to 9 digits
      final truncated = text.substring(0, 9);
      String formatted = '6'; // Always starts with 6
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

    if (text.length >= 2 && !['62', '65', '67', '68', '69'].any((prefix) => text.startsWith(prefix))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter a valid phone number : MTN, ORANGE or CAMTEL',
            style: GoogleFonts.notoSans(),
          ),
        ),
      );
    }
    // Format phone number with spaces
    String formatted = '6'; // Always starts with 6
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

  Future<void> _sendOTP() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network request
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      showOTPField = true;
      _isLoading = false;
    });
  }

  void _continueToLogin() {
    if (otpController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter a valid 6-digit OTP',
            style: GoogleFonts.notoSans(),
          ),
        ),
      );
      return;
    }
    Navigator.pushNamed(context, '/login');
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
              // App Logo
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
                      child: const Icon(
                        Icons.network_check,
                        size: 40,
                        color: Color(0xFF1A80E5),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),

              // Sign Up Title
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

              // Instruction Text
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

              // Mobile Number Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 40),
                    child: Text(
                      'Mobile Number',
                      style: GoogleFonts.notoSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
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
                        child: Row(
                          children: [
                            Text(
                              '+237 ',
                              style: GoogleFonts.notoSans(
                                color: Colors.black87,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: '7 50 20 45 99',
                                  border: InputBorder.none,
                                ),
                                style: GoogleFonts.notoSans(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isPhoneValid
                            ? Colors.grey[800]  // Dark grey when active
                            : Colors.grey[400], // Light grey when inactive
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : Text(
                        'Send OTP',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              if (showOTPField) ...[
                const SizedBox(height: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Text(
                        'OTP Code',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _continueToLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A80E5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Continue',
                            style: GoogleFonts.notoSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),

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
              // Horizontal Line
              Container(
                height: 5,
                width: 400,
                color: const Color(0xFF1A80E5),
              ),

              const SizedBox(height: 20),
              // Already have an account
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