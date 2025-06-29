import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
const Color starColor = Color(0xFFFFC107);

class FeedbackSurveyDialog extends StatefulWidget {
  @override
  _FeedbackSurveyDialogState createState() => _FeedbackSurveyDialogState();
}

class _FeedbackSurveyDialogState extends State<FeedbackSurveyDialog> {
  final List<int?> _ratings = [null, null, null, null];
  final TextEditingController _thoughtsController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isSubmitting = false;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  /// Gets the current location of the user
  /// This will be attached to the feedback for location-based analytics
  Future<void> _getCurrentLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled.');
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        print('Location permissions are permanently denied');
        return;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  /// Checks if all required ratings are provided
  bool _canSubmit() {
    return _ratings.every((rating) => rating != null && rating > 0);
  }

  /// Submits the feedback to Firestore
  /// Creates a new document in the 'userFeedback' collection
  Future<void> _submitFeedback() async {
    if (!_canSubmit()) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get current user ID (you might need to implement authentication)
      String userId = _auth.currentUser?.uid ?? 'anonymous_user';

      // Prepare feedback data
      Map<String, dynamic> feedbackData = {
        'userId': userId,
        'timestamp': FieldValue.serverTimestamp(),
        'ratings': {
          'overallExperience': _ratings[0],
          'internetSpeed': _ratings[1],
          'connectionStability': _ratings[2],
          'callQuality': _ratings[3],
        },
        'additionalThoughts': _thoughtsController.text.trim(),
        'location': _currentPosition != null ? {
          'latitude': _currentPosition!.latitude,
          'longitude': _currentPosition!.longitude,
          'accuracy': _currentPosition!.accuracy,
        } : null,
        'deviceInfo': {
          'platform': 'mobile', // You can get more detailed device info if needed
          'appVersion': '1.0.0', // Replace with actual app version
        },
        'submissionSource': 'feedback_survey',
      };

      // Submit to Firestore
      await _firestore.collection('userFeedback').add(feedbackData);

      // Close dialog and show success message
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: successColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );

    } catch (e) {
      print('Error submitting feedback: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit feedback. Please try again.'),
          backgroundColor: errorColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildRatingQuestion({
    required String question,
    required int index,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${index + 1}. $question',
          style: GoogleFonts.notoSans(
            color: textColor.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: List.generate(5, (i) {
            return IconButton(
              icon: Icon(
                i < (_ratings[index] ?? 0) ? Icons.star : Icons.star_border,
                color: starColor,
                size: 30,
              ),
              onPressed: _isSubmitting ? null : () {
                setState(() {
                  _ratings[index] = i + 1;
                });
              },
            );
          }),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: cardBackgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: SingleChildScrollView(
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
                    'Feedback Survey Form',
                    style: GoogleFonts.notoSans(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: subtleTextColor),
                    onPressed: _isSubmitting ? null : () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Rate your experience',
                style: GoogleFonts.notoSans(
                  color: subtleTextColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 24),
              _buildRatingQuestion(
                question: 'What\'s your overall experience rating ?',
                index: 0,
              ),
              _buildRatingQuestion(
                question: 'How would you rate your internet speed ?',
                index: 1,
              ),
              _buildRatingQuestion(
                question: 'Rate the stability of your connection ?',
                index: 2,
              ),
              _buildRatingQuestion(
                question: 'Rate the quality of calls ?',
                index: 3,
              ),
              Text(
                '5. Got anything else to share ? We\'re listening !',
                style: GoogleFonts.notoSans(
                  color: textColor.withOpacity(0.9),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _thoughtsController,
                enabled: !_isSubmitting,
                style: GoogleFonts.notoSans(color: textColor),
                decoration: InputDecoration(
                  hintText: 'Share your thoughts ...',
                  hintStyle: GoogleFonts.notoSans(color: subtleTextColor),
                  filled: true,
                  fillColor: surfaceColor,
                  contentPadding: EdgeInsets.all(16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: borderColor, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: primaryColor, width: 1.5),
                  ),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (_canSubmit() && !_isSubmitting)
                        ? primaryColor
                        : subtleTextColor.withOpacity(0.6),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: (_canSubmit() && !_isSubmitting) ? _submitFeedback : null,
                  child: _isSubmitting
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        'Submitting...',
                        style: GoogleFonts.notoSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                      : Text(
                    'Submit',
                    style: GoogleFonts.notoSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
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

  @override
  void dispose() {
    _thoughtsController.dispose();
    super.dispose();
  }
}