import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class CustomDivider extends StatelessWidget {
  final double? height;
  final Color? color;
  final double? top;
  final double? bottom;

  const CustomDivider({
    Key? key,
    this.height,
    this.color,
    this.top,
    this.bottom,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 1,
      color: color ?? blueGrey,
      margin: EdgeInsets.only(top: top ?? 20, bottom: bottom ?? 20),
    );
  }
}
