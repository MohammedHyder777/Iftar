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

  String chart_type = 'Pie';
  @override
  Widget build(BuildContext context) {
    

    return StreamProvider<List<Data>>.value(
      initialData: const [],
      value: DatabaseService().document,
      builder:(context, child) {
        List<ChartData> chartData = [];
        final data = Provider.of<List<Data>>(context);
        for (var e in ['فول', 'غير الفول', 'لن أفطر معكم']) {
          chartData.add(ChartData(e, countFoodOrders(e, data)));
        }

        return Scaffold(
        appBar: AppBar(
          title: const Text('صفحة التقارير'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18.0,22.0,18.0,36.0),
            child: Column(
              children: [
                DropdownButton<String>(
                  value: chart_type,
                  items: ['Bar','Pie','Doughnut'].map((e) {
                    return DropdownMenuItem(value: e,child: Text(e),);
                  }).toList(),
                  onChanged: (value) {
                    setState(() {chart_type = value!;});
                  },
                    ),
                chart_type == 'Bar'
                        ? BarChart(dataList: chartData)
                        : (chart_type == 'Pie'
                            ? PieChart(dataList: chartData)
                            : DoughnutChart(dataList: chartData)),
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
// final List<ChartData> chartData = [
//   ChartData('فول', 35),
//   ChartData('غيره', 28),
//   ChartData('لن أفطر', 34),
// ];


