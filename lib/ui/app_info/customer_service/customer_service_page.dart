import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/app_info/components/app_info_button.dart';

class CustomerServicePage extends StatelessWidget {
  const CustomerServicePage({Key? key}) : super(key: key);

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
        title: const Text('고객센터'),
        elevation: 1,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 600,
            child: Column(
              children: [
                // 자주 묻는 질문
                AppInfoButton(
                  title: '자주 묻는 질문',
                  routeFunc: () {
                    Get.toNamed(Routes.faq);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
