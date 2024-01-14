import 'package:get/get.dart';

import '../controllers/music_list_controller.dart';

class MusicListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MusicListController>(MusicListController());
  }
}
