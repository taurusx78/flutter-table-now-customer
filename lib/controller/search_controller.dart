import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_now/controller/dto/store_name_resp_dto.dart';
import 'package:table_now/data/store/store_repository.dart';
import 'package:table_now/util/all_store_name.dart';

class SearchController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  SharedPreferences? pref; // 최근검색어 내부저장소에 저장 (최대 7개)
  final RxList<String> history = <String>[].obs; // 최근검색어 목록

  final search = TextEditingController();
  final RxList relatedStoreList = <StoreNameRespDto>[].obs; // 연관검색어 매장 목록
  final RxBool filled = false.obs; // 텍스트필드 입력 여부

  @override
  Future<void> onInit() async {
    super.onInit();

    // 최근검색어 불러오기
    pref = await SharedPreferences.getInstance();
    var history = pref!.getStringList('history');
    if (history != null) {
      this.history.value = history;
    }

    // 매장명 전체조회
    // *** 처음 조회하거나 전날 조회한 경우 다시 조회!
    // *** 파일이 아닌 내부저장소에 저장하기!!!
    if (storeNameUpdated == null) {
      findAllStoreName(); // 비동기 호출
      print('매장명 전체조회');
    }

    // 검색 텍스트필드 입력 감지 설정
    search.addListener(changeIsFilled);
  }

  // 매장명 전체조회
  Future<void> findAllStoreName() async {
    await _storeRepository.findAllStoreName();
  }

  // 최근검색어 추가
  Future<void> addHistory(String value, bool isSelected) async {
    pref = await SharedPreferences.getInstance();
    value = value.toLowerCase(); // 소문자로 변경

    if (!isSelected) {
      // 1. 텍스트필드에 입력한 value
      if (!history.contains(value)) {
        // 검색기록에 없는 경우
        if (history.length == 7) {
          history.removeAt(0);
        }
      } else {
        history.remove(value);
      }
    } else {
      // 2. 최근검색어에서 선택한 value
      history.remove(value);
    }
    history.add(value);

    pref!.setStringList('history', history);
  }

  // 최근검색어 삭제
  Future<void> deleteHistory(int index) async {
    pref = await SharedPreferences.getInstance();
    history.removeAt(index);
    pref!.setStringList('history', history);
  }

  // 최근검색어 전체삭제
  Future<void> deleteAllHistory() async {
    pref = await SharedPreferences.getInstance();
    pref!.remove('history');
    history.value = [];
  }

  // 연관검색어 매장 목록 변경
  void changeRelatedStoreList(String value) {
    List<StoreNameRespDto> temp = [];
    if (allStoreName != null) {
      for (StoreNameRespDto storeName in allStoreName!) {
        if (storeName.name.contains(value)) {
          temp.add(storeName);
        }
        // 최대 길이 20으로 제한
        if (temp.length == 20) break;
      }
      relatedStoreList.value = temp;
    }
  }

  // 연관검색어 매장 목록 초기화
  void initializeRelatedStoreList() {
    relatedStoreList.value = <StoreNameRespDto>[];
  }

  // 텍스트필드 입력 유무
  void changeIsFilled() {
    filled.value = search.text != '';
  }
}
