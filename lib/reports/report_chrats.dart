import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int? y;
}

//*///////////// BAR CHART /////////////////////////////////////////////////////
class BarChart extends StatelessWidget {
  const BarChart({super.key, required this.dataList});
  final List<ChartData> dataList;
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        isTransposed: true,
        primaryXAxis: CategoryAxis(labelRotation: -30),
        primaryYAxis: NumericAxis(
          interval: 1,
        ),
        series: <BarSeries<ChartData, String>>[
          // Renders bar chart
          BarSeries<ChartData, String>(
              dataSource: dataList,
              xValueMapper: (ChartData data, _) => data.x,
              yValueMapper: (ChartData data, _) => data.y,
              width: 0.5,
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20), topLeft: Radius.circular(20)))
        ]);
  }
}

//*///////////// PIE CHART /////////////////////////////////////////////////////
class PieChart extends StatelessWidget {
  const PieChart({super.key, required this.dataList});
  final List<ChartData> dataList;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true, duration: 1),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, index) => data.x,
          yValueMapper: (ChartData data, index) => data.y,

          dataLabelSettings: const DataLabelSettings(isVisible: true,),
          // Color the segmments depending on the value. If no color is provided it will be auto generated.
          pointColorMapper: (ChartData datum, index) {
            if (datum.x == 'فول') {
              return Colors.brown;
            }
            if (datum.x == 'لن أفطر معكم') {
              return Colors.indigo;
            }
            return null;
          },
          // Segments will explode on tap
          explode: true,
          // Index i segment will be exploded on initial rendering
          explodeIndex: 0,
          // Radius for each segment from data source
          
        )
      ],
    );
  }
}

//*///////////// Doughnut CHART /////////////////////////////////////////////////////
class DoughnutChart extends StatelessWidget {
  const DoughnutChart({super.key, required this.dataList});
  final List<ChartData> dataList;

  @override
  Widget build(BuildContext context) {
    return SfCircularChart(
      legend: Legend(isVisible: true),
      tooltipBehavior: TooltipBehavior(enable: true, duration: 1),
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (datum, index) => datum.x,
          yValueMapper: (datum, index) => datum.y,

          dataLabelSettings: const DataLabelSettings(isVisible: true,),
          // Color the segmments depending on the value. If no color is provided it will be auto generated.
          pointColorMapper: (ChartData datum, index) {
            if (datum.x == 'فول') {
              return Colors.brown;
            }
            if (datum.x == 'لن أفطر معكم') {
              return Colors.indigo;
            }
            return null;
          },
          explode: true,
          innerRadius: '60%',
          cornerStyle: CornerStyle.endCurve
        )
      ],
    );
  }
}