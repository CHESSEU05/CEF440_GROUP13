import 'package:flutter/material.dart';
import 'frontend/welcome.dart';
import 'frontend/signup.dart';
import 'frontend/login.dart';
import 'frontend/permission.dart';
import 'frontend/home.dart';
import 'frontend/my_activity.dart';
import 'frontend/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/settings':(context) => SettingsScreen(),
      },
    );
  }
}