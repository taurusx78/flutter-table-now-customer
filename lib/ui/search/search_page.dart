import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/search_controller.dart';
import 'package:table_now/controller/store_controller.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/dialog_ui.dart';
import 'package:table_now/ui/components/kakao_banner_ad.dart';
import 'package:table_now/ui/components/show_toast.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/screen_size.dart';

class SearchPage extends GetView<SearchController> {
  SearchPage({Key? key}) : super(key: key);

  final _focusNode = FocusNode();

  final StoreController _storeController = Get.put(StoreController());

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
                children: [
                  // 광고
                  const KakaoBannerAd(),
                  Obx(
                    () => controller.history.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 20),
                            child: _buildHistoryHeader(context),
                          )
                        : const SizedBox(),
                  ),
                  // 최근검색어 목록
                  Expanded(
                    child: Obx(
                      () => controller.history.isNotEmpty
                          ? _buildHistoryList()
                          : _buildNoHistoryBox(),
                    ),
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
      autofocus: true,
      style: const TextStyle(fontSize: 16),
      decoration: InputDecoration(
        hintText: '지역 + 매장명을 입력해 주세요.',
        hintStyle: const TextStyle(fontSize: 16, color: Colors.black54),
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
          // 검색매장 전체조회 (비동기 호출)
          _storeController.findAllByName(value);
          // 연관검색어 매장 목록 초기화
          controller.initializeRelatedStoreList();
          // 검색 필터 & 정렬 선택항목 초기화
          _storeController.initializeFilterSort();
          // 검색결과 페이지로 이동
          Get.toNamed(Routes.searchResults, arguments: value)!.then((value) {
            _focusNode.requestFocus(); // TextField 포커스 유지
            controller.search.clear();
          });
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
      color: Colors.white,
      child: ListView.builder(
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
                  // 검색 필터 & 정렬 선택항목 초기화
                  _storeController.initializeFilterSort();
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

  Widget _buildHistoryHeader(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '최근검색어',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        InkWell(
          child: const Text(
            '전체삭제',
            style: TextStyle(fontSize: 15, color: Colors.black54),
          ),
          onTap: () async {
            _showDialog(context, '검색기록을 전체삭제 하시겠습니까?', () async {
              Navigator.pop(context);
              await controller.deleteAllHistory();
            });
          },
        ),
      ],
    );
  }

  Widget _buildHistoryList() {
    int historyLen = controller.history.length;

    return ListView.separated(
      itemCount: historyLen,
      itemBuilder: (context, index) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 최근검색어
          Material(
            color: Colors.white,
            child: InkWell(
              child: Container(
                width: getScreenWidth(context) - 80,
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    controller.history[historyLen - index - 1]
                        .replaceAll('', '\u{200B}'), // 말줄임 에러 방지
                    style: const TextStyle(fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // 한 줄 말줄임
                  ),
                ),
              ),
              onTap: () async {
                String value = controller.history[historyLen - index - 1];
                // 검색매장 전체조회 (비동기 호출)
                _storeController.findAllByName(value);
                controller.search.text = value;
                // 연관검색어 매장 목록 초기화
                controller.initializeRelatedStoreList();
                // 검색결과 페이지로 이동
                Get.toNamed(Routes.searchResults, arguments: value)!
                    .then((value) {
                  _focusNode.requestFocus(); // TextField 포커스 유지
                  controller.search.clear();
                  // 검색 필터 & 정렬 선택항목 초기화
                  _storeController.initializeFilterSort();
                });
                // 최근검색어 추가
                await controller.addHistory(value, true);
              },
            ),
          ),
          // 삭제 버튼
          SizedBox(
            width: 50,
            height: 50,
            child: Center(
              child: IconButton(
                splashRadius: 20,
                icon: const Icon(
                  Icons.clear,
                  size: 17,
                  color: primaryColor,
                ),
                onPressed: () async {
                  // 최근검색어에서 삭제
                  await controller.deleteHistory(historyLen - index - 1);
                },
              ),
            ),
          )
        ],
      ),
      separatorBuilder: (context, index) => Container(
        height: 1,
        color: blueGrey,
      ),
    );
  }

  Widget _buildNoHistoryBox() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: blueGrey, width: 0.5),
        ),
      ),
      child: const Center(
        child: Text(
          '최근 검색기록이 없습니다.',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ),
    );
  }

  void _showDialog(context, content, checkFunc) {
    showDialog(
      context: context,
      barrierDismissible: false, // 버튼 선택으로만 Dialog 닫을 수 있도록 설정
      builder: (BuildContext context) {
        return DialogUI(
          content: content,
          checkFunc: checkFunc,
        );
      },
    );
  }
}
