import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Light theme color palette
const Color primaryColor = Color(0xFF4A90E2);
const Color primaryDarkColor = Color(0xFF3A7BC8);
const Color cardBackgroundColor = Colors.white;
const Color surfaceColor = Color(0xFFF5F7FA);
const Color textColor = Color(0xFF2A3B5C);
const Color subtleTextColor = Color(0xFF6D7A8D);
const Color errorColor = Color(0xFFE53935);
const Color successColor = Color(0xFF43A047);
const Color borderColor = Color(0xFFE0E0E0);

class IssueReportingFormDialog extends StatefulWidget {
  @override
  _IssueReportingFormDialogState createState() => _IssueReportingFormDialogState();
}

class _IssueReportingFormDialogState extends State<IssueReportingFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _focusNode = FocusNode();

  String? _selectedOperator;
  String? _selectedIssueType;
  String? _selectedActivity;
  String _issueDetails = '';

  final List<String> _operators = ['MTN', 'ORANGE', 'CAMTEL', 'Nexttel'];
  final List<String> _issueTypes = ['No Service', 'Poor Signal', 'Slow Internet Speed', 'Call Drop', 'Others'];
  final List<String> _activities = [
    'Social Media (Instagram, Facebook, X...)',
    'Video Streaming (YouTube, Netflix...)',
    'Online Gaming',
    'Messaging (WhatsApp, SMS...)',
    'Online Work (Zoom, Google Meet...)',
    'Web Browsing',
    'Others'
  ];

  Widget _buildDropdown({
    required String label,
    required String? currentValue,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.notoSans(
            color: textColor.withOpacity(0.9),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: surfaceColor,
            border: Border.all(color: borderColor, width: 1),
          ),
          child: DropdownButtonFormField<String>(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: InputBorder.none,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: primaryColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: errorColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: errorColor, width: 1.5),
              ),
            ),
            dropdownColor: Colors.white,
            style: GoogleFonts.notoSans(color: textColor),
            value: currentValue,
            isExpanded: true,
            hint: Text(
              'Select an option',
              style: GoogleFonts.notoSans(color: subtleTextColor),
            ),
            icon: Icon(Icons.arrow_drop_down, color: subtleTextColor),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: GoogleFonts.notoSans(color: textColor),
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: onChanged,
            validator: (value) => value == null ? 'This field is required' : null,
          ),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Report Network Issue',
                      style: GoogleFonts.notoSans(
                        color: textColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: subtleTextColor),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Help us improve by reporting network problems you encounter',
                  style: GoogleFonts.notoSans(
                    color: subtleTextColor,
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 24),
                _buildDropdown(
                  label: 'Network Operator',
                  currentValue: _selectedOperator,
                  items: _operators,
                  onChanged: (value) => setState(() => _selectedOperator = value),
                ),
                _buildDropdown(
                  label: 'Issue Type',
                  currentValue: _selectedIssueType,
                  items: _issueTypes,
                  onChanged: (value) => setState(() => _selectedIssueType = value),
                ),
                _buildDropdown(
                  label: 'Activity During Issue',
                  currentValue: _selectedActivity,
                  items: _activities,
                  onChanged: (value) => setState(() => _selectedActivity = value),
                ),
                Text(
                  'Issue Description',
                  style: GoogleFonts.notoSans(
                    color: textColor.withOpacity(0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  focusNode: _focusNode,
                  style: GoogleFonts.notoSans(color: textColor),
                  decoration: InputDecoration(
                    hintText: 'Describe what happened...',
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
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: errorColor),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: errorColor, width: 1.5),
                    ),
                  ),
                  maxLines: 4,
                  onSaved: (value) => _issueDetails = value ?? '',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please describe the issue';
                    }
                    if (value.length < 10) {
                      return 'Please provide more details';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                Text(
                  'Provide as much detail as possible about when and where the issue occurred',
                  style: GoogleFonts.notoSans(
                    color: subtleTextColor,
                    fontSize: 12,
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        // Process the data
                        print('Operator: $_selectedOperator');
                        print('Issue Type: $_selectedIssueType');
                        print('Activity: $_selectedActivity');
                        print('Details: $_issueDetails');

                        Navigator.of(context).pop();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Issue reported successfully!'),
                            backgroundColor: successColor,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      'Submit Report',
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
      ),
    );
  }
}