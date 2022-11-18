import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 이미지
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              border: Border.all(color: blueGrey, width: 5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset('assets/images/$image'),
            ),
          ),
          // 라벨
          Text(label, style: TextStyle(fontSize: fontSize)),
        ],
      ),
      onTap: () {
        // 카테고리 매장 전체 조회 (비동기 실행)
        _storeController.findAllByCategory(label);
        // 카테고리 결과 페이지로 이동
        Get.toNamed(Routes.categoryResults, arguments: label);
      },
    );
  }
}
