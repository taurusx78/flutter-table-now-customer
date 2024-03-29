import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/main_controller.dart';
import 'package:table_now/controller/store_controller.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/custom_color.dart';

class CategoryItem extends StatelessWidget {
  final String label;
  final String image;
  final double fontSize;

  CategoryItem({
    Key? key,
    required this.label,
    required this.image,
    required this.fontSize,
  }) : super(key: key);

  final StoreController _storeController = Get.put(StoreController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: [
          // 이미지
          Container(
            width: 75,
            height: 75,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: blueGrey),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: Image.asset(
                'assets/images/category/$image',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 5),
          // 라벨
          Text(
            label,
            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        // 카테고리 매장 전체 조회 (비동기 실행)
        _storeController.findAllByCategory(label);
        // 카테고리 결과 페이지로 이동
        Get.toNamed(Routes.categoryResults, arguments: label)!.then((value) {
          // 즐겨찾기 5개 조회
          Get.put(MainController()).findAllBookmark(false);
        });
      },
    );
  }
}
