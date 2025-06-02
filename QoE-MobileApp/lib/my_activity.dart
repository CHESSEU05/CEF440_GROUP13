import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityPage extends StatefulWidget {
  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  int _selectedIndex = 1; // Activity tab is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Color(0xFF4A90E2), // Contrasting blue color for AppBar
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Activity',
          style: GoogleFonts.notoSans(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Activity Items
            ActivityItem(
              icon: Icons.wifi_off,
              title: 'Slow Data',
              time: '1 week ago',
              description: "I'm having trouble with my data connection. It's very slow and sometimes doesn't work at all.",
              status: ActivityStatus.issue,
            ),
            ActivityItem(
              icon: Icons.signal_cellular_off,
              title: 'No Service',
              time: '2 weeks ago',
              description: "My phone says I have no service, but I should be able to use it.",
              status: ActivityStatus.resolved,
            ),
            ActivityItem(
              icon: Icons.call,
              title: 'Call Quality',
              time: '3 weeks ago',
              description: "The call quality is really bad. I can barely hear the other person and they can't hear me either.",
              status: ActivityStatus.issue,
            ),
            ActivityItem(
              icon: Icons.wifi,
              title: 'Slow Data',
              time: 'Today, 3:45 PM',
              description: "I'm experiencing slow data speed again.",
              status: ActivityStatus.active,
            ),

            // Legend Section
            Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  LegendItem(color: Colors.green, label: 'Resolved'),
                  SizedBox(width: 16),
                  LegendItem(color: Colors.orange, label: 'Pending'),
                  SizedBox(width: 16),
                  LegendItem(color: Colors.red, label: 'Unresolved'),
                ],
              ),
            ),

            SizedBox(height: 32),

            // Feedback Surveys Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Feedback Surveys',
                    style: GoogleFonts.notoSans(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'How was your experience with...',
                        style: GoogleFonts.notoSans(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'View Details',
                          style: GoogleFonts.notoSans(
                            color: Colors.blue[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // Rating Section
                  Row(
                    children: [
                      Text(
                        '4.5',
                        style: GoogleFonts.notoSans(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          children: [
                            RatingBar(stars: 5, percentage: 0.5),
                            RatingBar(stars: 4, percentage: 0.4),
                            RatingBar(stars: 3, percentage: 0.08),
                            RatingBar(stars: 2, percentage: 0.02),
                            RatingBar(stars: 1, percentage: 0.0),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    children: [
                      Row(
                        children: List.generate(4, (index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        )) + [Icon(Icons.star_border, color: Colors.amber, size: 16)],
                      ),
                      SizedBox(width: 8),
                      Text(
                        '300 reviews',
                        style: GoogleFonts.notoSans(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 32), // Adjusted space since navbar is removed
          ],
        ),
      ),
    );
  }
}

enum ActivityStatus { issue, resolved, active }

class ActivityItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String time;
  final String description;
  final ActivityStatus status;

  const ActivityItem({
    Key? key,
    required this.icon,
    required this.title,
    required this.time,
    required this.description,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    Color backgroundColor;
    Color borderColor;

    switch (status) {
      case ActivityStatus.issue:
        statusColor = Colors.red;
        backgroundColor = Colors.red[50]!;
        borderColor = Colors.red[200]!;
        break;
      case ActivityStatus.resolved:
        statusColor = Colors.green;
        backgroundColor = Colors.green[50]!;
        borderColor = Colors.green[200]!;
        break;
      case ActivityStatus.active:
        statusColor = Colors.orange;
        backgroundColor = Colors.orange[50]!;
        borderColor = Colors.orange[200]!;
        break;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: statusColor,
                  size: 20,
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.notoSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      time,
                      style: GoogleFonts.notoSans(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            description,
            style: GoogleFonts.notoSans(
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class RatingBar extends StatelessWidget {
  final int stars;
  final double percentage;

  const RatingBar({
    Key? key,
    required this.stars,
    required this.percentage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$stars',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 8,
              child: LinearProgressIndicator(
                value: percentage,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue[600]!),
              ),
            ),
          ),
          SizedBox(width: 8),
          Text(
            '${(percentage * 100).toInt()}%',
            style: GoogleFonts.notoSans(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

// New LegendItem widget
class LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const LegendItem({
    Key? key,
    required this.color,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.notoSans(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}

// Usage in your main app
class MyActivityScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Activity Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ActivityPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}