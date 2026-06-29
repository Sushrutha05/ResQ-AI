import 'package:flutter/material.dart';


class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.indigo),
            SizedBox(height: 16),
            Text(
              'Calendar & Timeline',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Visualize schedule and resolve conflicts.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}

// Removed AICoachScreen

