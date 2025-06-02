import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/notification_bell.dart';
import '../widgets/navigation_bar.dart';

class ViewReportScreen extends StatelessWidget {
  final AppState appState;

  const ViewReportScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final report = appState.currentReport;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'View Report',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black12,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => appState.setCurrentScreen(Screen.reports),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: NotificationBell(appState: appState),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (appState.showSuccessAlert)
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Color(0xFF16A34A), size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              appState.alertMessage,
                              style: const TextStyle(color: Color(0xFF15803D)),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Report Header
                  Card(
                    elevation: 2,
                    shadowColor: Colors.black12,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _getReportTypeColor(report.type).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _getReportTypeIcon(report.type),
                                  color: _getReportTypeColor(report.type),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      report.title,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF111827),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      report.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.schedule, size: 14, color: Colors.blue.shade600),
                                const SizedBox(width: 4),
                                Text(
                                  'Generated: ${report.date}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade600,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Report Content based on type
                  if (report.type == 'network') ..._buildNetworkReportContent(report),
                  if (report.type == 'user') ..._buildUserReportContent(report),
                  if (report.type == 'device') ..._buildDeviceReportContent(report),

                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: appState.isDownloading ? null : () => appState.downloadReport(),
                          icon: appState.isDownloading 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Icon(Icons.download),
                          label: Text(appState.isDownloading ? 'Downloading...' : 'Download PDF'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: appState.isExporting ? null : () => appState.exportReport(),
                          icon: appState.isExporting 
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Icon(Icons.table_chart),
                          label: Text(appState.isExporting ? 'Exporting...' : 'Export CSV'),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            side: const BorderSide(color: Color(0xFF2563EB)),
                            foregroundColor: const Color(0xFF2563EB),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
          CustomNavigationBar(appState: appState),
        ],
      ),
    );
  }

  Color _getReportTypeColor(String type) {
    switch (type) {
      case 'network':
        return const Color(0xFF2563EB);
      case 'user':
        return const Color(0xFF059669);
      case 'device':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getReportTypeIcon(String type) {
    switch (type) {
      case 'network':
        return Icons.network_check;
      case 'user':
        return Icons.people;
      case 'device':
        return Icons.devices;
      default:
        return Icons.description;
    }
  }

  List<Widget> _buildNetworkReportContent(Report report) {
    final metrics = report.metrics ?? {};
    
    return [
      // Summary Cards Row
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Latency',
              '${metrics['latency']?['value'] ?? 42}ms',
              metrics['latency']?['trend'] ?? -5,
              Icons.speed,
              const Color(0xFF2563EB),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Throughput',
              '${metrics['throughput']?['value'] ?? 156} Mbps',
              metrics['throughput']?['trend'] ?? 12,
              Icons.trending_up,
              const Color(0xFF059669),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Error Rate',
              '${metrics['errorRate']?['value'] ?? 2.1}%',
              metrics['errorRate']?['trend'] ?? 0.2,
              Icons.error_outline,
              const Color(0xFFDC2626),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Uptime',
              '99.8%',
              0.1,
              Icons.check_circle_outline,
              const Color(0xFF059669),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),

      // Detailed Charts
      Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Network Performance Trends',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                height: 200,
                child: CustomPaint(
                  painter: NetworkPerformanceChartPainter(),
                  size: const Size(double.infinity, 200),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildChartLegend('Latency (ms)', const Color(0xFF2563EB)),
                  _buildChartLegend('Throughput (Mbps)', const Color(0xFF059669)),
                  _buildChartLegend('Error Rate (%)', const Color(0xFFDC2626)),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Regional Performance
      Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Regional Performance',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              ...['Douala', 'Yaoundé', 'Bamenda', 'Bafoussam'].map((city) => 
                _buildRegionalItem(city, _getRegionalData(city))
              ),
            ],
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildUserReportContent(Report report) {
  final metrics = report.metrics ?? {};
  
  return [
    // User Metrics Summary
    Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Active Users',
            '${(metrics['activeUsers']?['value'] ?? 28450).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
            metrics['activeUsers']?['trend'] ?? 1250,
            Icons.people,
            const Color(0xFF059669),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Session Time',
            '${metrics['avgSessionTime']?['value'] ?? 24} min',
            metrics['avgSessionTime']?['trend'] ?? 3,
            Icons.access_time,
            const Color(0xFF2563EB),
          ),
        ),
      ],
    ),
    const SizedBox(height: 12),
    Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            'Retention Rate',
            '${metrics['retentionRate']?['value'] ?? 78}%',
            metrics['retentionRate']?['trend'] ?? 2,
            Icons.repeat,
            const Color(0xFF7C3AED),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            'Satisfaction',
            '4.2/5',
            0.3,
            Icons.star,
            const Color(0xFFF59E0B),
          ),
        ),
      ],
    ),
    const SizedBox(height: 20),

    // Active Users Line Chart
    Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.people, color: const Color(0xFF059669), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Active Users Trend',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${metrics['activeUsers']?['trend'] ?? 1250} users',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.green.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: CustomPaint(
                painter: ActiveUsersLineChartPainter(),
                size: const Size(double.infinity, 200),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('7 days ago', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text('Today', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 16),

    // Session Time Bar Chart
    Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, color: const Color(0xFF2563EB), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Average Session Time',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${metrics['avgSessionTime']?['trend'] ?? 3} min',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.blue.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: CustomPaint(
                painter: SessionTimeBarChartPainter(),
                size: const Size(double.infinity, 200),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) => 
                Text(day, style: TextStyle(fontSize: 12, color: Colors.grey.shade600))
              ).toList(),
            ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 16),

    // Retention Rate Line Chart
    Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.repeat, color: const Color(0xFF7C3AED), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'User Retention Rate',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '+${metrics['retentionRate']?['trend'] ?? 2}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 200,
              child: CustomPaint(
                painter: RetentionRateLineChartPainter(),
                size: const Size(double.infinity, 200),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Week 1', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text('Week 2', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text('Week 3', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                Text('Week 4', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
      ),
    ),
    const SizedBox(height: 16),

    // User Demographics
    Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.pie_chart, color: const Color(0xFFF59E0B), size: 20),
                const SizedBox(width: 8),
                const Text(
                  'User Demographics',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDemographicItem('Age 18-25', 35, const Color(0xFF2563EB)),
            _buildDemographicItem('Age 26-35', 42, const Color(0xFF059669)),
            _buildDemographicItem('Age 36-45', 18, const Color(0xFF7C3AED)),
            _buildDemographicItem('Age 45+', 5, const Color(0xFFF59E0B)),
          ],
        ),
      ),
    ),
  ];
}

  List<Widget> _buildDeviceReportContent(Report report) {
    final metrics = report.metrics ?? {};
    
    return [
      // Device Distribution Summary
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Android',
              '${metrics['androidUsers']?['value'] ?? 65}%',
              metrics['androidUsers']?['trend'] ?? 2,
              Icons.android,
              const Color(0xFF34A853),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'iOS',
              '${metrics['iosUsers']?['value'] ?? 32}%',
              metrics['iosUsers']?['trend'] ?? -1,
              Icons.phone_iphone,
              const Color(0xFF007AFF),
            ),
          ),
        ],
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              'Other',
              '${metrics['otherUsers']?['value'] ?? 3}%',
              metrics['otherUsers']?['trend'] ?? -1,
              Icons.devices_other,
              const Color(0xFF6B7280),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              'Total Devices',
              '45.2K',
              850,
              Icons.devices,
              const Color(0xFF7C3AED),
            ),
          ),
        ],
      ),
      const SizedBox(height: 20),

      // Device Distribution Chart
      Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Device Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      height: 200,
                      child: CustomPaint(
                        painter: DevicePieChartPainter(metrics),
                        size: const Size(200, 200),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPieLegendItem('Android', '${metrics['androidUsers']?['value'] ?? 65}%', const Color(0xFF34A853)),
                        const SizedBox(height: 16),
                        _buildPieLegendItem('iOS', '${metrics['iosUsers']?['value'] ?? 32}%', const Color(0xFF007AFF)),
                        const SizedBox(height: 16),
                        _buildPieLegendItem('Other', '${metrics['otherUsers']?['value'] ?? 3}%', const Color(0xFF6B7280)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),

      // Device Performance
      Card(
        elevation: 2,
        shadowColor: Colors.black12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Device Performance Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 16),
              _buildDevicePerformanceItem('Android', 'Avg Speed: 45.2 Mbps', 'Battery Usage: Low', const Color(0xFF34A853)),
              _buildDevicePerformanceItem('iOS', 'Avg Speed: 52.1 Mbps', 'Battery Usage: Medium', const Color(0xFF007AFF)),
              _buildDevicePerformanceItem('Other', 'Avg Speed: 38.7 Mbps', 'Battery Usage: High', const Color(0xFF6B7280)),
            ],
          ),
        ),
      ),
    ];
  }

  Widget _buildSummaryCard(String title, String value, dynamic trend, IconData icon, Color color) {
    final isPositive = (trend is num) ? trend > 0 : false;
    final trendValue = (trend is num) ? trend.abs() : 0;
    
    return Card(
      elevation: 1,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green.shade100 : Colors.red.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        size: 12,
                        color: isPositive ? Colors.green.shade600 : Colors.red.shade600,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        '${isPositive ? '+' : ''}$trendValue',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isPositive ? Colors.green.shade600 : Colors.red.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildRegionalItem(String city, Map<String, dynamic> data) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              city,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Latency: ${data['latency']}ms', style: const TextStyle(fontSize: 12)),
                    Text('${data['performance']}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: data['performance'] / 100,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    data['performance'] > 80 ? Colors.green : data['performance'] > 60 ? Colors.orange : Colors.red,
                  ),
                  minHeight: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemographicItem(String label, int percentage, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPieLegendItem(String platform, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              platform,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF374151),
              ),
            ),
            Text(
              percentage,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDevicePerformanceItem(String device, String speed, String battery, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              device == 'Android' ? Icons.android : device == 'iOS' ? Icons.phone_iphone : Icons.devices_other,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  device,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  speed,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
                Text(
                  battery,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getRegionalData(String city) {
    switch (city) {
      case 'Douala':
        return {'latency': 38, 'performance': 92};
      case 'Yaoundé':
        return {'latency': 42, 'performance': 88};
      case 'Bamenda':
        return {'latency': 45, 'performance': 85};
      case 'Bafoussam':
        return {'latency': 48, 'performance': 82};
      default:
        return {'latency': 50, 'performance': 75};
    }
  }
}

// Active Users Line Chart Painter
class ActiveUsersLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF059669)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFF059669)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Sample data for active users over 7 days
    final data = [26200, 27100, 27800, 28200, 28450, 28600, 28450];
    final path = Path();
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    // Draw the line
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - ((data[i] - minValue) / (maxValue - minValue)) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw data points
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
      
      // Draw value labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${(data[i] / 1000).toStringAsFixed(1)}K',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 20));
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Session Time Bar Chart Painter
class SessionTimeBarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Sample data for session time over 7 days (in minutes)
    final data = [22, 24, 23, 26, 25, 28, 24];
    final maxValue = data.reduce((a, b) => a > b ? a : b).toDouble();
    final barWidth = (size.width / data.length) * 0.6;
    final barSpacing = (size.width / data.length) * 0.4;

    for (int i = 0; i < data.length; i++) {
      final x = (size.width / data.length) * i + barSpacing / 2;
      final height = (data[i] / maxValue) * size.height * 0.8;
      
      // Create gradient effect
      paint.color = Color.lerp(
        const Color(0xFF93C5FD),
        const Color(0xFF2563EB),
        data[i] / maxValue,
      )!;

      // Draw bar with rounded corners
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, size.height - height, barWidth, height),
        const Radius.circular(4),
      );
      canvas.drawRRect(rect, paint);

      // Draw value labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${data[i]}m',
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, size.height - height - 20),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Retention Rate Line Chart Painter
class RetentionRateLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final pointPaint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = const Color(0xFFE5E7EB)
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i <= 4; i++) {
      final y = (size.height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    // Sample data for retention rate over 4 weeks (percentage)
    final data = [76.0, 78.0, 79.0, 78.0];
    final path = Path();
    final minValue = 70.0;
    final maxValue = 85.0;

    // Draw the line
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - ((data[i] - minValue) / (maxValue - minValue)) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw data points with larger circles
      canvas.drawCircle(Offset(x, y), 5, pointPaint);
      
      // Draw white center for donut effect
      canvas.drawCircle(Offset(x, y), 2, Paint()..color = Colors.white);

      // Draw value labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${data[i].toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF374151),
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - 25));
    }

    canvas.drawPath(path, paint);

    // Draw trend area (optional)
    final areaPaint = Paint()
      ..color = const Color(0xFF7C3AED).withOpacity(0.1)
      ..style = PaintingStyle.fill;

    final areaPath = Path();
    areaPath.moveTo(0, size.height);
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - ((data[i] - minValue) / (maxValue - minValue)) * size.height;
      if (i == 0) {
        areaPath.lineTo(x, y);
      } else {
        areaPath.lineTo(x, y);
      }
    }
    areaPath.lineTo(size.width, size.height);
    areaPath.close();
    canvas.drawPath(areaPath, areaPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
// Custom Painters for Charts
class NetworkPerformanceChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Draw latency line (blue)
    paint.color = const Color(0xFF2563EB);
    final latencyData = [45.0, 43.0, 44.0, 42.0, 41.0, 40.0, 42.0];
    _drawLine(canvas, size, latencyData, 35, 50);

    // Draw throughput line (green) - scaled down
    paint.color = const Color(0xFF059669);
    final throughputData = [142, 148, 152, 158, 160, 163, 156];
    _drawLine(canvas, size, throughputData.map((e) => e / 4).toList(), 30, 45);

    // Draw error rate line (red) - scaled up
    paint.color = const Color(0xFFDC2626);
    final errorData = [1.8, 1.9, 2.0, 2.1, 2.2, 2.3, 2.4];
    _drawLine(canvas, size, errorData.map((e) => e * 20).toList(), 30, 50);
  }

  void _drawLine(Canvas canvas, Size size, List<double> data, double minVal, double maxVal) {
    final paint = Paint()
      ..color = const Color(0xFF2563EB)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - ((data[i] - minVal) / (maxVal - minVal)) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      // Draw points
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = paint.color..style = PaintingStyle.fill);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class UserEngagementChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF7C3AED)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final data = [26200, 27100, 27800, 28200, 28450, 28600, 28450];
    final path = Path();
    final minValue = data.reduce((a, b) => a < b ? a : b);
    final maxValue = data.reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - ((data[i] - minValue) / (maxValue - minValue)) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }

      canvas.drawCircle(Offset(x, y), 4, Paint()..color = paint.color..style = PaintingStyle.fill);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DevicePieChartPainter extends CustomPainter {
  final Map<String, dynamic> metrics;

  DevicePieChartPainter(this.metrics);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.35;

    final androidValue = (metrics['androidUsers']?['value'] ?? 65) / 100;
    final iosValue = (metrics['iosUsers']?['value'] ?? 32) / 100;
    final otherValue = (metrics['otherUsers']?['value'] ?? 3) / 100;

    final paint = Paint()..style = PaintingStyle.fill;

    // Android slice
    paint.color = const Color(0xFF34A853);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      2 * 3.14159 * androidValue,
      true,
      paint,
    );

    // iOS slice
    paint.color = const Color(0xFF007AFF);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708 + 2 * 3.14159 * androidValue,
      2 * 3.14159 * iosValue,
      true,
      paint,
    );

    // Other slice
    paint.color = const Color(0xFF6B7280);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708 + 2 * 3.14159 * (androidValue + iosValue),
      2 * 3.14159 * otherValue,
      true,
      paint,
    );

    // Draw center circle for donut effect
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
