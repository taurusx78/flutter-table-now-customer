import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key}) : super(key: key);

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
        title: const Text('개인정보 처리방침'),
        elevation: 1,
      ),
      // body: ,
    );
  }
}
