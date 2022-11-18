import 'package:get/get.dart';
import 'package:table_now/controller/dto/store_resp.dart';
import 'package:table_now/controller/location_controller.dart';
import 'package:table_now/data/store/store_repository.dart';

class StoreController extends GetxController {
  final StoreRepository _storeRepository = StoreRepository();
  final LocationController _locationController = Get.put(LocationController());
  final RxList<StoreResp> allStoreList = <StoreResp>[].obs; // 전체매장 목록
  final RxList<StoreResp> filteredStoreList = <StoreResp>[].obs; // 필터 적용 매장 목록
  final RxBool isLoaded = true.obs; // 매장 조회 완료 여부

  // 영업상태 필터
  final List<String> filterList = ['영업중', '잔여있음', '전체'];
  final RxInt curFilterIndex = 0.obs;

  // 매장 정렬 드롭다운
  final List<String> sortList = ['업데이트순', '가까운순', '정확도순'];
  final RxString curSortOption = '업데이트순'.obs;

  // 검색매장 전체조회
  Future<void> findAllByName(String name) async {
    isLoaded.value = false;

    allStoreList.value = await _storeRepository.findAllByName(
        name, _locationController.myLat.value, _locationController.myLon.value);
    if (allStoreList.isNotEmpty) {
      // 선택된 필터 적용
      filterStoreList();
    }

    isLoaded.value = true;
  }

  // 카테고리 매장 전체조회
  Future<void> findAllByCategory(String category) async {
    isLoaded.value = false;

    allStoreList.value = await _storeRepository.findAllByCategory(category,
        _locationController.myLat.value, _locationController.myLon.value);
    // 검색 필터 & 정렬 선택항목 초기화
    initializeFilterSort();
    if (allStoreList.isNotEmpty) {
      // 선택된 필터 적용
      filterStoreList();
    } else {
      filteredStoreList.value = [];
    }

    isLoaded.value = true;
  }

  // 선택된 필터 적용
  void filterStoreList() {
    if (curFilterIndex.value == 0) {
      // 1. 영업중
      filteredStoreList.value =
          allStoreList.where((store) => store.state == '영업중').toList();
    } else if (curFilterIndex.value == 1) {
      // 2. 잔여있음
      filteredStoreList.value = allStoreList
          .where((store) => store.state == '영업중' && store.tableCount != -1)
          .toList();
    } else {
      // 3. 전체
      filteredStoreList.value = allStoreList;
    }
    // 선택된 정렬 항목 적용
    sortStoreList();
  }

  // 선택된 정렬 항목 적용
  void sortStoreList() {
    if (curSortOption.value == '업데이트순') {
      // 1. 업데이트순
      filteredStoreList.sort((a, b) => -a.updated.compareTo(b.updated));
    } else if (curSortOption.value == '가까운순') {
      // 2. 가까운순
      filteredStoreList.sort((a, b) => a.distance.compareTo(b.distance));
    } else {
      // *** 3. 정확도순 구현 (또는 다른 항목으로 변경)
    }
  }

  // 필터 인덱스 변경
  void changeCurFilterIndex(index) {
    curFilterIndex.value = index;
  }

  // 정렬 선택항목 변경
  void changeCurSortOption(value) {
    curSortOption.value = value;
  }

  // 필터 인덱스 & 정렬 선택항목 초기화
  void initializeFilterSort() {
    curFilterIndex.value = 0;
    curSortOption.value = '업데이트순';
  }
}
