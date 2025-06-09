import 'package:flutter/foundation.dart';

enum Screen {
  accessRequest,
  login,
  dashboard,
  feedbackInsights,
  reports,
  viewReport,
  profile,
}

class AppState extends ChangeNotifier {
  Screen _currentScreen = Screen.accessRequest;
  bool _isLoggedIn = false;
  String _selectedProvider = '';
  String _workEmail = '';
  String _companyId = '';
  bool _agreeTerms = false;
  bool _receiveUpdates = false;
  String _username = '';
  String _password = '';
  String _dateRange = 'Last 7 Days';
  double _uploadProgress = 0.0;
  bool _isUploading = false;
  String? _uploadedFile;
  int _notifications = 3;
  bool _showNotifications = false;
  Report _currentReport = reportsList[0];
  String _profileEmail = 'operator@cameroon-telecom.cm';
  String _profilePassword = '';
  bool _showChangePassword = false;
  String _newPassword = '';
  String _confirmPassword = '';
  bool _showSuccessAlert = false;
  String _alertMessage = '';
  bool _isSubmitting = false;
  bool _isDownloading = false;
  bool _isExporting = false;

  // Getters
  Screen get currentScreen => _currentScreen;
  bool get isLoggedIn => _isLoggedIn;
  String get selectedProvider => _selectedProvider;
  String get workEmail => _workEmail;
  String get companyId => _companyId;
  bool get agreeTerms => _agreeTerms;
  bool get receiveUpdates => _receiveUpdates;
  String get username => _username;
  String get password => _password;
  String get dateRange => _dateRange;
  double get uploadProgress => _uploadProgress;
  bool get isUploading => _isUploading;
  String? get uploadedFile => _uploadedFile;
  int get notifications => _notifications;
  bool get showNotifications => _showNotifications;
  Report get currentReport => _currentReport;
  String get profileEmail => _profileEmail;
  String get profilePassword => _profilePassword;
  bool get showChangePassword => _showChangePassword;
  String get newPassword => _newPassword;
  String get confirmPassword => _confirmPassword;
  bool get showSuccessAlert => _showSuccessAlert;
  String get alertMessage => _alertMessage;
  bool get isSubmitting => _isSubmitting;
  bool get isDownloading => _isDownloading;
  bool get isExporting => _isExporting;

  // Setters
  void setCurrentScreen(Screen screen) {
    _currentScreen = screen;
    notifyListeners();
  }

