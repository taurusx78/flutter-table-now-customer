import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:table_now/util/host.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({Key? key}) : super(key: key);

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  // 이미지 유형
  final String type = Get.arguments[0];
  // 이미지 URL 리스트
  final List<String> imageUrlList = Get.arguments[1];
  // 현재 선택된 인덱스
  int curIndex = Get.arguments[2];
  // 전체 이미지 개수
  late int imageCount;

  @override
  void initState() {
    super.initState();
    imageCount = imageUrlList.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text('${curIndex + 1} / $imageCount'),
      ),
      body: Swiper(
        itemCount: imageCount,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Image.network(
              '$host/image?type=$type&filename=' + imageUrlList[index],
              fit: BoxFit.fitWidth,
            ),
            maxScale: 3,
          );
        },
        index: curIndex,
        onIndexChanged: (index) {
          setState(() {
            curIndex = index;
          });
        },
        loop: false,
        // 화살표로 이동
        control: const SwiperControl(
          iconPrevious: Icons.arrow_back_ios_new_rounded,
          iconNext: Icons.arrow_forward_ios_rounded,
          color: Colors.white,
        ),
        // 스크롤 방지
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }
}
