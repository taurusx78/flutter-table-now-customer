import 'package:get/get.dart';
import 'package:table_now/util/host.dart';

// Provider는 서버와 통신하는 역할을 함

class StoreProvider extends GetConnect {
  // 매장명 전체조회
  Future<Response> findAllStoreName() async => await get('$host/names');

  // 즐겨찾기 전체조회
  Future<Response> findAllBookmark(String storeIds) async =>
      await get('$host/bookmark?storeIds=$storeIds');

  // 검색매장 전체조회
  Future<Response> findAllByName(
          String name, double latitude, double longitude) async =>
      await get(
          '$host/search?data=$name&latitude=$latitude&longitude=$longitude');

  // 카테고리 매장 전체조회
  Future<Response> findAllByCategory(
          String category, double latitude, double longitude) async =>
      await get(
          '$host/category?data=$category&latitude=$latitude&longitude=$longitude');

  // 매장 상세조회
  Future<Response> findById(int id) async => await get('$host/store/$id');

  // 영업시간 전체조회
  Future<Response> findHours(int id) async =>
      await get('$host/store/$id/hours');

  // 영업상태 업데이트
  Future<Response> updateState(int id) async =>
      await get('$host/store/$id/state');

  // 매장정보 수정제안
  Future<Response> requestUpdate(int id, Map data) async =>
      await post('$host/store/$id/change', data);
}
