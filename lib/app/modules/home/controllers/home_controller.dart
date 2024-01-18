import 'package:get/get.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';
import 'package:musicplayer/app/routes/app_pages.dart';
import 'package:musicplayer/app/utils/permission_handler.dart';

class HomeController extends GetxController {
  final Rx<Map<String, List<AudioModel>>> audioData = Rx({});

  void onClickPhoneStorage() async {
    bool hasPermission =
        await PermissionHandler.instance.checkAndAskStoragePermission();
    if (hasPermission) {
      Get.toNamed(Routes.DIRECTORY_LIST);
    }
  }
}
