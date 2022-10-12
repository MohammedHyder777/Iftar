import 'package:flutter/material.dart';

class StatisticsCard extends StatelessWidget {
  const StatisticsCard({super.key, required this.count, required this.type});
  final String type;
  final String count;
  final TextStyle tstyle = const TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Colors.indigo, width: 4),
      ),
      color: const Color.fromARGB(209, 5, 122, 107),
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text(type, style: tstyle,), Text(count, style: tstyle,)],
        ),
      ),
    );
  }
}
