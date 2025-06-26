import 'package:get/get.dart';

import '../controllers/mapping_controller.dart';

class MappingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MappingController>(
      () => MappingController(),
    );
  }
}
