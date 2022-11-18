import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:table_now/controller/details_controller.dart';
import 'package:table_now/data/store/model/store.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/dialog_ui.dart';
import 'package:table_now/ui/components/loading_indicator.dart';
import 'package:table_now/ui/components/show_toast.dart';
import 'package:table_now/ui/components/state_round_box.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/details/components/custom_divider.dart';
import 'package:table_now/ui/details/components/hours_bottom_sheet.dart';
import 'package:table_now/ui/details/components/image_horizontal_list.dart';
import 'package:table_now/ui/details/components/notice_swiper.dart';
import 'package:table_now/util/host.dart';

import 'components/index_indicator.dart';
import 'components/naver_blog_list.dart';
import 'components/time_row_text.dart';

class DetailsPage extends GetView<DetailsController> {
  DetailsPage({Key? key}) : super(key: key);

  final int storeId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: FutureBuilder(
          future: controller.findById(storeId),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoadingIndicator(height: 200);
            } else {
              Store store = controller.store.value;
              // 조회 실패 (네트워크 연결 안됨)
              if (store.id == null) {
                return _buildNetworkNotConnected();
              }
              return CustomScrollView(
                controller: controller.scrollController,
                slivers: [
                  Obx(
                    () => SliverAppBar(
                      // 축소 시 상단에 AppBar 고정
                      pinned: true,
                      // 매장명
                      title: Text(
                        store.name!,
                        style: TextStyle(
                          fontSize: 18,
                          color: controller.isSliverAppBarExpanded()
                              ? Colors.transparent
                              : Colors.black,
                        ),
                      ),
                      // 대표사진
                      flexibleSpace: FlexibleSpaceBar(
                        background: _buildBasicImageList(store),
                      ),
                      expandedHeight: 280,
                      // 즐겨찾기 추가/삭제 버튼
                      actions: [
                        _buildLikeToggleButton(),
                      ],
                      foregroundColor: controller.appBarIconColor.value,
                      elevation: 0.5,
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Column(
                        children: [
                          // 매장명/주소/영업상태/기능버튼
                          _buildMainInfoBox(store),
                          Container(
                            height: 1,
                            color: blueGrey,
                          ),
                          // 알림 목록
                          if (store.noticeList!.isNotEmpty)
                            NoticeSwiper(noticeList: store.noticeList!),
                          // 그 외 매장 정보
                          _buildSubInfoBox(context, store),
                          Container(
                            height: 1,
                            color: blueGrey,
                          ),
                          // 안내문구
                          _buildGuideText(context),
                        ],
                      )
                    ]),
                  ),
                ],
              );
            }
          },
        ),
        floatingActionButton: _buildStateUpdateButton(),
      ),
    );
  }

  Widget _buildStateUpdateButton() {
    return FloatingActionButton(
      onPressed: () async {
        // 버튼 회전 애니메이션
        controller.changeTurns();
        // 영업상태 업데이트
        int result = await controller.updateState(storeId);
        if (result == 1) {
          showToast('정보가 업데이트 되었습니다.');
        } else {
          showToast('오류가 발생했습니다. 잠시후 다시 시도해주세요.');
        }
      },
      backgroundColor: Colors.blueGrey,
      child: Obx(
        () => AnimatedRotation(
          turns: controller.turns.value,
          duration: const Duration(milliseconds: 500),
          child: const Icon(Icons.refresh_rounded, size: 30),
        ),
      ),
    );
  }

  Widget _buildNetworkNotConnected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/error.png',
            width: 50,
            color: Colors.black54,
          ),
          const SizedBox(height: 30),
          const Text(
            '정보 불러오기에 실패하였습니다.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          const Text(
            '네트워크 연결을 확인해주세요.',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          TextButton(
            child: const Text(
              '뒤로가기',
              style: TextStyle(fontSize: 15, color: primaryColor),
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBasicImageList(store) {
    int basicImageCount = store.basicImageUrlList!.length;
    return Stack(
      children: [
        Swiper(
          itemCount: basicImageCount,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Image.network(
                '$host/image?type=basic&filename=' +
                    store.basicImageUrlList![index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Get.toNamed(
                  Routes.image,
                  arguments: ['basic', store.basicImageUrlList, index],
                );
              },
            );
          },
          onIndexChanged: (index) {
            controller.changeCurBasicImageIndex(index);
          },
          loop: false,
        ),
        // 이미지 인덱스 Indicator
        Positioned(
          right: 5,
          bottom: 5,
          child: Obx(
            () => IndexIndicator(
              index: controller.curBasicImageIndex.value + 1,
              length: basicImageCount,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLikeToggleButton() {
    return IconButton(
      splashRadius: 20,
      icon: !controller.isBookmarked.value
          ? const Icon(
              Icons.favorite_border_rounded,
            )
          : const Icon(
              Icons.favorite_rounded,
              color: red,
            ),
      onPressed: () async {
        String result = await controller.changeIsBookmarked(storeId);
        showToast(result);
      },
    );
  }

  Widget _buildMainInfoBox(store) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 매장명
          Text(
            store.name!,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          // 주소
          Text(
            store.address!,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 15),
          Obx(
            () => RichText(
              text: TextSpan(
                children: [
                  // 영업상태
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: StateRoundBox(
                      state: controller.state.value,
                      tableCount: controller.tableCount.value,
                    ),
                  ),
                  // 업데이트 시간
                  const WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10, right: 5),
                      child: Icon(
                        Icons.update,
                        color: Colors.black54,
                        size: 17,
                      ),
                    ),
                  ),
                  TextSpan(
                    text: '업데이트 ${controller.updated.value}',
                    style: const TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          // 기능 버튼 모음
          _buildIconButtons(store),
        ],
      ),
    );
  }

  Widget _buildIconButtons(store) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 전화
        _buildIconButtonItem(Icons.phone_rounded, '전화', () {
          controller.launchPhoneUrl();
        }),
        // 위치
        _buildIconButtonItem(Icons.location_on, '위치', () {
          Get.toNamed(Routes.naverMap, arguments: [
            store.name!,
            store.address!,
            store.latitude!,
            store.longitude!
          ]);
        }),
        // 공유
        _buildIconButtonItem(Icons.share, '공유', () {
          Share.share(
              '\'' + controller.store.value.name! + '\'의 실시간 영업정보를 확인해보세요!');
          // *** 앱 연결 링크 추가 ***
        }),
      ],
    );
  }

  Widget _buildIconButtonItem(IconData icon, String label, dynamic tapFunc) {
    return SizedBox(
      width: 80,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: blueGrey, width: 1),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.blueGrey,
                  size: 25,
                ),
              ),
            ),
            onTap: tapFunc,
          ),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildSubInfoBox(context, Store store) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          // 오늘의 영업정보
          _buildTodayInfo(context),
          const CustomDivider(),
          // 소개
          _buildDescription(store.description!),
          const CustomDivider(),
          // 웹사이트
          if (store.website != '') _buildWebsite(store.website!),
          // 메뉴사진
          _buildMenuImageList(store.menuImageUrlList!, store.menuModified!),
          const CustomDivider(),
          // 매장내부사진
          _buildInsideImageList(
              store.insideImageUrlList!, store.allTableCount!),
          // 블로그 리뷰 목록
          if (store.blogList!.isNotEmpty)
            NaverBlogList(blogList: store.blogList!),
        ],
      ),
    );
  }

  Widget _buildTodayInfo(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 오늘의 영업정보 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              '오늘의 영업정보',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            InkWell(
              child: const Text(
                '전체보기',
                style: TextStyle(color: primaryColor),
              ),
              onTap: () {
                // 전체 영업정보 BottomSheet
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (context) {
                    return HoursBottomSheet();
                  },
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 15),
        // 오늘의 영업정보
        Obx(
          () => controller.businessHours.value != '없음'
              ? Column(
                  children: [
                    TimeRowText(
                        title: '영업시간', info: controller.businessHours.value),
                    const SizedBox(height: 10),
                    TimeRowText(
                        title: '휴게시간', info: controller.breakTime.value),
                    if (controller.lastOrder.value != '없음')
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TimeRowText(
                            title: '주문마감', info: controller.lastOrder.value),
                      ),
                  ],
                )
              : TimeRowText(
                  title: '영업시간', info: '오늘은 ${controller.state.value}입니다.'),
        ),
      ],
    );
  }

  Widget _buildDescription(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 소개 헤더
        const Text(
          '소개',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: double.infinity, height: 15),
        // 소개 내용
        Text(
          description,
          style: const TextStyle(fontSize: 15),
        ),
      ],
    );
  }

  Widget _buildWebsite(String website) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 웹사이트 헤더
        const Text(
          '웹사이트',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        // 웹사이트 링크
        InkWell(
          child: RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: Icon(
                      Icons.language_rounded,
                      size: 15,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                TextSpan(
                  text: website,
                  style: const TextStyle(fontSize: 15, color: primaryColor),
                )
              ],
            ),
          ),
          // onTap: controller.launchWebsiteUrl,
          onTap: () {},
        ),
        const CustomDivider(),
      ],
    );
  }

  Widget _buildMenuImageList(
      List<String> menuImageUlList, String menuModified) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 메뉴판사진 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '메뉴판사진',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Text(
                  '${menuImageUlList.length}개',
                  style: const TextStyle(color: primaryColor),
                ),
              ],
            ),
            Text(
              '최종수정일: $menuModified',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // 메뉴판사진 목록
        ImageHorizontalList(type: 'menu', imageUrlList: menuImageUlList),
      ],
    );
  }

  Widget _buildInsideImageList(
      List<String> insideImageUlList, int allTableCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 매장내부사진 헤더
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Text(
                  '매장내부사진',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Text(
                  '${insideImageUlList.length}개',
                  style: const TextStyle(color: primaryColor),
                ),
              ],
            ),
            Text(
              '전체테이블: $allTableCount',
              style: const TextStyle(color: Colors.black54),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // 매장내부사진 목록
        ImageHorizontalList(type: 'inside', imageUrlList: insideImageUlList),
      ],
    );
  }

  Widget _buildGuideText(context) {
    return Container(
      width: double.infinity,
      height: 150,
      color: lightGrey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'ⓘ 해당 정보는 매장 상황에 따라 달라질 수 있습니다.',
            style: TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
          // 정보수정제안 버튼
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: blueGrey),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.edit_outlined,
                      color: primaryColor,
                      size: 20,
                    ),
                    Text(' 정보 수정 제안', style: TextStyle(fontSize: 15)),
                  ],
                ),
              ),
              onTap: () {
                // 항목 체크 여부 초기화
                controller.initializeItemIsChecked();
                _showUpdateReqDialog(context);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateReqDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                '정보 수정 제안',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                '수정을 원하는 항목을 선택해 주세요.',
                style: TextStyle(fontSize: 15),
              ),
            ],
          ),
          titlePadding: const EdgeInsets.all(20),
          content: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: blueGrey),
                bottom: BorderSide(color: blueGrey),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(controller.infoItems.length, (index) {
                  return Obx(
                    () => _buildCheckboxItem(index),
                  );
                }).toList(),
              ),
            ),
          ),
          contentPadding: EdgeInsets.zero,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  child: const Text(
                    '취소',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black54,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context); // alertDialog 닫기
                  },
                ),
                TextButton(
                  child: const Text(
                    '확인',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  onPressed: () {
                    if (controller.atLeastOneIsChecked()) {
                      Navigator.pop(context); // alertDialog 닫기
                      _showSendMailDialog(context);
                    } else {
                      showToast('항목을 최소 하나 선택해주세요.');
                    }
                  },
                ),
              ],
            )
          ],
        );
      },
    );
  }

  Widget _buildCheckboxItem(int index) {
    return CheckboxListTile(
      title: Row(
        children: [
          Icon(
            controller.infoItemIcons[index],
            size: 20,
            color: Colors.blueGrey,
          ),
          const SizedBox(width: 10),
          Text(controller.infoItems[index]),
        ],
      ),
      value: controller.itemIsChecked[index].value,
      activeColor: primaryColor,
      onChanged: (value) {
        controller.changeItemIsChecked(index, value!);
      },
    );
  }

  void _showSendMailDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog 밖의 화면 터치 못하도록 설정
      builder: (BuildContext context) {
        return DialogUI(
          content: '[${controller.store.value.name!}]에 정보수정 제안 메일을 전송하시겠습니까?',
          checkFunc: () async {
            Navigator.pop(context); // alertDialog 닫기
            // 매장정보 수정제안
            int result = await controller.requestUpdate(storeId);
            if (result == 1) {
              showToast('메일이 전송되었습니다.');
            } else {
              showToast('오류가 발생했습니다. 잠시후 다시 시도해주세요.');
            }
          },
        );
      },
    );
  }
}