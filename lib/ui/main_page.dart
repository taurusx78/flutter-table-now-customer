import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/main_controller.dart';
import 'package:table_now/ui/app_info/app_info_page.dart';
import 'package:table_now/ui/bookmark/bookmark_page.dart';
import 'package:table_now/ui/category/category_page.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/home/home_page.dart';

class MainPage extends GetView<MainController> {
  MainPage({Key? key}) : super(key: key);

  final List<Widget> pages = [
    const HomePage(),
    const CategoryPage(),
    const BookmarkPage(),
    const AppInfoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => WillPopScope(
        // 홈이 아닐 때 뒤로가기 누를 경우, 홈으로 이동
        onWillPop: () async {
          if (controller.curIndex.value == 0) {
            return true;
          } else {
            controller.changeIndex(0);
            return false;
          }
        },
        child: Scaffold(
          body: pages[controller.curIndex.value],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: controller.curIndex.value,
            onTap: (index) {
              controller.changeIndex(index);
            },
            // 각 아이템 간격 고정
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: primaryColor,
            selectedFontSize: 13,
            unselectedFontSize: 13,
            items: const [
              BottomNavigationBarItem(
                icon: SizedBox(
                  width: 30,
                  height: 35,
                  child: Icon(Icons.home_rounded, size: 28),
                ),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  width: 30,
                  height: 35,
                  child: Icon(Icons.widgets_rounded, size: 25),
                ),
                label: '카테고리',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  width: 30,
                  height: 35,
                  child: Icon(Icons.favorite, size: 25),
                ),
                label: '즐겨찾기',
              ),
              BottomNavigationBarItem(
                icon: SizedBox(
                  width: 30,
                  height: 35,
                  child: Icon(Icons.more_horiz, size: 30),
                ),
                label: '더보기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
