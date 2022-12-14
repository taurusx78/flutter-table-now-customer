import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class StateRoundBox extends StatelessWidget {
  String state;
  final int tableCount;
  Color color = Colors.black54;

  StateRoundBox({
    Key? key,
    required this.state,
    required this.tableCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 색상 지정
    if (state == '영업중') {
      if (tableCount >= 4 || tableCount == -1) {
        color = green;
      } else if (tableCount >= 2) {
        color = yellow;
      } else {
        color = red;
      }
    } else if (state == '휴게시간') {
      color = primaryColor;
    }

    // 영업상태 지정
    if (state == '영업중') {
      if (tableCount != -1) {
        if (tableCount > 5) {
          state = '5+ 테이블';
        } else {
          state = '$tableCount 테이블';
        }
      }
    }

    return Container(
      height: 28,
      padding: const EdgeInsets.symmetric(horizontal: 13),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: color,
      ),
      child: Center(
        child: Text(
          state,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
