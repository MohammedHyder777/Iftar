import 'dart:ui';

import 'package:flutter/material.dart';

class DdButtonWithLabel extends StatelessWidget {
  const DdButtonWithLabel({super.key, required this.items, required this.onChanged, this.value, required this.labelText});

  final String? value;
  final List<DropdownMenuItem<String>>? items;
  final Function(String?)? onChanged;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 8),
          width: 150,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 2,
                    spreadRadius: -2.5,
                    blurStyle: BlurStyle.outer)
              ]),
          child: DropdownButton<String>(
            borderRadius: BorderRadius.circular(15),
            underline: Container(),
            dropdownColor: Colors.indigo[200],
            isExpanded:
                true, // Fixed width can be acheived by putting the button in a fixed width container and setting this to true.
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ),
        SizedBox( //The SizedBox is to align all the labels of different rows together.
          width: 150,
          child: Text(labelText, textDirection: TextDirection.rtl, style: const TextStyle(fontSize: 16),),
        )
      ],
    );
  }
}