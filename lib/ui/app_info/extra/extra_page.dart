import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/app_info/components/app_info_button.dart';

class ExtraPage extends StatelessWidget {
  const ExtraPage({Key? key}) : super(key: key);

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
        title: const Text('기타 정보'),
        elevation: 1,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: SizedBox(
            width: 600,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 앱 현재버전
                AppInfoButton(
                  title: '앱 현재버전',
                  routeFunc: () {
                    // *** 앱스토어로 연결
                  },
                ),
                // 오픈소스 라이선스
                AppInfoButton(
                  title: '오픈소스 라이선스',
                  routeFunc: () {
                    Get.toNamed(Routes.license);
                  },
                ),
                // 회사소개
                _buildCompanyDescription(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyDescription() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: const [
          // 헤더
          Text(
            '회사소개',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
