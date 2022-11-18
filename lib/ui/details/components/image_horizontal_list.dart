import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/util/host.dart';

class ImageHorizontalList extends StatelessWidget {
  final String type;
  final List<String> imageUrlList;

  const ImageHorizontalList({
    Key? key,
    required this.type,
    required this.imageUrlList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // 높이 지정 필수!
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrlList.length,
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: lightGrey, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: GestureDetector(
                child: Image.network(
                  '$host/image?type=$type&filename=${imageUrlList[index]}',
                  width: 120,
                  fit: BoxFit.cover,
                ),
                onTap: () {
                  Get.toNamed(
                    Routes.image,
                    arguments: [type, imageUrlList, index],
                  );
                },
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
      ),
    );
  }
}
