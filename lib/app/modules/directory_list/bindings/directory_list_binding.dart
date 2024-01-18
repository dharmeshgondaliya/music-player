import 'package:get/get.dart';

import '../controllers/directory_list_controller.dart';

class DirectoryListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectoryListController>(
      () => DirectoryListController(),
    );
  }
}
