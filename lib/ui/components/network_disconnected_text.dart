import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class NetworkDisconnectedText extends StatelessWidget {
  final dynamic retryFunc;

  const NetworkDisconnectedText({
    Key? key,
    required this.retryFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error_big.png',
            width: 50,
            color: darkNavy,
          ),
          const SizedBox(height: 20),
          const Text(
            '네트워크 연결이 원활하지 않거나',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            '예기치 못한 오류가 발생했습니다.',
            style: TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 10),
          const Text(
            '잠시후 다시 시도해 주세요.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          InkWell(
            borderRadius: BorderRadius.circular(5),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: primaryColor),
              ),
              child: const Text(
                '재시도',
                style: TextStyle(fontSize: 15, color: primaryColor),
              ),
            ),
            onTap: retryFunc,
          ),
        ],
      ),
    );
  }
}
