import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(ImproveConnectApp());
}

class ImproveConnectApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImproveConnect',
      theme: ThemeData(
        primaryColor: const Color(0xFF1A80E5),
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo - Replaced with your actual logo
                Image.asset(
                  'lib/assets/app-logo-long.png',
                  width: 400,
                  height: 50,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1A80E5).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.network_check,
                        size: 50,
                        color: Color(0xFF1A80E5),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 40),

                // Welcome Message
                Text(
                  'Welcome to',
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'ImproveConnect',
                  style: GoogleFonts.notoSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A80E5),
                  ),
                ),
                const SizedBox(height: 24),

                // First Horizontal Line
                Container(
                  height: 5,
                  width: 400,
                  color: const Color(0xFF1A80E5),
                ),
                const SizedBox(height: 24),

                // App Slogan
                Text(
                  'Your network experience matters and we\n are here to make it better !!!',
                  style: GoogleFonts.notoSans(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Second Horizontal Line
                Container(
                  height: 5,
                  width: 400,
                  color: const Color(0xFF1A80E5),
                ),
                const SizedBox(height: 40),

                // Get Started Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/signup');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A80E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Get Started',
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
        ),
      ),
    );
  }
}