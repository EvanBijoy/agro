import 'package:agro/main.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'app_colors.dart';
import 'data.dart';
import 'line_chart.dart';

bool showAvg = false;

class AnalyticsSection extends StatefulWidget {
  const AnalyticsSection({Key? key});

  @override
  State<AnalyticsSection> createState() => _AnalyticsSectionState();
}

class _AnalyticsSectionState extends State<AnalyticsSection> {

  void refresh()
  {
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {

    print('rebuilding');
    print(moisPlot.length);

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
                Text( getHeading(),
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                Expanded(
                  child: SfCartesianChart(
                      primaryXAxis: NumericAxis(minimum: 0, maximum: 2000),
                      primaryYAxis: NumericAxis(minimum: 0, maximum: y_max.toDouble(), interval: y_interval.toDouble()),
                      // tooltipBehavior: _tooltip,
                      series: <CartesianSeries<Data, int>>[
                        AreaSeries<Data, int>(
                            dataSource: moisMotorOnPlot,
                            xValueMapper: (Data data, _) => data.index,
                            yValueMapper: (Data data, _) => data.mois,
                            name: 'Gold',
                            color: Color.fromARGB(180, 255, 255, 0),
                        ),
                      AreaSeries<Data, int>(
                          dataSource: moisMotorOffPlot,
                          xValueMapper: (Data data, _) => data.index,
                          yValueMapper: (Data data, _) {
                            switch (which) {
                              case 1:
                                return data.temp;
                              case 2:
                                return data.mois;
                              case 3:
                                return data.humd;
                            }
                          },
                          name: 'Gold2',
                          color: Color.fromARGB(100, 0, 200, 255),
                      )
                      ],
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
          ),
        ),
      ],
    );
  }
}

String getHeading()
{
  switch (which)
  {
    case 1:
      return 'Temperature';
    case 2:
      return 'Moisture';
    case 3:
      return 'Humidity';
  }
  return 'Invalid';
}