import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/dto/state_resp.dart';
import 'package:table_now/data/store/model/store.dart';
import 'package:table_now/data/store/store_repository.dart';
import 'package:table_now/data/sqlite_helper.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dto/hours_resp.dart';

class DetailsController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  final Rx<Store> store = Store().obs;
  final RxString state = ''.obs; // 영업상태
  final RxInt tableCount = 0.obs; // 잔여테이블 수
  final RxString updated = ''.obs; // 업데이트 시간
  final RxString businessHours = ''.obs; // 오늘의 영업시간
  final RxString breakTime = ''.obs; // 오늘의 휴게시간
  final RxString lastOrder = ''.obs; // 오늘의 주문마감시간

  final RxBool isLoaded = true.obs; // 상세보기 조회 완료 여부
  final RxBool isBookmarked = false.obs; // 즐겨찾기 포함 여부

  final Rx<HoursResp> weeklyHours = HoursResp().obs; // 전체 영업시간
  final RxBool isHoursLoaded = true.obs; // 전체 영업시간 조회 완료 여부

  // 대표사진 현재 인덱스
  final RxInt curBasicImageIndex = 0.obs;

  // 알림 현재 인덱스
  final RxInt curNoticeIndex = 0.obs;

  // 첨부사진 현재 인덱스
  final RxInt curNoticeImageIndex = 0.obs;

  // 정보수정제안 항목 체크 여부
  List<String> infoItems = ['영업시간', '메뉴/가격', '매장내부사진', '매장 폐업'];
  List<IconData> infoItemIcons = [
    Icons.access_time_rounded,
    Icons.book_outlined,
    Icons.storefront_outlined,
    Icons.wrong_location_outlined,
  ];
  List<RxBool> itemIsChecked = [false.obs, false.obs, false.obs, false.obs];

  // 스크롤에 따라 앱바 텍스트 색상 변경
  final ScrollController scrollController = ScrollController();
  final Rx<Color> appBarIconColor = Colors.white.obs; // 앱바 아이콘 색상
  final Rx<Color> appBarTextColor = Colors.transparent.obs; // 앱바 텍스트 색상

  // 업데이트 버튼 회전 애니메이션
  RxDouble turns = 0.0.obs;

  void changeTurns() {
    turns.value += 1; // 한바퀴 회전
  }

  @override
  void onInit() {
    super.onInit();
    // 스크롤 변경 감지 설정
    scrollController.addListener(() {
      appBarIconColor.value =
          isSliverAppBarExpanded() ? Colors.white : Colors.black;
      appBarTextColor.value =
          isSliverAppBarExpanded() ? Colors.transparent : Colors.black;
    });
  }

  bool isSliverAppBarExpanded() {
    return scrollController.hasClients &&
        scrollController.offset < (270 - kToolbarHeight);
  }

  // 매장 상세조회
  Future<void> findById(int storeId) async {
    isLoaded.value = false;

    store.value = await _storeRepository.findById(storeId);
    // 즐겨찾기 포함 여부 조회
    await checkIsBookmarked(storeId);
    state.value = store.value.state!;
    tableCount.value = store.value.tableCount!;
    updated.value = store.value.updated!;
    businessHours.value = store.value.businessHours!;
    breakTime.value = store.value.breakTime!;
    lastOrder.value = store.value.lastOrder!;

    isLoaded.value = true;
  }

  // 즐겨찾기 포함 여부 조회
  Future<void> checkIsBookmarked(int storeId) async {
    int? result = await SqliteHelper.checkIsBookmarked(storeId);
    if (result! > 0) {
      isBookmarked.value = true;
    } else {
      isBookmarked.value = false;
    }
  }

  // 즐겨찾기 추가/제거
  Future<String> changeIsBookmarked(int storeId) async {
    if (!isBookmarked.value) {
      if (await SqliteHelper.findTotalCount() == 100) {
        // 최대 100개
        return '즐겨찾기는 최대 100개까지 등록할 수 있습니다.';
      } else {
        // 즐겨찾기에 추가
        isBookmarked.value = !isBookmarked.value;
        await SqliteHelper.addStoreId(storeId);
        return '즐겨찾기에 추가되었습니다.';
      }
    } else {
      // 즐겨찾기에서 제거
      isBookmarked.value = !isBookmarked.value;
      await SqliteHelper.deleteByStoreId(storeId);
      return '즐겨찾기에서 제거되었습니다.';
    }
  }

  // 영업시간 전체조회
  Future<void> findHours(int storeId) async {
    isHoursLoaded.value = false;
    weeklyHours.value = await _storeRepository.findHours(storeId);
    isHoursLoaded.value = true;
  }

  // 영업상태 업데이트
  Future<int> updateState(int storeId) async {
    var result = await _storeRepository.updateState(storeId);
    if (result.runtimeType == StateResp) {
      state.value = result.state;
      tableCount.value = result.tableCount;
      updated.value = result.updated;
      businessHours.value = result.businessHours;
      breakTime.value = result.breakTime;
      lastOrder.value = result.lastOrder;
      result = 1;
    }
    return result;
  }

  // 매장 전화 연결
  Future<void> launchPhoneUrl() async {
    Uri phoneUrl = Uri.parse('tel:' + store.value.phone!);
    await launchUrl(phoneUrl);
  }

  // 웹사이트 링크 연결
  Future<void> launchWebsiteUrl() async {
    if (store.value.website != null) {
      Uri websiteUrl = Uri.parse('https:' + store.value.website!);
      await launchUrl(websiteUrl);
    }
  }

  // 블로그 리뷰 링크 연결
  Future<void> launchBlogUrl(int index) async {
    Uri blogLinkUrl = Uri.parse(store.value.blogList![index].link);
    await launchUrl(blogLinkUrl);
  }

  // 블로그 더보기 검색결과 연결
  Future<void> launchMoreResultsUrl() async {
    // 검색어
    String query =
        store.value.jibunAddress!.split('')[1] + ' ' + store.value.name!;
    var uri =
        'https://search.naver.com/search.naver?query=$query&nso=&where=blog&sm=tab_opt';
    // URL 한글 인코딩
    var encoded = Uri.encodeFull(uri);
    await launchUrl(Uri.parse(encoded));
  }

  // 매장정보 수정제안
  Future<int> requestUpdate(int storeId) async {
    List<String> checkedItems = [];
    for (int i = 0, len = infoItems.length; i < len; i++) {
      if (itemIsChecked[i].value) {
        checkedItems.add(infoItems[i]);
      }
    }
    Map<String, List<String>> data = {'items': checkedItems};
    return await _storeRepository.requestUpdate(storeId, data);
  }

  // 선택된 대표사진 인덱스 변경
  void changeCurBasicImageIndex(index) {
    curBasicImageIndex.value = index;
  }

  // 선택된 알림 인덱스 변경
  void changeCurNoticeIndex(index) {
    curNoticeIndex.value = index;
  }

  // 선택된 첨부사진 인덱스 변경
  void changeCurNoticeImageIndex(index) {
    curNoticeImageIndex.value = index;
  }

  // 정보수정요청 항목 체크 여부 초기화
  void initializeItemIsChecked() {
    itemIsChecked = [false.obs, false.obs, false.obs, false.obs];
  }

  // 정보수정요청 항목 체크 여부 변경
  void changeItemIsChecked(index, value) {
    itemIsChecked[index].value = value;
  }

  // 정보수정요청 항목이 하나라도 체크되어 있는지 확인
  bool atLeastOneIsChecked() {
    for (RxBool isChecked in itemIsChecked) {
      if (isChecked.value) return true;
    }
    return false;
  }
}
