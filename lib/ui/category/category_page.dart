import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/location_controller.dart';
import 'package:table_now/data/category.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/category_item.dart';
import 'package:table_now/ui/components/kakao_banner_ad.dart';
import 'package:table_now/ui/components/location_bar.dart';
import 'package:table_now/ui/components/show_toast.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/screen_size.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('카테고리'),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.search,
              color: primaryColor,
            ),
            onPressed: () {
              Get.toNamed(Routes.search);
            },
          ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Container(
            width: 600,
            margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
            child: Column(
              children: [
                // 광고
                const KakaoBannerAd(),
                const SizedBox(height: 20),
                // 현재 위치
                LocationBar(
                  tapFunc: () async {
                    String result = await Get.find<LocationController>()
                        .getCurrentLocation();
                    showToast(context, result);
                  },
                ),
                const SizedBox(height: 30),
                // 카테고리 목록
                _buildCategoryList(context),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList(context) {
    return SizedBox(
      width: 600,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categoryList.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
              getScreenWidth(context) - 30 < 600 ? 4 : 5, // 행에 보여줄 item 개수
          mainAxisSpacing: 10, // item 수직 간격
          crossAxisSpacing: 10, // item 수평 간격
          childAspectRatio: getScreenWidth(context) - 30 < 600
              ? 1 / 1.3
              : 1 / 1, // item 너비:높이 비율
        ),
        itemBuilder: (context, index) {
          return CategoryItem(
            label: categoryList[index].label,
            image: categoryList[index].image,
            fontSize: 14,
          );
        },
      ),
    );
  }
}
