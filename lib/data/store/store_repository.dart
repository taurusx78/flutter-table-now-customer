import 'package:get/get.dart';
import 'package:table_now/controller/dto/code_msg_resp_dto.dart';
import 'package:table_now/controller/dto/hours_resp_dto.dart';
import 'package:table_now/controller/dto/state_resp_dto.dart';
import 'package:table_now/controller/dto/store_name_resp_dto.dart';
import 'package:table_now/controller/dto/store_resp_dto.dart';
import 'package:table_now/data/store/store_provider.dart';
import 'package:table_now/util/all_store_name.dart';

import 'model/store.dart';

// Repository는 서버로부터 응답받은 데이터를 JSON에서 Dart 오브젝트로 변경하는 역할을 함

class StoreRepository {
  final StoreProvider _storeProvider = StoreProvider();

  // 매장명 전체조회
  Future<void> findAllStoreName() async {
    Response response = await _storeProvider.findAllStoreName();
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        List<dynamic> temp = dto.response['items'];
        allStoreName = temp.map((e) => StoreNameRespDto.fromJson(e)).toList();
        storeNameUpdated = DateTime.now();
      }
    }
  }

  // 즐겨찾기 전체조회
  Future<dynamic> findAllBookmark(String storeIds) async {
    Response response = await _storeProvider.findAllBookmark(storeIds);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        List<dynamic> temp = dto.response['items'];
        List<StoreRespDto> storeList =
            temp.map((store) => StoreRespDto.fromJson(store)).toList();
        return storeList;
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 검색매장 전체조회
  Future<dynamic> findAllByName(
      String name, double latitude, double longitude) async {
    Response response =
        await _storeProvider.findAllByName(name, latitude, longitude);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        List<dynamic> temp = dto.response['items'];
        List<StoreRespDto> storeList =
            temp.map((store) => StoreRespDto.fromJson(store)).toList();
        return storeList;
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 카테고리 매장 전체조회
  Future<dynamic> findAllByCategory(
      String category, double latitude, double longitude) async {
    Response response =
        await _storeProvider.findAllByCategory(category, latitude, longitude);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        List<dynamic> temp = dto.response['items'];
        List<StoreRespDto> storeList =
            temp.map((store) => StoreRespDto.fromJson(store)).toList();
        return storeList;
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 매장 상세조회
  Future<dynamic> findById(int storeId) async {
    Response response = await _storeProvider.findById(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return Store.fromJson(dto.response);
      }
      return dto.code; // 매장 없음 (404)
    }
    return 500; // 네트워크 연결 안됨
  }

  // 영업시간 전체조회
  Future<dynamic> findHours(int storeId) async {
    Response response = await _storeProvider.findHours(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return HoursRespDto.fromJson(dto.response);
      }
    }
    return null; // 네트워크 연결 안됨 or 기타 오류 발생
  }

  // 영업상태 조회
  Future<dynamic> updateState(int storeId) async {
    Response response = await _storeProvider.updateState(storeId);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      if (dto.code == 200) {
        return StateRespDto.fromJson(dto.response);
      }
      return dto.code;
    }
    return 500; // 네트워크 연결 안됨
  }

  // 매장정보 수정제안
  Future<int> requestUpdate(int storeId, Map data) async {
    Response response = await _storeProvider.requestUpdate(storeId, data);
    if (response.body != null) {
      CodeMsgRespDto dto = CodeMsgRespDto.fromJson(response.body);
      return dto.code; // 제안 성공 (200)
    } else {
      return 500; // 네트워크 연결 안됨
    }
  }
}
