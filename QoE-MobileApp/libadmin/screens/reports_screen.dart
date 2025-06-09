import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/notification_bell.dart';
import '../widgets/navigation_bar.dart';

class ReportsScreen extends StatelessWidget {
  final AppState appState;

  const ReportsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Reports & Exports'),
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

                  // Search and Filters
                  Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Search by report name or details',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: 'Date Range',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: '7days', child: Text('Last 7 Days')),
                                DropdownMenuItem(value: '30days', child: Text('Last 30 Days')),
                                DropdownMenuItem(value: '6months', child: Text('6 Months')),
                                DropdownMenuItem(value: '1year', child: Text('1 Year')),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                hintText: 'Report Type',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(value: 'network', child: Text('Network Performance')),
                                DropdownMenuItem(value: 'user', child: Text('User Engagement')),
                                DropdownMenuItem(value: 'device', child: Text('Device Usage')),
                              ],
                              onChanged: (value) {},
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Reports List
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Available Reports',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ...reportsList.map((report) => _buildReportItem(report)),
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

  Widget _buildReportItem(Report report) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  report.title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  'Generated: ${report.date}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              appState.setCurrentReport(report);
              appState.setCurrentScreen(Screen.viewReport);
            },
            icon: const Icon(Icons.visibility, size: 16),
            label: const Text('View'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
