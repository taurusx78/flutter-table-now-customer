import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/screen_size.dart';

class InfoRowText extends StatelessWidget {
  final String text;
  final double margin;
  final Color? iconColor;
  final Color? textColor;

  const InfoRowText({
    Key? key,
    required this.text,
    required this.margin,
    this.iconColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 3, right: 5),
          child: Icon(
            Icons.info_outline_rounded,
            size: 18,
            color: iconColor ?? primaryColor,
          ),
        ),
        SizedBox(
          width: getScreenWidth(context) - margin < 600
              ? getScreenWidth(context) - margin - 25
              : 575,
          child: Text(
            text,
            style: TextStyle(fontSize: 15, color: textColor ?? darkNavy),
          ),
        ),
      ],
    );
  }
}
