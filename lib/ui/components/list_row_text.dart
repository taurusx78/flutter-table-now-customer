import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/screen_size.dart';

class ListRowText extends StatelessWidget {
  final String text;
  final double margin;

  const ListRowText({
    Key? key,
    required this.text,
    required this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8, right: 5),
          child: Icon(Icons.circle, size: 5, color: Colors.black38),
        ),
        SizedBox(
          width: getScreenWidth(context) * 0.8 - margin < 600
              ? getScreenWidth(context) * 0.8 - margin - 20
              : 580,
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: darkNavy),
          ),
        ),
      ],
    );
  }
}
