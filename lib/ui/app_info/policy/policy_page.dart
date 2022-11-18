import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/app_info/components/app_info_button.dart';

class PolicyPage extends StatelessWidget {
  const PolicyPage({Key? key}) : super(key: key);

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
        title: const Text('약관 및 정책'),
        elevation: 1,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 600,
            child: Column(
              children: [
                // 이용약관
                AppInfoButton(
                  title: '이용약관',
                  routeFunc: () {
                    Get.toNamed(Routes.termsConditions);
                  },
                ),
                // 개인정보 처리방침
                AppInfoButton(
                  title: '개인정보 처리방침',
                  routeFunc: () {
                    Get.toNamed(Routes.privacyPolicy);
                  },
                ),
                // 위치기반서비스 이용약관
                AppInfoButton(
                  title: '위치기반서비스 이용약관',
                  routeFunc: () {
                    Get.toNamed(Routes.locationTerms);
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
