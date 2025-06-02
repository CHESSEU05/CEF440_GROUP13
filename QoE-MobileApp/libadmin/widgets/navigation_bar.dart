import 'package:flutter/material.dart';
import '../models/app_state.dart';

class CustomNavigationBar extends StatelessWidget {
  final AppState appState;

  const CustomNavigationBar({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                Icons.bar_chart,
                'Analytics Dashboard',
                Screen.dashboard,
                appState.currentScreen == Screen.dashboard,
              ),
              _buildNavItem(
                Icons.trending_up,
                'Feedback Insights',
                Screen.feedbackInsights,
                appState.currentScreen == Screen.feedbackInsights,
              ),
              _buildNavItem(
                Icons.description,
                'Reports',
                Screen.reports,
                appState.currentScreen == Screen.reports,
              ),
              _buildNavItem(
                Icons.person,
                'Profile',
                Screen.profile,
                appState.currentScreen == Screen.profile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, Screen screen, bool isActive) {
    return GestureDetector(
      onTap: () => appState.setCurrentScreen(screen),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? Colors.blue : Colors.grey,
            size: 20,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? Colors.blue : Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
