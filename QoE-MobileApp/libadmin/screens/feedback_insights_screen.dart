import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../widgets/notification_bell.dart';
import '../widgets/navigation_bar.dart';

class FeedbackInsightsScreen extends StatelessWidget {
  final AppState appState;

  const FeedbackInsightsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Colors.white,

      appBar: AppBar(
        title: const Text('Feedback Insights'),
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

                  // User Feedback Summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Feedback Summary',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                '${feedbackData.overall}',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: List.generate(4, (index) => 
                                  const Icon(Icons.star, color: Colors.amber, size: 20)
                                ) + [const Icon(Icons.star_half, color: Colors.amber, size: 20)],
                              ),
                              const SizedBox(width: 16),
                              Text(
                                '${feedbackData.total} total reviews',
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ...feedbackData.breakdown.entries.map((entry) => 
                            _buildRatingBar(entry.key, entry.value)
                          ).toList().reversed,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Overall Satisfaction
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overall Satisfaction',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                '${feedbackData.satisfaction.current}%',
                                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(width: 16),
                              Row(
                                children: [
                                  const Icon(Icons.trending_up, color: Colors.green, size: 16),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${feedbackData.satisfaction.trend}% from last month',
                                    style: const TextStyle(color: Colors.green, fontSize: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 120,
                            width: double.infinity,
                            child: CustomPaint(
                              painter: SatisfactionChartPainter(feedbackData.satisfaction.monthly),
                              size: const Size(double.infinity, 120),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Feedback Breakdown
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Feedback Breakdown',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          ...feedbackData.categories.entries.map((entry) => 
                            _buildCategoryItem(entry.key, entry.value)
                          ),
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

  Widget _buildRatingBar(int rating, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: Text('$rating★', style: const TextStyle(fontSize: 14)),
          ),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage / 100,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 48,
            child: Text(
              '$percentage%',
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String category, CategoryData data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(category, style: const TextStyle(fontWeight: FontWeight.w500)),
              Row(
                children: [
                  Text('${data.score}', style: const TextStyle(fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Icon(
                    data.trend > 0 ? Icons.trending_up : Icons.trending_down,
                    color: data.trend > 0 ? Colors.green : Colors.red,
                    size: 16,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: data.score / 5,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
          ),
        ],
      ),
    );
  }
}

class SatisfactionChartPainter extends CustomPainter {
  final List<int> data;

  SatisfactionChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    final gridPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 1;
    
    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    
    // Draw grid lines
    for (int i = 0; i <= 3; i++) {
      final y = size.height - (size.height / 3) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    
    // Draw axis labels
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.right,
    );
    
    for (int i = 0; i <= 3; i++) {
      final value = 70 + i * 10;
      final y = size.height - (size.height / 3) * i;
      
      textPainter.text = TextSpan(
        text: '$value%',
        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(-textPainter.width - 5, y - textPainter.height / 2));
    }
    
    // Draw the line chart
    final path = Path();
    
    for (int i = 0; i < data.length; i++) {
      final x = (size.width / (data.length - 1)) * i;
      final y = size.height - ((data[i] - 70) / 30) * size.height;
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
      
      // Draw points
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
    
    canvas.drawPath(path, paint);
    
    // Draw month labels
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    for (int i = 0; i < months.length; i++) {
      final x = (size.width / (months.length - 1)) * i;
      
      textPainter.text = TextSpan(
        text: months[i],
        style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height + 5));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