  void setIsLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }

  void setSelectedProvider(String value) {
    _selectedProvider = value;
    notifyListeners();
  }

  void setWorkEmail(String value) {
    _workEmail = value;
    notifyListeners();
  }

  void setCompanyId(String value) {
    _companyId = value;
    notifyListeners();
  }

  void setAgreeTerms(bool value) {
    _agreeTerms = value;
    notifyListeners();
  }

  void setReceiveUpdates(bool value) {
    _receiveUpdates = value;
    notifyListeners();
  }

  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setDateRange(String value) {
    _dateRange = value;
    notifyListeners();
  }

  void setUploadProgress(double value) {
    _uploadProgress = value;
    notifyListeners();
  }

  void setIsUploading(bool value) {
    _isUploading = value;
    notifyListeners();
  }

  void setUploadedFile(String? value) {
    _uploadedFile = value;
    notifyListeners();
  }

  void setNotifications(int value) {
    _notifications = value;
    notifyListeners();
  }

  void setShowNotifications(bool value) {
    _showNotifications = value;
    notifyListeners();
  }

  void setCurrentReport(Report value) {
    _currentReport = value;
    notifyListeners();
  }

  void setProfileEmail(String value) {
    _profileEmail = value;
    notifyListeners();
  }

  void setProfilePassword(String value) {
    _profilePassword = value;
    notifyListeners();
  }

  void setShowChangePassword(bool value) {
    _showChangePassword = value;
    notifyListeners();
  }

  void setNewPassword(String value) {
    _newPassword = value;
    notifyListeners();
  }

  void setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();
  }

  void setShowSuccessAlert(bool value) {
    _showSuccessAlert = value;
    notifyListeners();
  }

  void setAlertMessage(String value) {
    _alertMessage = value;
    notifyListeners();
  }

  void setIsSubmitting(bool value) {
    _isSubmitting = value;
    notifyListeners();
  }

  void setIsDownloading(bool value) {
    _isDownloading = value;
    notifyListeners();
  }

  void setIsExporting(bool value) {
    _isExporting = value;
    notifyListeners();
  }

  // Methods
  void login() {
    if (_username.isNotEmpty && _password.isNotEmpty) {
      setIsLoggedIn(true);
      setCurrentScreen(Screen.dashboard);
    }
  }

  Future<void> submitAccessRequest() async {
    if (_selectedProvider.isNotEmpty &&
        _workEmail.isNotEmpty &&
        _companyId.isNotEmpty &&
        _agreeTerms) {
      setIsSubmitting(true);
      await Future.delayed(const Duration(seconds: 2));
      setIsSubmitting(false);
      setAlertMessage('Verification in progress. Credentials will be emailed within 24-48h.');
      setShowSuccessAlert(true);
    }
  }

  Future<void> simulateFileUpload(String fileName) async {
    setIsUploading(true);
    setUploadProgress(0.0);

    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      setUploadProgress(i.toDouble());
    }

    setIsUploading(false);
    setUploadedFile(fileName);
  }

  Future<void> downloadReport() async {
    setIsDownloading(true);
    await Future.delayed(const Duration(seconds: 2));
    setIsDownloading(false);
    setAlertMessage('Report downloaded successfully!');
    setShowSuccessAlert(true);
    Future.delayed(const Duration(seconds: 3), () => setShowSuccessAlert(false));
  }

  Future<void> exportReport() async {
    setIsExporting(true);
    await Future.delayed(const Duration(seconds: 2));
    setIsExporting(false);
    setAlertMessage('Report exported successfully!');
    setShowSuccessAlert(true);
    Future.delayed(const Duration(seconds: 3), () => setShowSuccessAlert(false));
  }

  void updateProfile() {
    setAlertMessage('Profile updated successfully!');
    setShowSuccessAlert(true);
    Future.delayed(const Duration(seconds: 3), () => setShowSuccessAlert(false));
  }

  void changePassword() {
    if (_newPassword.isNotEmpty && _newPassword == _confirmPassword) {
      setAlertMessage('Password changed successfully!');
      setShowSuccessAlert(true);
      Future.delayed(const Duration(seconds: 3), () {
        setShowSuccessAlert(false);
        setShowChangePassword(false);
        setNewPassword('');
        setConfirmPassword('');
      });
    }
  }
}

// Data Models
class ComplaintData {
  final String day;
  final int total;
  final int social;
  final int calls;
  final int billing;

  ComplaintData({
    required this.day,
    required this.total,
    required this.social,
    required this.calls,
    required this.billing,
  });
}

class LocationData {
  final String name;
  final int complaints;
  final int percentage;

  LocationData({
    required this.name,
    required this.complaints,
    required this.percentage,
  });
}

class FeedbackData {
  final double overall;
  final int total;
  final Map<int, int> breakdown;
  final SatisfactionData satisfaction;
  final Map<String, CategoryData> categories;

  FeedbackData({
    required this.overall,
    required this.total,
    required this.breakdown,
    required this.satisfaction,
    required this.categories,
  });
}

class SatisfactionData {
  final int current;
  final int trend;
  final List<int> monthly;

  SatisfactionData({
    required this.current,
    required this.trend,
    required this.monthly,
  });
}

class CategoryData {
  final double score;
  final double trend;

  CategoryData({
    required this.score,
    required this.trend,
  });
}

class Report {
  final String id;
  final String title;
  final String description;
  final String date;
  final String type;
  final Map<String, dynamic> metrics;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.type,
    required this.metrics,
  });
}

// Mock Data
final List<ComplaintData> complaintsByDayData = [
  ComplaintData(day: "Mon, May 20", total: 78, social: 32, calls: 28, billing: 18),
  ComplaintData(day: "Tue, May 21", total: 92, social: 41, calls: 30, billing: 21),
  ComplaintData(day: "Wed, May 22", total: 65, social: 25, calls: 22, billing: 18),
  ComplaintData(day: "Thu, May 23", total: 87, social: 38, calls: 29, billing: 20),
  ComplaintData(day: "Fri, May 24", total: 105, social: 48, calls: 35, billing: 22),
  ComplaintData(day: "Sat, May 25", total: 70, social: 30, calls: 25, billing: 15),
  ComplaintData(day: "Sun, May 26", total: 53, social: 20, calls: 18, billing: 15),
];

