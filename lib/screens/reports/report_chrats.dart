import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final int? y;
}

//*///////////// BAR CHART /////////////////////////////////////////////////////
class BarChart extends StatelessWidget {
  const BarChart({super.key, required this.dataList, this.yAxisTitleText});
  final List<ChartData> dataList;
  final String? yAxisTitleText;
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
        isTransposed: true,
        primaryXAxis: CategoryAxis(labelRotation: -20), // In degrees
        primaryYAxis: NumericAxis(title: AxisTitle(text: yAxisTitleText),),
        tooltipBehavior: TooltipBehavior(enable: true, duration: 1),
        zoomPanBehavior: ZoomPanBehavior(enablePinching: true, enableSelectionZooming: true, enablePanning: true),
        series: <BarSeries<ChartData, String>>[
          // Renders bar chart
          BarSeries<ChartData, String>(
            dataSource: dataList,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            width: 0.5,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),
            pointColorMapper: (datum, index) {
              if (datum.x == 'فول') {
                return Colors.brown;
              }
              if (datum.x == 'لن أفطر معكم') {
                return Colors.indigo;
              }
              return null;
            },
          )
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
      legend: Legend(isVisible: true, position: LegendPosition.top),
      tooltipBehavior: TooltipBehavior(enable: true, duration: 1),
      series: <CircularSeries>[
        PieSeries<ChartData, String>(
          dataSource: dataList,
          xValueMapper: (ChartData data, index) => data.x,
          yValueMapper: (ChartData data, index) => data.y,

          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
          ),
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
          // explodeIndex: 0,
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
      legend: Legend(isVisible: true, position: LegendPosition.top),
      tooltipBehavior: TooltipBehavior(enable: true, duration: 1),
      series: <CircularSeries>[
        DoughnutSeries<ChartData, String>(
            dataSource: dataList,
            xValueMapper: (datum, index) => datum.x,
            yValueMapper: (datum, index) => datum.y,
            dataLabelSettings: const DataLabelSettings(
              isVisible: true,
            ),
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
            cornerStyle: CornerStyle.endCurve,
          )
      ],
    );
  }
}
//*///////////// Generic CHART /////////////////////////////////////////////////////
/// A widget that accepts the chart type as a string parameter and returns a certain
/// Chart depending on that string.

class GenericChart extends StatelessWidget {
  final List<ChartData> dataList;
  final String type;
  const GenericChart({super.key, required this.type, required this.dataList});

  @override
  Widget build(BuildContext context) {
    return type == 'Pie'
        ? PieChart(dataList: dataList)
        : (type == 'Doughnut'
            ? DoughnutChart(dataList: dataList)
            : BarChart(dataList: dataList));
  }
}
