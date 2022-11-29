import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class TimeRowText extends StatelessWidget {
  final String title;
  final String info;
  final double? width;

  const TimeRowText({
    Key? key,
    required this.title,
    this.width,
    required this.info,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16, color: title != '정기휴무' ? darkNavy : red),
            ),
          ),
          WidgetSpan(
            // alignment: PlaceholderAlignment.middle,
            child: Container(
              width: 1,
              height: 15,
              color: blueGrey,
              margin: const EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: SizedBox(
              width: width,
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
