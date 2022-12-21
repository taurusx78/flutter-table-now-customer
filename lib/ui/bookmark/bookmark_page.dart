import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/main_controller.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/kakao_banner_ad.dart';
import 'package:table_now/ui/components/loading_indicator.dart';
import 'package:table_now/ui/components/network_disconnected_text.dart';
import 'package:table_now/ui/components/store_item.dart';
import 'package:table_now/ui/custom_color.dart';

class BookmarkPage extends GetView<MainController> {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 즐겨찾기 전체조회
    print('즐겨찾기 전체조회');
    controller.findAllBookmark(true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('즐겨찾기'),
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
          )
        ],
      ),
      body: Obx(
        () => controller.loaded.value
            ? controller.connected.value
                ? controller.bookmarkList.isNotEmpty
                    ? _buildBookmarkList()
                    : _buildNoBookmarkBox()
                : NetworkDisconnectedText(
                    retryFunc: () {
                      // 즐겨찾기 전체조회 (비동기 호출)
                      controller.findAllBookmark(true);
                    },
                  )
            : const LoadingIndicator(),
      ),
    );
  }

  Widget _buildBookmarkList() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Container(
          width: 600,
          margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 광고
              const KakaoBannerAd(),
              const SizedBox(height: 15),
              // 즐겨찾기 헤더
              Text(
                '총 ' + controller.bookmarkList.length.toString() + '개',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              // 즐겨찾기 목록
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.bookmarkList.length,
                itemBuilder: (context, index) {
                  return StoreItem(
                    store: controller.bookmarkList[index],
                    isBookmark: true,
                  );
                },
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 15),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNoBookmarkBox() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            '등록된 매장이 없습니다.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          SizedBox(height: 10),
          Text(
            '관심 매장을 등록해 보세요!',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
