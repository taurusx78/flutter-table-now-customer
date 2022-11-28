import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/location_controller.dart';
import 'package:table_now/controller/store_controller.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/kakao_banner_ad.dart';
import 'package:table_now/ui/components/loading_indicator.dart';
import 'package:table_now/ui/components/location_bar.dart';
import 'package:table_now/ui/components/show_toast.dart';
import 'package:table_now/ui/components/sort_dropdown.dart';
import 'package:table_now/ui/components/state_filter.dart';
import 'package:table_now/ui/components/store_item.dart';
import 'package:table_now/ui/custom_color.dart';

class CategoryResultsPage extends GetView<StoreController> {
  CategoryResultsPage({Key? key}) : super(key: key);

  final String category = Get.arguments;

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
        title: Text(category),
        actions: [
          IconButton(
            splashRadius: 20,
            icon: const Icon(
              Icons.search,
              color: primaryColor,
            ),
            onPressed: () {
              Get.offNamed(Routes.search);
            },
          )
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 600,
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 현재위치 정보
              LocationBar(tapFunc: () async {
                String result =
                    await Get.find<LocationController>().getCurrentLocation();
                showToast(context, result);
                // 현재위치를 기반으로 카테고리 매장 다시조회
                controller.findAllByCategory(category);
              }),
              const SizedBox(height: 15),
              // 필터 & 드롭다운
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StateFilter(),
                  SortDropdown(),
                ],
              ),
              const SizedBox(height: 20),
              // 검색결과 헤더
              Obx(() => _buildResultsHeader()),
              const SizedBox(height: 15),
              // 검색매장 목록
              Obx(
                () => controller.isLoaded.value
                    ? Expanded(
                        child: controller.filteredStoreList.isNotEmpty
                            ? _buildResultsStoreList()
                            : _buildNoStoreBox(),
                      )
                    : const LoadingIndicator(height: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '총 ${controller.filteredStoreList.length}개',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (controller.curFilterIndex.value == 1)
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RichText(
              text: const TextSpan(
                children: [
                  WidgetSpan(
                    child: Icon(
                      Icons.info_outline_rounded,
                      color: primaryColor,
                      size: 18,
                    ),
                  ),
                  TextSpan(
                    text: ' 잔여테이블 정보를 제공하지 않는 매장은 제외됩니다.',
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildResultsStoreList() {
    return ListView.separated(
      itemCount: controller.filteredStoreList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            StoreItem(
              store: controller.filteredStoreList[index],
              isBookmark: false,
            ),
            // 중간 광고 삽입
            if (index % 1 == 0)
              const Padding(
                padding: EdgeInsets.only(top: 15),
                child: KakaoBannerAd(),
              ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 10),
    );
  }

  Widget _buildNoStoreBox() {
    return const Center(
      child: Text(
        '검색 결과가 없습니다.',
        style: TextStyle(fontSize: 16, color: Colors.black54),
      ),
    );
  }
}
