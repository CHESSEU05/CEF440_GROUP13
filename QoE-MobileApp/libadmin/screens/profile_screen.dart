import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/notification_bell.dart';
import '../widgets/navigation_bar.dart';

class ProfileScreen extends StatelessWidget {
  final AppState appState;

  const ProfileScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    bool emailAlertsEnabled = true;
    bool smsAlertsEnabled = false;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
          NotificationBell(appState: appState),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  if (appState.showSuccessAlert)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green.shade200),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        appState.alertMessage,
                        style: TextStyle(color: Colors.green.shade800),
                      ),
                    ),

                  // Account Settings
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Account Settings',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),

                          // Profile Information
                          const Text(
                            'Profile Information',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: 'MTN',
                            decoration: const InputDecoration(
                              labelText: 'Network Operator',
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Color(0xFFF9FAFB),
                            ),
                            readOnly: true,
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          const SizedBox(height: 16),

                          TextFormField(
                            initialValue: appState.profileEmail,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: appState.setProfileEmail,
                          ),
                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: appState.updateProfile,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Update Profile'),
                          ),
                          const SizedBox(height: 24),

                          const Divider(),
                          const SizedBox(height: 24),

                          // Notifications Section
                          const Text(
                            'Notifications',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Email Alerts',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Receive notifications via email',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: emailAlertsEnabled,
                                onChanged: (value) {
                                  // Update the state here - you'll need to make this a StatefulWidget
                                  // or use the appState to manage this
                                  appState.setAlertMessage('Email alerts ${value ? 'enabled' : 'disabled'}');
                                  appState.setShowSuccessAlert(true);
                                  Future.delayed(const Duration(seconds: 2), () => appState.setShowSuccessAlert(false));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'SMS Alerts',
                                    style: TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    'Receive notifications via SMS',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),
                              Switch(
                                value: smsAlertsEnabled,
                                onChanged: (value) {
                                  appState.setAlertMessage('SMS alerts ${value ? 'enabled' : 'disabled'}');
                                  appState.setShowSuccessAlert(true);
                                  Future.delayed(const Duration(seconds: 2), () => appState.setShowSuccessAlert(false));
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          const Divider(),
                          const SizedBox(height: 24),

                          // Account Status Section
                          const Text(
                            'Account Status',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Permissions:',
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  border: Border.all(color: Colors.green.shade200),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Operator',
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Full access to network management.',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Security:',
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => appState.setShowChangePassword(true),
                              icon: const Icon(Icons.lock_outline),
                              label: const Text('Change Password'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Divider(),
                          const SizedBox(height: 24),

                          // Change Password Modal
                          if (appState.showChangePassword) ...[
                            const SizedBox(height: 16),
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Change Password',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),

                                    TextFormField(
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Current Password',
                                        hintText: 'Enter current password',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: appState.setProfilePassword,
                                    ),
                                    const SizedBox(height: 16),

                                    TextFormField(
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'New Password',
                                        hintText: 'Enter new password',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: appState.setNewPassword,
                                    ),
                                    const SizedBox(height: 16),

                                    TextFormField(
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        labelText: 'Confirm New Password',
                                        hintText: 'Confirm new password',
                                        border: OutlineInputBorder(),
                                      ),
                                      onChanged: appState.setConfirmPassword,
                                    ),
                                    const SizedBox(height: 16),

                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            appState.setShowChangePassword(false);
                                            appState.setProfilePassword('');
                                            appState.setNewPassword('');
                                            appState.setConfirmPassword('');
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        const SizedBox(width: 8),
                                        ElevatedButton(
                                          onPressed: appState.profilePassword.isNotEmpty &&
                                              appState.newPassword.isNotEmpty &&
                                              appState.confirmPassword.isNotEmpty &&
                                              appState.newPassword == appState.confirmPassword
                                              ? appState.changePassword
                                              : null,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue.shade600,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Update Password'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomNavigationBar(appState: appState),
        ],
      ),
    );
  }
}
