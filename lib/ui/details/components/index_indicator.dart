import 'package:flutter/material.dart';

class IndexIndicator extends StatelessWidget {
  final int index;
  final int length;

  const IndexIndicator({
    Key? key,
    required this.index,
    required this.length,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black54,
      ),
      child: Text(
        '$index / $length',
        style: const TextStyle(fontSize: 14, color: Colors.white),
      ),
    );
  }
}
