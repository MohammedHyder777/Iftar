import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// InputDecoration function
// Can also use a constant and call decorConst.copyWith() to specify hints &labels.
InputDecoration fieldDecor({String? label, String? hint}) {
  return InputDecoration(
    labelText: label,
    hintText: hint,
    labelStyle: const TextStyle(color: Color.fromARGB(255, 71, 71, 71)),
    floatingLabelStyle: const TextStyle(color: Color.fromARGB(255, 71, 71, 71)),
    filled: true,
    fillColor: const Color.fromARGB(69, 33, 149, 243),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.purple[400]!, width: 4),
      borderRadius: BorderRadius.circular(27.0),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(27.0),
    ),
  );
}

/// Loading widget
class Loading extends StatelessWidget {

  const Loading({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: Theme.of(context).primaryColor,
        size: 30,
        type: SpinKitWaveType.end,
        itemCount: 10,
      ),
    );
  }
}

class CircleLoading extends StatelessWidget {
  const CircleLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SpinKitCircle(
        size: 70,
        color: Colors.blue,
      ),
    );
  }
}