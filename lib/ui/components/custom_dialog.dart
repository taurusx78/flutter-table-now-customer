import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class CustomDialog extends StatelessWidget {
  final String content;
  final dynamic checkFunc;

  const CustomDialog({
    Key? key,
    required this.content,
    required this.checkFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      content: Text(content),
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 5),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              child: const Text(
                '취소',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
              onPressed: () {
                Navigator.pop(context); // alertDialog 닫기
              },
            ),
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              onPressed: checkFunc,
            ),
          ],
        )
      ],
    );
  }
}
