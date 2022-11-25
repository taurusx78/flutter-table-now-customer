import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/location_controller.dart';
import 'package:table_now/controller/search_controller.dart';
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

class SearchResultsPage extends GetView<SearchController> {
  SearchResultsPage({Key? key}) : super(key: key);

  String name = Get.arguments;
  final _focusNode = FocusNode();

  final StoreController _storeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 화면 밖 터치 시 키패드 숨기기
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          // 검색바
          title: _buildSearchTextField(context),
          toolbarHeight: 75,
        ),
        body: Container(
          width: 600,
          margin: const EdgeInsets.fromLTRB(15, 5, 15, 15),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 현재위치 정보
                  LocationBar(tapFunc: () async {
                    String result = await Get.find<LocationController>()
                        .getCurrentLocation();
                    showToast(context, result);
                    // 현재위치를 기반으로 검색매장 다시조회
                    _storeController.findAllByName(controller.search.text);
                  }),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 영업상태 필터
                      StateFilter(),
                      // 매장 정렬 드롭다운
                      SortDropdown(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // 검색결과 헤더
                  Obx(() => _buildResultsHeader()),
                  const SizedBox(height: 15),
                  // 검색매장 목록
                  Obx(
                    () => _storeController.isLoaded.value
                        ? Expanded(
                            child: _storeController.filteredStoreList.isNotEmpty
                                ? _buildResultsStoreList()
                                : _buildNoStoreBox(),
                          )
                        : const LoadingIndicator(height: 200),
                  ),
                ],
              ),
              // 연관검색어 매장 목록
              Obx(
                () => controller.isFilled.value
                    ? Positioned(
                        child: _buildRelatedStoreList(),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // *** 최대 길이 지정!
  Widget _buildSearchTextField(context) {
    return TextField(
      controller: controller.search,
      focusNode: _focusNode,
      autofocus: false,
      style: const TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: '지역 + 매장명을 입력해 주세요.',
        hintStyle: const TextStyle(fontSize: 15, color: Colors.black54),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        // 입력값 길어질 때 텍스트 가리지 않도록 설정
        isDense: true,
        prefixIcon: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Get.back();
          },
        ),
        suffixIcon: IconButton(
          splashRadius: 20,
          icon: const Icon(Icons.clear_rounded, color: Colors.black54),
          onPressed: () {
            controller.search.clear();
          },
        ),
      ),
      onChanged: (value) {
        // 연관검색어 매장 목록 변경
        controller.changeRelatedStoreList(value);
      },
      onSubmitted: (value) async {
        value = value.trim(); // 공백 제거
        if (value.isNotEmpty) {
          // 검색 매장 전체 조회 (비동기 호출)
          _storeController.findAllByName(value);
          // 연관검색어 매장 목록 초기화
          controller.initializeRelatedStoreList();
          // 드롭다운 인덱스 초기화
          _storeController.changeCurSortOption('업데이트순');
          // 최근검색어 추가
          await controller.addHistory(value, false);
        } else {
          _focusNode.requestFocus(); // TextField 포커스 유지
          controller.search.clear();
          showToast(context, '검색어를 입력해 주세요.');
        }
      },
    );
  }

  Widget _buildRelatedStoreList() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: controller.relatedStoreList.isNotEmpty
              ? blueGrey
              : Colors.transparent,
        ),
        color: Colors.white,
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.relatedStoreList.length,
        itemBuilder: (context, index) {
          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(
                  controller.relatedStoreList[index].name,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              onTap: () async {
                // 상세보기 페이지로 이동
                Get.toNamed(Routes.details,
                        arguments: controller.relatedStoreList[index].id)!
                    .then((value) {
                  _focusNode.requestFocus(); // TextField 포커스 유지
                  controller.search.clear();
                });
                // 최근검색어 추가
                await controller.addHistory(
                    controller.relatedStoreList[index].name, false);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '총 ${_storeController.filteredStoreList.length}개',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (_storeController.curFilterIndex.value == 1)
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
      itemCount: _storeController.filteredStoreList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            StoreItem(
              store: _storeController.filteredStoreList[index],
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
