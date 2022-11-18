import 'package:get/get.dart';
import 'package:table_now/controller/main_controller.dart';

class MainBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MainController());
  }
}
