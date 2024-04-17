import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({Key? key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[700],
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Moisture Level',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 7,
                      minY: 0,
                      maxY: 100,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 20), // Sample data, replace with your actual data
                            FlSpot(1, 40),
                            FlSpot(2, 30),
                            FlSpot(3, 80),
                            FlSpot(4, 90),
                            FlSpot(5, 70),
                            FlSpot(6, 50),
                            FlSpot(7, 60),
                          ],
                          colors: [Colors.red], // Change color to red
                          isCurved: true,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Temperature',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Expanded(
                  child: LineChart(
                    LineChartData(
                      minX: 0,
                      maxX: 7,
                      minY: 0,
                      maxY: 40,
                      lineBarsData: [
                        LineChartBarData(
                          spots: [
                            FlSpot(0, 15), // Sample data, replace with your actual data
                            FlSpot(1, 18),
                            FlSpot(2, 20),
                            FlSpot(3, 25),
                            FlSpot(4, 22),
                            FlSpot(5, 28),
                            FlSpot(6, 30),
                            FlSpot(7, 29),
                          ],
                          colors: [Colors.green], // Change color to green
                          isCurved: true,
                          dotData: FlDotData(show: true),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}