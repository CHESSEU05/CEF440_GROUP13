import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Generate 6-digit OTP
  String generateOTP() {
    final random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Save OTP temporarily (valid for 5 minutes)
  Future<void> saveOTP(String phone, String otp) async {
    await _firestore.collection('otps').doc(phone).set({
      'otp': otp,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Validate OTP
  Future<bool> validateOTP(String phone, String enteredOtp) async {
    final doc = await _firestore.collection('otps').doc(phone).get();
    if (!doc.exists) return false;

    final data = doc.data()!;
    final storedOtp = data['otp'];
    final timestamp = data['timestamp']?.toDate();

    // Check expiration (5 minutes)
    if (storedOtp == enteredOtp &&
        timestamp != null &&
        DateTime.now().difference(timestamp).inMinutes <= 5) {
      return true;
    }
    return false;
  }

  // Save user to 'users' collection
  Future<void> saveUser(String username, String phone) async {
    final userRef = _firestore.collection('users').doc();
    await userRef.set({
      'userId': userRef.id,
      'username': username,
      'phone': phone,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
