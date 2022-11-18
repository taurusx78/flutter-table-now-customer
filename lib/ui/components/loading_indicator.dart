import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class LoadingIndicator extends StatelessWidget {
  final double height;
  const LoadingIndicator({Key? key, required this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: CircularProgressIndicator(
          color: primaryColor,
          strokeWidth: 2,
        ),
      ),
    );
  }
}
