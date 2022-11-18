import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FAQPage extends StatelessWidget {
  const FAQPage({Key? key}) : super(key: key);

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
        title: const Text('자주 묻는 질문'),
        elevation: 1,
      ),
      // body: ,
    );
  }
}
