import 'package:get/get.dart';
import 'package:table_now/controller/details_controller.dart';

class DetailsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DetailsController());
  }
}
