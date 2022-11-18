import 'package:get/get.dart';
import 'package:table_now/controller/store_controller.dart';

class StoreBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StoreController());
  }
}
