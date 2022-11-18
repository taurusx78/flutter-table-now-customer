import 'package:get/get.dart';
import 'package:table_now/data/store/store_repository.dart';
import 'package:table_now/data/sqlite_helper.dart';

class MainController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  final RxList bookmarkIdList = <int>[].obs; // 즐겨찾기 매장 id 목록
  final RxList bookmarkList = [].obs; // 즐겨찾기 매장 목록

  final RxInt curIndex = 0.obs; // 네이게이션바 현재 인덱스
  final RxBool isLoaded = true.obs; // 즐겨찾기 조회 여부

  @override
  void onInit() {
    super.onInit();
    findAllBookmark(false);
  }

  // *** 삭제된 매장의 id가 포함되어 있는 경우, 제거하기!
  // 즐겨찾기 전체조회
  Future<void> findAllBookmark(bool findAll) async {
    // 임의 추가
    // await SqliteHelper.addStoreId(3);

    isLoaded.value = false;

    if (!findAll) {
      // 5개 조회
      bookmarkIdList.value = await SqliteHelper.findFiveStoreIds();
    } else {
      // 전체조회
      bookmarkIdList.value = await SqliteHelper.findAllStoreId();
    }
    String storeIds = bookmarkIdList
        .toString()
        .replaceAll(' ', '')
        .replaceAll('[', '')
        .replaceAll(']', '');

    // 즐겨찾기 목록이 존재하는 경우
    if (storeIds != '') {
      bookmarkList.value = await _storeRepository.findAllBookmark(storeIds);
    } else {
      bookmarkList.value = [];
    }
    isLoaded.value = true;
  }

  // 네이게이션바 현재 인덱스 변경
  void changeIndex(int index) {
    curIndex.value = index;
  }
}
