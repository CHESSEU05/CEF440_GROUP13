import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/notification_bell.dart';
import '../widgets/navigation_bar.dart';

class DashboardScreen extends StatelessWidget {
  final AppState appState;

  const DashboardScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    // Ensure we have valid data
    final currentData = timeframeData[appState.dateRange] ?? timeframeData["Last 7 Days"]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text(
          'Feedback Analytics Dashboard',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        shadowColor: Colors.black12,
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

                  // Date Range Selector
                  Container(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: ['Last 7 Days', 'Last 30 Days', '6 Months', '1 Year', 'Custom']
                          .map((range) => Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: Material(
                                  borderRadius: BorderRadius.circular(20),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(20),
                                    onTap: () => appState.setDateRange(range),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: appState.dateRange == range 
                                            ? const Color(0xFF2563EB) 
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: appState.dateRange == range 
                                              ? const Color(0xFF2563EB) 
                                              : const Color(0xFFE5E7EB),
                                        ),
                                      ),
                                      child: Text(
                                        range,
                                        style: TextStyle(
                                          color: appState.dateRange == range ? Colors.white : const Color(0xFF374151),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // KPIs Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      _buildKPICard(
                        'Total Complaints', 
                        '${currentData['totalComplaints']}',
                        Icons.warning_amber_outlined,
                        const Color(0xFF2563EB),
                      ),
                      _buildKPICard(
                        'Avg Signal (dBm)', 
                        '${currentData['avgSignal']} dBm',
                        Icons.signal_cellular_alt,
                        const Color(0xFFDC2626),
                      ),
                      _buildKPICard(
                        'Avg Latency (ms)', 
                        '${currentData['avgLatency']} ms',
                        Icons.speed,
                        const Color(0xFF7C3AED),
                      ),
                      _buildKPICard(
                        'Top Location', 
                        '${currentData['topLocation']}',
                        Icons.location_on_outlined,
                        const Color(0xFF059669),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Chart Card
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
                            'Number of Complaints by Day',
                            style: TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Chart Container
                          Container(
                            height: 240,
                            width: double.infinity,
                            child: CustomPaint(
                              painter: ImprovedBarChartPainter(),
                              size: const Size(double.infinity, 240),
                            ),
                          ),
                          const SizedBox(height: 20),
                          
                          // Legend
                          Wrap(
                            spacing: 16,
                            runSpacing: 8,
                            children: [
                              _buildLegendItem('Social Media Issues', const Color(0xFF3B82F6)),
                              _buildLegendItem('Call Drops', const Color(0xFFEF4444)),
                              _buildLegendItem('Billing Errors', const Color(0xFFF59E0B)),
                            ],
                          ),
                          const SizedBox(height: 20),
                          
                          const Divider(color: Color(0xFFE5E7EB)),
                          const SizedBox(height: 16),
                          
                          // Additional Info Section
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Network Metrics',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    _buildMetricItem('Good Signal (>-70 dBm)', const Color(0xFF10B981)),
                                    _buildMetricItem('Poor Signal (<-80 dBm)', const Color(0xFFEF4444)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Top Locations',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF374151),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    ...locationData.take(3).map((location) => 
                                      _buildLocationItem(location.name, location.complaints)
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
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

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
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

  Widget _buildLegendItem(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: BorderRadius.circular(6),
        color: color.withOpacity(0.05),
      ),
      child: Row(
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
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationItem(String name, int complaints) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
          Text(
            '$complaints',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
        ],
      ),
    );
  }
}

class ImprovedBarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
    );
    
    // Chart dimensions
    final chartLeft = 40.0;
    final chartRight = size.width - 20;
    final chartTop = 20.0;
    final chartBottom = size.height - 40;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;
    
    // Draw Y-axis
    paint.color = const Color(0xFFE5E7EB);
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(chartLeft, chartTop),
      Offset(chartLeft, chartBottom),
      paint,
    );
    
    // Draw Y-axis labels and grid lines
    final maxValue = complaintsByDayData.map((e) => e.total).reduce((a, b) => a > b ? a : b);
    final ySteps = [0, 25, 50, 75, 100, 125];
    
    for (final step in ySteps) {
      if (step <= maxValue) {
        final y = chartBottom - (step / maxValue) * chartHeight;
        
        // Grid line
        paint.color = const Color(0xFFF3F4F6);
        paint.strokeWidth = 1;
        if (step > 0) {
          canvas.drawLine(
            Offset(chartLeft, y),
            Offset(chartRight, y),
            paint,
          );
        }
        
        // Y-axis label
        textPainter.text = TextSpan(
          text: '$step',
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF6B7280),
          ),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          Offset(chartLeft - textPainter.width - 8, y - textPainter.height / 2),
        );
      }
    }
    
    // Draw X-axis
    paint.color = const Color(0xFFE5E7EB);
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(chartLeft, chartBottom),
      Offset(chartRight, chartBottom),
      paint,
    );
    
    // Draw bars
    final barWidth = (chartWidth / complaintsByDayData.length) * 0.7;
    final barSpacing = (chartWidth / complaintsByDayData.length) * 0.3;
    
    for (int i = 0; i < complaintsByDayData.length; i++) {
      final data = complaintsByDayData[i];
      final x = chartLeft + (chartWidth / complaintsByDayData.length) * i + barSpacing / 2;
      
      // Calculate heights for stacked bars
      final socialHeight = (data.social / maxValue) * chartHeight;
      final callsHeight = (data.calls / maxValue) * chartHeight;
      final billingHeight = (data.billing / maxValue) * chartHeight;
      
      double currentY = chartBottom;
      
      // Draw billing errors (bottom)
      paint.color = const Color(0xFFF59E0B);
      final billingRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, currentY - billingHeight, barWidth, billingHeight),
        const Radius.circular(2),
      );
      canvas.drawRRect(billingRect, paint);
      currentY -= billingHeight;
      
      // Draw call drops (middle)
      paint.color = const Color(0xFFEF4444);
      final callsRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, currentY - callsHeight, barWidth, callsHeight),
        const Radius.circular(2),
      );
      canvas.drawRRect(callsRect, paint);
      currentY -= callsHeight;
      
      // Draw social media issues (top)
      paint.color = const Color(0xFF3B82F6);
      final socialRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, currentY - socialHeight, barWidth, socialHeight),
        const Radius.circular(2),
      );
      canvas.drawRRect(socialRect, paint);
      
      // Draw total value on top
      textPainter.text = TextSpan(
        text: '${data.total}',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: Color(0xFF374151),
        ),
      );
      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(
          x + barWidth / 2 - textPainter.width / 2,
          currentY - socialHeight - textPainter.height - 4,
        ),
      );
      
      // Draw day label
      final dayLabel = data.day.split(', ')[0]; // Get just the day part
      textPainter.text = TextSpan(
        text: dayLabel,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF6B7280),
        ),
      );
      textPainter.layout();
      
      canvas.save();
      canvas.translate(x + barWidth / 2, chartBottom + 20);
      canvas.rotate(-0.5); // Slight rotation for better fit
      textPainter.paint(canvas, Offset(-textPainter.width / 2, 0));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
