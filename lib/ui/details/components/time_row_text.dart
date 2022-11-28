import 'package:flutter/cupertino.dart';
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
    return RichText(
      text: TextSpan(
        text: title,
        style: TextStyle(
            fontSize: 16, color: title != '정기휴무' ? Colors.black54 : red),
        children: [
          WidgetSpan(
            child: Container(
              width: 1,
              height: 15,
              color: blueGrey,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: SizedBox(
              width: 200,
              child: Text(
                info,
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
