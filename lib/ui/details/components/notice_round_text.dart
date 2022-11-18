import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class NoticeRoundText extends StatelessWidget {
  final String title;

  const NoticeRoundText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        color: title == '알림'
            ? primaryColor.withOpacity(0.15)
            : red.withOpacity(0.15),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: title == '알림' ? primaryColor : red,
        ),
      ),
    );
  }
}
