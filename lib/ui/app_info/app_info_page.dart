import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/route/routes.dart';

import 'components/app_info_button.dart';

class AppInfoPage extends StatelessWidget {
  const AppInfoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('더보기'),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
            child: Column(
              children: [
                // 공지사항
                AppInfoButton(
                  title: '공지사항',
                  icon: Icons.notifications_none_rounded,
                  routeFunc: () {
                    Get.toNamed(Routes.appNotice);
                  },
                ),
                // 도움말
                AppInfoButton(
                  title: '도움말',
                  icon: Icons.help_outline_rounded,
                  routeFunc: () {
                    Get.toNamed(Routes.help);
                  },
                ),
                // 고객센터
                AppInfoButton(
                  title: '고객센터',
                  icon: Icons.headset_mic_outlined,
                  routeFunc: () {
                    Get.toNamed(Routes.customerService);
                  },
                ),
                // 약관 및 정책
                AppInfoButton(
                  title: '약관 및 정책',
                  icon: Icons.assignment_outlined,
                  routeFunc: () {
                    Get.toNamed(Routes.policy);
                  },
                ),
                // 기타 정보
                AppInfoButton(
                  title: '기타 정보',
                  icon: Icons.more_horiz,
                  routeFunc: () {
                    Get.toNamed(Routes.extra);
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
