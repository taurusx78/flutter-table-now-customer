import 'package:flutter/material.dart';
import 'package:flutter_adfit/flutter_adfit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_now/controller/details_controller.dart';
import 'package:table_now/controller/location_controller.dart';
import 'package:table_now/controller/main_controller.dart';
import 'package:table_now/data/category.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/category_item.dart';
import 'package:table_now/ui/components/custom_divider.dart';
import 'package:table_now/ui/components/loading_indicator.dart';
import 'package:table_now/ui/components/location_bar.dart';
import 'package:table_now/ui/components/show_toast.dart';
import 'package:table_now/ui/components/state_round_box.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/screen_size.dart';
import 'package:table_now/util/host.dart';

class HomePage extends GetView<MainController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              // 앱 타이틀
              _buildAppTitle(),
              const SizedBox(height: 15),
              // 검색바
              _buildSearchBar(),
            ],
          ),
          toolbarHeight: 130,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: SizedBox(
              width: 600,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        // 현재 위치
                        LocationBar(
                          tapFunc: () async {
                            String result = await Get.find<LocationController>()
                                .getCurrentLocation();
                            showToast(context, result, null);
                          },
                        ),
                        const SizedBox(height: 25),
                        // 카테고리 목록
                        _buildCategoryList(context),
                      ],
                    ),
                  ),
                  const CustomDivider(height: 10, bottom: 0),
                  // 광고
                  _buildKakaoBannerAd(),
                  const CustomDivider(height: 10, top: 0),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    child: Column(
                      children: [
                        // 즐겨찾기 헤더
                        _buildBookmarkHeader(),
                        const SizedBox(height: 15),
                        Obx(
                          () => controller.loaded.value
                              ? controller.connected.value
                                  ? controller.bookmarkList.isNotEmpty
                                      ? _buildBookmarkList()
                                      : _buildNoBookmarkBox()
                                  : _buildNetworkDisconnectedBox()
                              : const LoadingIndicator(height: 200),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppTitle() {
    return RichText(
      text: const TextSpan(
        text: ' TABLE ',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: 'NOW',
            style: TextStyle(color: primaryColor),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      child: Container(
        height: 55,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: primaryColor, width: 2),
        ),
        child: Center(
          child: Row(
            children: const [
              Icon(Icons.search, size: 25, color: primaryColor),
              SizedBox(width: 10),
              Text(
                '궁금한 매장은 어디인가요?',
                style: TextStyle(fontSize: 16, color: darkNavy),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Get.toNamed(Routes.search)!.then((value) {
          // 즐겨찾기 5개 조회
          controller.findAllBookmark(false);
        });
      },
    );
  }

  Widget _buildCategoryList(context) {
    bool isNarrow = getScreenWidth(context) - 30 < 600;
    int lastIndex = isNarrow ? 7 : 9;

    return SizedBox(
      width: 600,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: isNarrow ? 8 : 10,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isNarrow ? 4 : 5, // 행에 보여줄 item 개수
          mainAxisSpacing: 10, // item 수직 간격
          crossAxisSpacing: 10, // item 수평 간격
          childAspectRatio: isNarrow ? 1 / 1.3 : 1 / 1, // item 너비:높이 비율
        ),
        itemBuilder: (context, index) {
          if (index < lastIndex) {
            return CategoryItem(
              label: categoryList[index].label,
              image: categoryList[index].image,
              fontSize: 14,
            );
          } else {
            return _buildMoreButton();
          }
        },
      ),
    );
  }

  Widget _buildMoreButton() {
    return GestureDetector(
      child: Column(
        children: [
          Container(
            width: 75,
            height: 75,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: blueGrey, width: 1),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: lightGrey,
              ),
              child: const Icon(
                Icons.more_horiz,
                size: 40,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            '더보기',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      onTap: () {
        controller.changeIndex(1);
      },
    );
  }

  Widget _buildKakaoBannerAd() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 100,
          color: blueGrey,
          child: const Center(
            child: Text('테이블나우'),
          ),
        ),
        Positioned(
          child: SizedBox(
            width: double.infinity,
            child: AdFitBanner(
              adId: 'DAN-7DN8T9jTw7bTvG3H',
              adSize: AdFitBannerSize.BANNER,
              listener: (AdFitEvent event, AdFitEventData data) {
                switch (event) {
                  case AdFitEvent.AdReceived:
                    break;
                  case AdFitEvent.AdClicked:
                    break;
                  case AdFitEvent.AdReceiveFailed:
                    print('카카오 애드핏 광고 노출 실패');
                    break;
                  case AdFitEvent.OnError:
                    print('카카오 애드핏 광고 초기화 실패');
                    break;
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookmarkHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '즐겨찾기',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
        ),
        InkWell(
          child: Row(
            children: const [
              Text(
                '전체보기',
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Colors.black54,
                size: 20,
              ),
            ],
          ),
          onTap: () {
            controller.changeIndex(2);
          },
        ),
      ],
    );
  }

  Widget _buildBookmarkList() {
    return SizedBox(
      height: 270, // 높이 지정 필수!
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: controller.bookmarkList.length,
        itemBuilder: (context, index) {
          return _buildBookmarkItem(index, controller.bookmarkList[index]);
        },
        separatorBuilder: (context, index) => const SizedBox(width: 10),
      ),
    );
  }

  Widget _buildBookmarkItem(index, store) {
    return GestureDetector(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 대표사진
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: blueGrey, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                '$host/image?type=basic&filename=' + store.basicImageUrl,
                width: 170,
                height: 170,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 7),
          // 매장명
          Text(
            store.name.replaceAll('', '\u{200B}'), // 말줄임 에러 방지
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1, // 한 줄 말줄임
          ),
          const SizedBox(height: 7),
          // 영업상태
          StateRoundBox(
            state: store.state,
            tableCount: store.tableCount,
          ),
          const SizedBox(height: 7),
          // 업데이트 시간
          RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.update,
                    color: Colors.black54,
                    size: 17,
                  ),
                ),
                TextSpan(
                  text: ' 업데이트 ' + Jiffy(store.updated).fromNow(),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () async {
        // 매장 상세조회 (비동기 조회)
        Get.put(DetailsController()).findById(store.id);
        Get.toNamed(Routes.details, arguments: store.id)!.then((value) {
          // 즐겨찾기 5개 조회
          controller.findAllBookmark(false);
        });
      },
    );
  }

  Widget _buildNoBookmarkBox() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(color: blueGrey, width: 1),
      ),
      elevation: 0.5,
      color: Colors.white,
      child: SizedBox(
        width: 600,
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(
              Icons.favorite_border_rounded,
              color: red,
              size: 35,
            ),
            SizedBox(height: 10),
            Text(
              '관심 매장을 등록해 보세요!',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkDisconnectedBox() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
        side: const BorderSide(color: blueGrey, width: 1),
      ),
      elevation: 0.5,
      color: Colors.white,
      child: SizedBox(
        width: 600,
        height: 170,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/icons/error_small.png',
              width: 35,
              color: darkNavy,
            ),
            const SizedBox(height: 10),
            const Text(
              '네트워크 연결 상태를 확인해 주세요.',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
