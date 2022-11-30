import 'package:flutter/material.dart';
import 'package:iftar/data.dart';
import 'package:iftar/screens/reports/label_ddb.dart';
import 'package:iftar/screens/reports/report_chrats.dart';
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
//*//////////////// ReportScreen: ///////////////////////////////////////////////////

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    super.key,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {

  String? chartType;
  String reportType = 'تقرير شامل';
  @override
  Widget build(BuildContext context) {
    chartType ??= ModalRoute.of(context)!.settings.arguments as String;

    return MultiProvider(
      providers: [
        StreamProvider<Map>.value(initialData: const {}, value: DatabaseService().glossaryStats,),
        StreamProvider<List<Data>>.value(initialData: const [], value: DatabaseService.document,),
        ],
      builder:(context, child) {
        List<ChartData> chartData = [];

        if (reportType == 'تقرير شامل') {
          Map data = Provider.of<Map>(context);
          print('data: $data');
          data.forEach((key, value) {
              chartData.add(ChartData(key, value));
            },
          );
        } else {
          final data = Provider.of<List<Data>>(context);
          for (var e in ['فول', 'غير الفول', 'لن أفطر معكم']) {
            chartData.add(ChartData(e, countFoodOrders(e, data)));
          }
        }


        return Scaffold(
        appBar: AppBar(
          title: const Text('شاشة التقارير'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(18.0,22.0,18.0,36.0),
          child: ListView(
            // mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DdButtonWithLabel(
                    value: reportType,
                    items: ['تقرير شامل', 'تقرير لليوم'].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(e), 
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        reportType = value!;
                      });
                    },
                    labelText: 'اختر نوع التقرير:   ',
                  ),
                  DdButtonWithLabel(
                    value: chartType,
                    items: ['Bar', 'Pie', 'Doughnut'].map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text('$e Chart'),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        chartType = value!;
                      });
                    },
                    labelText: 'اختر شكل عرض البيانات:   ',
                  ),
                  const SizedBox(height: 70,),
                  Column(
                    children: [
                      chartType == 'Bar'
                          ? BarChart(dataList: chartData, yAxisTitleText: 'عدد الراغبين',)
                          : (chartType == 'Pie'
                              ? PieChart(dataList: chartData)
                              : DoughnutChart(dataList: chartData)),
                    ],
                  ),
                ],
              )),
        );
      },
    );
  }
}

// The data source
// final List<ChartData> chartData = [
//   ChartData('فول', 35),
//   ChartData('غيره', 28),
//   ChartData('لن أفطر', 34),
// ];


