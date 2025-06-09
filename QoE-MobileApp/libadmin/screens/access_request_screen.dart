import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../models/app_state.dart';

class AccessRequestScreen extends StatelessWidget {
  final AppState appState;

  const AccessRequestScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 32),
              const Text(
                'Request Access to QoS Monitoring Portal',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'For verified network operators only',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
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

              _buildVerificationCard(),
              const SizedBox(height: 16),
              _buildUploadCard(),
              const SizedBox(height: 16),
              _buildTermsCard(),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: appState.selectedProvider.isNotEmpty &&
                      appState.workEmail.isNotEmpty &&
                      appState.companyId.isNotEmpty &&
                      appState.agreeTerms &&
                      !appState.isSubmitting
                      ? () => appState.submitAccessRequest()
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    appState.isSubmitting ? 'Submitting...' : 'Submit Request',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => appState.setCurrentScreen(Screen.login),
                child: const Text('Already have credentials? Login here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Verification Process',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Submit your details to verify your network operator status.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            
            const Text('Select a Mobile Network Provider'),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: appState.selectedProvider.isEmpty ? null : appState.selectedProvider,
              decoration: const InputDecoration(
                hintText: 'Choose your network provider',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'Camtel-Cameroon', child: Text('Camtel Cameroon')),
                DropdownMenuItem(value: 'Orange-Cameroon', child: Text('Orange Cameroon')),
                DropdownMenuItem(value: 'MTN-Cameroon', child: Text('MTN Cameroon')),
                DropdownMenuItem(value: 'Nexttel', child: Text('Nexttel')),
              
              ],
              onChanged: (value) => appState.setSelectedProvider(value ?? ''),
            ),
            
            const SizedBox(height: 16),
            const Text('Work Email Address'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'your.email@company.com',
                border: OutlineInputBorder(),
              ),
              onChanged: appState.setWorkEmail,
            ),
            
            const SizedBox(height: 16),
            const Text('Company Identification Number'),
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter company ID',
                border: OutlineInputBorder(),
              ),
              onChanged: appState.setCompanyId,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upload Verification Document',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Upload official documentation for verification.',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 16),
            
            GestureDetector(
              onTap: _handleFileUpload,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid, width: 2),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey.shade50,
                ),
                child: Column(
                  children: [
                    if (!appState.isUploading && appState.uploadedFile == null) ...[
                      Icon(Icons.cloud_upload, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'Upload Company ID, Proof of Address, etc.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Click to browse or drag and drop',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                      ),
                    ] else if (appState.isUploading) ...[
                      const Text('Uploading...'),
                      const SizedBox(height: 16),
                      LinearProgressIndicator(value: appState.uploadProgress / 100),
                      const SizedBox(height: 16),
                      Text('${appState.uploadProgress.toInt()}%'),
                    ] else ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.check_circle, color: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            '${appState.uploadedFile} UPLOADED',
                            style: const TextStyle(color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Checkbox(
                  value: appState.agreeTerms,
                  onChanged: (value) => appState.setAgreeTerms(value ?? false),
                ),
                const Expanded(
                  child: Text('I agree to Terms & Privacy Policy'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Receive system updates'),
                Switch(
                  value: appState.receiveUpdates,
                  onChanged: appState.setReceiveUpdates,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleFileUpload() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      String fileName = result.files.single.name;
      appState.simulateFileUpload(fileName);
    }
  }
}
