import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';



class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('صفحة التقارير'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: SfCartesianChart(
            isTransposed: true,
            primaryXAxis: CategoryAxis(),
            primaryYAxis: NumericAxis(
              interval: 3,
            ),
            series: <BarSeries<ChartData, String>>[
            // Renders bar chart
            BarSeries<ChartData, String>(
                dataSource: chartData,
                xValueMapper: (ChartData data, _) => data.x,
                yValueMapper: (ChartData data, _) => data.y,
                width: 0.5,
                borderRadius: const BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20))
              )
          ]
          ),
        ),
      ),
    );
  }
}
// The data source
final List<ChartData> chartData = [
            ChartData('فول', 35),
            ChartData('غيره', 28),
            ChartData('لن أفطر', 34),
        ];

class ChartData {
        ChartData(this.x, this.y);
        final String x;
        final double? y;
    }