import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_now/controller/main_controller.dart';
import 'package:table_now/data/category.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/category_item.dart';
import 'package:table_now/ui/components/kakao_banner_ad.dart';
import 'package:table_now/ui/components/state_round_box.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/screen_size.dart';
import 'package:table_now/util/host.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  MainController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Align(
          alignment: Alignment.topCenter,
          child: SingleChildScrollView(
            child: Container(
              width: 600,
              margin: const EdgeInsets.all(15),
              child: Column(
                children: [
                  // 앱 제목
                  _buildAppTitle(),
                  const SizedBox(height: 30),
                  // 검색바
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  // 카테고리 목록
                  _buildCategoryList(),
                  const SizedBox(height: 20),
                  // 광고
                  const KakaoBannerAd(),
                  const SizedBox(height: 20),
                  // 즐겨찾기 헤더
                  _buildBookmarkHeader(),
                  const SizedBox(height: 15),
                  Obx(
                    () => controller.isLoaded.value
                        ? controller.bookmarkList.isNotEmpty
                            ? _buildBookmarkList()
                            : _buildNoBookmarkBox()
                        : const SizedBox(
                            height: 200,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                                strokeWidth: 2,
                              ),
                            ),
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
        text: 'TABLE ',
        style: TextStyle(
          fontSize: 25,
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
        width: 600,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: primaryColor, width: 2),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: primaryColor),
            SizedBox(width: 10),
            Text(
              '궁금한 매장은 어디인가요?',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            )
          ],
        ),
      ),
      onTap: () {
        Get.toNamed(Routes.search);
      },
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      width: 500,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, // 행에 보여줄 item 개수
          mainAxisSpacing: 10, // item 수직 간격
          crossAxisSpacing: 10, // item 수평 간격
          childAspectRatio: 1 / 1.32, // item 너비:높이 비율
        ),
        itemBuilder: (context, index) {
          double fontSize = getScreenWidth(context) < 500 ? 12.5 : 14;
          if (index < 9) {
            return CategoryItem(
              label: categoryList[index].label,
              image: categoryList[index].image,
              fontSize: fontSize,
            );
          } else {
            return InkWell(
              borderRadius: BorderRadius.circular(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 1), // 자식 위젯 간 간격 조절을 위해 삽입
                  const Icon(Icons.more_horiz, size: 30, color: primaryColor),
                  Text('더보기', style: TextStyle(fontSize: fontSize)),
                ],
              ),
              onTap: () {
                controller.changeIndex(1);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildBookmarkHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '즐겨찾기',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        InkWell(
          child: Row(
            children: const [
              Text(
                '전체보기',
                style: TextStyle(color: Colors.black54),
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
      height: 260, // 높이 지정 필수!
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
          const SizedBox(height: 5),
          // 매장명
          Text(
            store.name.replaceAll('', '\u{200B}'), // 말줄임 에러 방지
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
            maxLines: 1, // 한 줄 말줄임
          ),
          const SizedBox(height: 5),
          // 영업상태
          StateRoundBox(
            state: store.state,
            tableCount: store.tableCount,
          ),
          const SizedBox(height: 5),
          // 업데이트 시간
          RichText(
            text: TextSpan(
              children: [
                const WidgetSpan(
                  child: Icon(
                    Icons.update,
                    color: Colors.black54,
                    size: 16,
                  ),
                ),
                TextSpan(
                  text: ' 업데이트 ' + Jiffy(store.updated).fromNow(),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Get.toNamed(Routes.details, arguments: store.id);
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
              Icons.star_rounded,
              color: primaryColor,
              size: 35,
            ),
            SizedBox(height: 10),
            Text(
              '관심 매장을 등록해 보세요!',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
