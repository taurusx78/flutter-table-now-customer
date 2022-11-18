import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocationTermsPage extends StatelessWidget {
  const LocationTermsPage({Key? key}) : super(key: key);

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
        title: const Text('위치기반서비스 이용약관'),
        elevation: 1,
      ),
      // body: ,
    );
  }
}
