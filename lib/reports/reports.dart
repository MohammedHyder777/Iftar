import 'package:cloud_firestore/cloud_firestore.dart';
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
//*//////////////// ReportScreen: ///////////////////////////////////////////////////

class ReportScreen extends StatefulWidget {
  const ReportScreen({
    super.key,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String chartType = 'Bar';
  Widget? choosenChart;
  bool check = false;

  /// Helps in avoiding declaring build as async.
  void delay() async {
    await Future.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<String>.value(
            value: DatabaseService().stats, initialData: '777'),
        StreamProvider<List<Data>>.value(
          initialData: const [],
          value: DatabaseService.document,
        )
      ],
      // stream: DatabaseService.document,
      builder: (icontext, child) {
        String i = Provider.of<String>(icontext);
        print(i);
        List<ChartData> chartDataList = [];
        var data = Provider.of<List<Data>>(icontext);
        // var data = child.data!;
        for (var e in ['فول', 'غير الفول', 'لن أفطر معكم']) {
          chartDataList.add(ChartData(e, countFoodOrders(e, data)));
        }
        print('data length : ${data.length}');
        // This condition has been added because the build is called two times, the first time with data = initialDatat = []
        // The delay function is a workaround to add a future delay which involves async which is not allowed in the build function.
        // if (data.isEmpty) {
        //   delay();
        // }else {
        //   choosenChart ??= BarChart(dataList:chartDataList); // If ?? is not used Barchart will be assigned to choosenChart at every build call and the chart will never change.
        // }
        print('**********************************************************');
        return Scaffold(
            appBar: AppBar(
              title: const Text('صفحة التقارير'),
            ),
            body: Center(
              child: Padding(
                  padding: const EdgeInsets.fromLTRB(18.0, 22.0, 18.0, 36.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          DropdownButton<String>(
                            value: chartType,
                            items: ['Bar', 'Pie', 'Doughnut'].map((e) {
                              return DropdownMenuItem(
                                value: e,
                                child: Text('$e Chart'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              switch (value) {
                                case 'Bar':
                                  chartType =
                                      'Bar'; //Necessary to change the value of the dropdownbutton.
                                  // choosenChart = BarChart(dataList: chartDataList);
                                  break;
                                case 'Pie':
                                  chartType = 'Pie';
                                  // choosenChart = PieChart(dataList: chartDataList);
                                  break;
                                case 'Doughnut':
                                  chartType = 'Doughnut';
                                  // choosenChart = DoughnutChart(dataList: chartDataList);
                                  break;
                                default:
                              }
                              setState(() {});
                            },
                            elevation: 24,
                          ),
                          const Text(
                            'اختر شكل عرض البيانات:   ',
                            textDirection: TextDirection.rtl,
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 70,
                      ),
                      Flexible(
                        flex: 3,
                        child: chartType == 'Bar'
                            ? BarChart(dataList: chartDataList)
                            : (chartType == 'Pie'
                                ? PieChart(dataList: chartDataList)
                                : DoughnutChart(dataList: chartDataList)),
                      ),
                      Text('$i 999999999999999999')
                    ],
                  )),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                List foods = ['فول', 'غير الفول', 'لن أفطر معكم'];
                List statistics = [];
                CollectionReference coll =
                    FirebaseFirestore.instance.collection("m_col");

                FirebaseFirestore.instance.collectionGroup('orders').get().then(
                  (snap) {
                    print(snap.docs.length);
                  },
                );
                await coll.snapshots().forEach(
                  (snap) {
                    for (var doc in snap.docs) {
                      Map data = doc.data() as Map;
                      for (String f in foods) {}
                    }
                  },
                );
              },
              child: const Icon(Icons.workspaces),
            ));
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
