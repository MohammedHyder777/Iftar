import 'package:flutter/material.dart';
import 'package:iftar/data.dart';
import 'package:iftar/reports/report_chrats.dart';
import 'package:iftar/services/database.dart';
import 'package:provider/provider.dart';


//*//////////////// FUNCTIONS: /////////////////////////////////////////////////
int countFoodOrders(String type, List<Data> data) {
    int count = 0;
    for (var user in data) {
      if (user.food == type) {
        count++;
      }
    }
    return count;
  }
//*//////////////// CLASSES: ///////////////////////////////////////////////////

class ReportScreen extends StatefulWidget {
  
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  String chartType = 'Bar';
  Widget? choosenChart;

  @override
  Widget build(BuildContext context) {

    return StreamProvider<List<Data>>.value(
      initialData: const [],
      value: DatabaseService().document,
      builder:(icontext, child) {
        List<ChartData> chartDataList = [];
        final data = Provider.of<List<Data>>(icontext);
        for (var e in ['فول', 'غير الفول', 'لن أفطر معكم']) {
          chartDataList.add(ChartData(e, countFoodOrders(e, data)));
        }
        print(chartDataList.first.y);
        choosenChart ??= BarChart(dataList: chartDataList);//BarChart(dataList: chartDataList); // If ?? is not used Barchart will be assigned to choosenChart at every build call and the chart will never change.
        return Scaffold(
        appBar: AppBar(
          title: const Text('صفحة التقارير'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0,22.0,18.0,36.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DropdownButton<String>(
                      value: chartType,
                      items: ['Bar','Pie','Doughnut'].map((e) {
                        return DropdownMenuItem(value: e,child: Text('$e Chart'),);
                      }).toList(),
                      onChanged: (value) {
                        switch (value) {
                          case 'Bar':
                            chartType = 'Bar'; //Necessary to change the value of the dropdownbutton. 
                            choosenChart = BarChart(dataList: chartDataList);
                            break;
                          case 'Pie':
                            chartType = 'Pie';
                            choosenChart = PieChart(dataList: chartDataList);
                            break;
                          case 'Doughnut':
                            chartType = 'Doughnut';
                            choosenChart = DoughnutChart(dataList: chartDataList);
                            break;
                          default:
                        }
                        setState(() {});
                      },
                        ),
                    const Text('اختر شكل عرض البيانات:   ', textDirection: TextDirection.rtl,)
                  ],
                ),
                const SizedBox(height: 70,),
                Flexible(
                  flex: 3,
                  child: choosenChart!
                ),
              ],
            )
          ),
        ),
      );
      },
    );
  }
}

// The data source
// final List<ChartData> chartDataList = [
//   ChartData('فول', 35),
//   ChartData('غيره', 28),
//   ChartData('لن أفطر', 34),
// ];

// chartType == 'Bar'
//                           ? BarChart(dataList: chartDataList)
//                           : (chartType == 'Pie'
//                               ? PieChart(dataList: chartDataList)
//                               : DoughnutChart(dataList: chartDataList)),