final List<LocationData> locationData = [
  LocationData(name: "Douala", complaints: 215, percentage: 28),
  LocationData(name: "Yaoundé", complaints: 187, percentage: 24),
  LocationData(name: "Bamenda", complaints: 124, percentage: 16),
  LocationData(name: "Bafoussam", complaints: 98, percentage: 13),
  LocationData(name: "Garoua", complaints: 76, percentage: 10),
  LocationData(name: "Others", complaints: 70, percentage: 9),
];

final FeedbackData feedbackData = FeedbackData(
  overall: 4.2,
  total: 2847,
  breakdown: {5: 60, 4: 25, 3: 10, 2: 3, 1: 2},
  satisfaction: SatisfactionData(
    current: 84,
    trend: 5,
    monthly: [76, 78, 79, 81, 82, 84],
  ),
  categories: {
    "Network Coverage": CategoryData(score: 3.8, trend: 0.2),
    "Call Quality": CategoryData(score: 4.1, trend: 0.3),
    "Data Speed": CategoryData(score: 3.9, trend: -0.1),
    "Customer Support": CategoryData(score: 4.5, trend: 0.4),
    "Value for Money": CategoryData(score: 3.7, trend: 0.1),
  },
);

final List<Report> reportsList = [
  Report(
    id: "npr-2024-06",
    title: "Network Performance Report",
    description: "Comprehensive analysis of network performance metrics",
    date: "Jun 2, 2024 10:30 AM",
    type: "network",
    metrics: {
      "latency": {"value": 42, "trend": -5},
      "throughput": {"value": 156, "trend": 12},
      "errorRate": {"value": 2.1, "trend": 0.2},
    },
  ),
  Report(
    id: "uea-2024-06",
    title: "User Engagement Analysis",
    description: "Analysis of user engagement and satisfaction metrics",
    date: "Jun 1, 2024 2:15 PM",
    type: "user",
    metrics: {
      "activeUsers": {"value": 28450, "trend": 1250},
      "avgSessionTime": {"value": 24, "trend": 3},
      "retentionRate": {"value": 78, "trend": 2},
    },
  ),
  Report(
    id: "dus-2024-05",
    title: "Device Usage Statistics",
    description: "Analysis of device types and usage patterns",
    date: "May 30, 2024 9:45 AM",
    type: "device",
    metrics: {
      "androidUsers": {"value": 65, "trend": 2},
      "iosUsers": {"value": 32, "trend": -1},
      "otherUsers": {"value": 3, "trend": -1},
    },
  ),
  Report(
    id: "ctr-2024-05",
    title: "Coverage Troubleshooting Report",
    description: "Analysis of coverage issues and resolution strategies",
    date: "May 28, 2024 11:20 AM",
    type: "network",
    metrics: {
      "coverageIssues": {"value": 87, "trend": -12},
      "resolutionRate": {"value": 92, "trend": 4},
      "avgResolutionTime": {"value": 36, "trend": -8},
    },
  ),
  Report(
    id: "rtr-2024-05",
    title: "Regional Traffic Report",
    description: "Analysis of network traffic by region",
    date: "May 25, 2024 3:45 PM",
    type: "network",
    metrics: {
      "doualaTraffic": {"value": 42, "trend": 5},
      "yaoundeTraffic": {"value": 38, "trend": 3},
      "otherRegionsTraffic": {"value": 20, "trend": -8},
    },
  ),
];

final Map<String, Map<String, dynamic>> timeframeData = {
  "Last 7 Days": {
    "totalComplaints": 480,
    "avgSignal": -74.7,
    "avgLatency": 81.9,
    "topLocation": "Douala",
  },
  "Last 30 Days": {
    "totalComplaints": 1842,
    "avgSignal": -72.3,
    "avgLatency": 79.5,
    "topLocation": "Douala",
  },
  "6 Months": {
    "totalComplaints": 10568,
    "avgSignal": -68.9,
    "avgLatency": 76.2,
    "topLocation": "Yaoundé",
  },
  "1 Year": {
    "totalComplaints": 21345,
    "avgSignal": -70.1,
    "avgLatency": 77.8,
    "topLocation": "Douala",
  },
  "Custom": {
    "totalComplaints": 3254,
    "avgSignal": -71.5,
    "avgLatency": 80.2,
    "topLocation": "Bamenda",
  },
};
