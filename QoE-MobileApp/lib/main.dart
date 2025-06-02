import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'welcome.dart';
import 'signup.dart';
import 'login.dart';
import 'permission.dart';
import 'home.dart';
import 'my_activity.dart';
import 'settings.dart';

void main() {
  runApp(ImproveConnectApp());
}

class ImproveConnectApp extends StatelessWidget {
  const ImproveConnectApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ImproveConnect',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Noto Sans',
      ),
      home: WelcomePage(),
      routes: {
        '/signup': (context) => SignupPage(),
        '/login': (context) => LoginPage(),
        '/permission': (context) => PermissionPage(),
        '/home': (context) => HomePage(),
        '/my_activity': (context) => MyActivityScreen(),
      },
    );
  }
}