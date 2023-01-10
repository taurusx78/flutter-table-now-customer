import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/my_scroll_behavior.dart';
import 'package:table_now/ui/theme.dart';

void main() async {
  await dotenv.load(fileName: '.env'); // 추가

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 화면 세로 방향 고정
    // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // Jiffy 라이브러리 현지화
    Jiffy.locale('ko');
    // 안드로이드, iOS 상태바 색상 설정
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      statusBarIconBrightness: Brightness.dark,
    ));

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialRoute: Routes.splash,
      getPages: Pages.routes,
      // 스크롤 반짝이 효과 제거
      builder: (context, child) {
        return ScrollConfiguration(
          behavior: MyScrollBehavior(),
          child: child!,
        );
      },
    );
  }
}
