import 'package:get/get.dart';
import 'package:table_now/controller/dto/code_msg_resp.dart';
import 'package:table_now/controller/dto/hours_resp.dart';
import 'package:table_now/controller/dto/state_resp.dart';
import 'package:table_now/controller/dto/store_name_resp.dart';
import 'package:table_now/controller/dto/store_resp.dart';
import 'package:table_now/data/store/store_provider.dart';
import 'package:table_now/util/all_store_name.dart';

import 'model/store.dart';

// Repository는 서버로부터 응답받은 데이터를 JSON에서 Dart 오브젝트로 변경하는 역할을 함

class StoreRepository {
  final StoreProvider _storeProvider = StoreProvider();

  void printData(codeMsgResp) {
    print(codeMsgResp.code);
    print(codeMsgResp.message);
    print(codeMsgResp.response);
  }

  // 매장명 전체조회
  Future<void> findAllStoreName() async {
    Response response = await _storeProvider.findAllStoreName();
    CodeMsgResp codeMsgResp = CodeMsgResp.fromJson(response.body);

    if (codeMsgResp.code == 1) {
      List<dynamic> temp = codeMsgResp.response;
      allStoreName = temp.map((e) => StoreNameResp.fromJson(e)).toList();
      storeNameUpdated = DateTime.now();
    }
  }

  // 즐겨찾기 전체조회
  Future<List<StoreResp>> findAllBookmark(String storeIds) async {
    Response response = await _storeProvider.findAllBookmark(storeIds);
    CodeMsgResp codeMsgResp = CodeMsgResp.fromJson(response.body);

    if (codeMsgResp.code == 1) {
      List<dynamic> temp = codeMsgResp.response;
      List<StoreResp> storeList =
          temp.map((store) => StoreResp.fromJson(store)).toList();
      return storeList;
    } else {
      return <StoreResp>[]; // StoreResp 타입의 빈 배열 반환
    }
  }

  // 검색매장 전체조회
  Future<List<StoreResp>> findAllByName(
      String name, double latitude, double longitude) async {
    Response response =
        await _storeProvider.findAllByName(name, latitude, longitude);
    CodeMsgResp codeMsgResp = CodeMsgResp.fromJson(response.body);

    if (codeMsgResp.code == 1) {
      List<dynamic> temp = codeMsgResp.response;
      List<StoreResp> storeList =
          temp.map((store) => StoreResp.fromJson(store)).toList();
      return storeList;
    } else {
      return <StoreResp>[]; // StoreResp 타입의 빈 배열 반환
    }
  }

  // 카테고리 매장 전체조회
  Future<List<StoreResp>> findAllByCategory(
      String category, double latitude, double longitude) async {
    Response response =
        await _storeProvider.findAllByCategory(category, latitude, longitude);
    CodeMsgResp codeMsgResp = CodeMsgResp.fromJson(response.body);

    if (codeMsgResp.code == 1) {
      List<dynamic> temp = codeMsgResp.response;
      List<StoreResp> storeList =
          temp.map((store) => StoreResp.fromJson(store)).toList();
      return storeList;
    } else {
      return <StoreResp>[]; // StoreResp 타입의 빈 배열 반환
    }
  }

  // 매장 상세조회
  Future<Store> findById(int storeId) async {
    Response response = await _storeProvider.findById(storeId);
    CodeMsgResp codeMsgResp = CodeMsgResp.fromJson(response.body);

    if (codeMsgResp.code == 1) {
      return Store.fromJson(codeMsgResp.response);
    } else {
      return Store();
    }
  }

  // 영업시간 전체조회
  Future<dynamic> findHours(int storeId) async {
    Response response = await _storeProvider.findHours(storeId);
    CodeMsgResp codeMsgResp = CodeMsgResp.fromJson(response.body);

    if (codeMsgResp.code == 1) {
      return HoursResp.fromJson(codeMsgResp.response);
    } else {
      return -1;
    }
  }

  // 영업상태 조회
  Future<dynamic> updateState(int storeId) async {
    Response response = await _storeProvider.updateState(storeId);
    CodeMsgResp codeMsgResp = CodeMsgResp.fromJson(response.body);

    if (codeMsgResp.code == 1) {
      return StateResp.fromJson(codeMsgResp.response);
    } else {
      return -1;
    }
  }

  // 매장정보 수정제안
  Future<int> requestUpdate(int storeId, Map data) async {
    Response response = await _storeProvider.requestUpdate(storeId, data);
    CodeMsgResp codeMsgResp = CodeMsgResp.fromJson(response.body);
    return codeMsgResp.code;
  }
}
