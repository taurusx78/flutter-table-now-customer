import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class CustomDivider extends StatelessWidget {
  const CustomDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: blueGrey,
      margin: const EdgeInsets.symmetric(vertical: 20),
    );
  }
}
