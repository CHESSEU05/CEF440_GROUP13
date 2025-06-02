import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController phoneController = TextEditingController(text: '6');
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_formatPhoneNumber);
  }

  @override
  void dispose() {
    phoneController.removeListener(_formatPhoneNumber);
    phoneController.dispose();
    super.dispose();
  }

  void _formatPhoneNumber() {
    final text = phoneController.text.replaceAll(' ', '');

    // Prevent input beyond 9 digits
    if (text.length > 9) {
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
  }

  void _login() {
    final phoneDigits = phoneController.text.replaceAll(' ', '');

    if (phoneDigits.length != 9 ||
        !['62', '65', '67', '68', '69'].any((prefix) => phoneDigits.startsWith(prefix))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter a valid phone number : MTN, ORANGE or CAMTEL',
            style: GoogleFonts.notoSans(),
          ),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate login process
    Future.delayed(const Duration(seconds: 1), () {
      setState(() => _isLoading = false);
      Navigator.pushNamed(context, '/permission');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // This removes the back arrow
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

              // Welcome Back Title
              Center(
                child: Text(
                  'Welcome Back Tertullien !',
                  style: GoogleFonts.notoSans(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
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
                  'Please enter your phone number',
                  style: GoogleFonts.notoSans(
                    fontSize: 14,
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
              const SizedBox(height: 40),

              // Login Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A80E5),
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
                      'Login',
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),
              Center(
                child: Container(
                  height: 5,
                  width: 400,
                  color: const Color(0xFF1A80E5),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/signup'),
                  child: Text.rich(
                    TextSpan(
                      text: 'Don\'t have an account? ',
                      style: GoogleFonts.notoSans(
                        color: Colors.grey[600],
                        fontSize: 12,
                        height: 2,
                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}