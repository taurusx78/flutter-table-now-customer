import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/location_controller.dart';
import 'package:table_now/controller/search_controller.dart';
import 'package:table_now/controller/store_controller.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/kakao_banner_ad.dart';
import 'package:table_now/ui/components/loading_indicator.dart';
import 'package:table_now/ui/components/location_bar.dart';
import 'package:table_now/ui/components/network_disconnected_text.dart';
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
        body: Align(
          alignment: Alignment.topCenter,
          child: Container(
            width: 600,
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 현재위치 정보
                    LocationBar(tapFunc: () async {
                      String result = await Get.find<LocationController>()
                          .getCurrentLocation();
                      showToast(context, result, null);
                      // 현재위치를 기반으로 검색매장 다시조회
                      _storeController.findAllByName(controller.search.text);
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
                    Obx(
                      () => _buildResultsHeader(context),
                    ),
                    const SizedBox(height: 15),
                    // 검색매장 목록
                    Obx(
                      () => Expanded(
                        child: _storeController.loaded.value
                            ? _storeController.connected.value
                                ? _storeController.filteredStoreList.isNotEmpty
                                    ? _buildResultsStoreList()
                                    : _buildNoStoreBox()
                                : NetworkDisconnectedText(
                                    retryFunc: () {
                                      // 검색매장 전체조회 (비동기 호출)
                                      _storeController.findAllByName(
                                          controller.search.text);
                                    },
                                  )
                            : const LoadingIndicator(),
                      ),
                    ),
                  ],
                ),
                // 연관검색어 매장 목록
                Obx(
                  () => controller.filled.value
                      ? Positioned(
                          child: _buildRelatedStoreList(),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchTextField(context) {
    return SizedBox(
      width: 600,
      child: TextField(
        controller: controller.search,
        focusNode: _focusNode,
        style: const TextStyle(fontSize: 15),
        autofocus: false,
        maxLength: 50,
        decoration: InputDecoration(
          hintText: '지역 + 매장명을 입력해 주세요.',
          hintStyle: const TextStyle(fontSize: 15, color: Colors.black54),
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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
            showToast(context, '검색어를 입력해 주세요.', null);
          }
        },
      ),
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

  Widget _buildResultsHeader(context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '총 ${_storeController.filteredStoreList.length}개',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        if (_storeController.curFilterIndex.value == 1)
          Padding(
            padding: const EdgeInsets.only(left: 5, top: 2),
            child: InkWell(
              child: const Icon(
                Icons.help_outline_rounded,
                color: primaryColor,
                size: 18,
              ),
              onTap: () {
                showHelpDialog(context);
              },
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
                padding: EdgeInsets.only(top: 12),
                child: KakaoBannerAd(),
              ),
          ],
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 12),
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

  void showHelpDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context2) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '테이블 정보를 제공하지 않는 매장은 검색 결과에서 제외됩니다.',
              ),
            ],
          ),
          contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
          actions: [
            TextButton(
              child: const Text(
                '확인',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              onPressed: () {
                Navigator.pop(context2); // alertDialog 닫기
              },
            ),
          ],
          actionsPadding: EdgeInsets.zero,
        );
      },
    );
  }
}
