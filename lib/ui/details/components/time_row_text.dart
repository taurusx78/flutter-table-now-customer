import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class TimeRowText extends StatelessWidget {
  final String title;
  final String info;

  const TimeRowText({
    Key? key,
    required this.title,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 15, color: Colors.black54),
        ),
        Container(
          width: 1,
          height: 15,
          color: blueGrey,
          margin: const EdgeInsets.symmetric(horizontal: 20),
        ),
        Text(
          info,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
