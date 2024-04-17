import 'package:flutter/material.dart';

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[700],
      child: const Center(
        child: Text(
          'Analytics',
          style: TextStyle(color: Colors.white, fontSize: 24.0),
        ),
      ),
    );
  }
}
