import 'package:get/get.dart';
import 'package:table_now/controller/search_controller.dart';

class SearchBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchController());
  }
}
