import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNoticePage extends StatelessWidget {
  const AppNoticePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('공지사항'),
        elevation: 1,
      ),
    );
  }
}
