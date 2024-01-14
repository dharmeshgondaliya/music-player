import 'package:get/get.dart';
import 'package:musicplayer/app/data/provider/audio_provider.dart';
import 'package:musicplayer/app/data/provider/database_provider.dart';
import 'package:musicplayer/app/routes/app_pages.dart';

class SplashScreenController extends GetxController {
  final count = 0.obs;
  @override
  void onInit() {
    Future.delayed(Duration.zero, () => init());
    super.onInit();
  }

  void init() async {
    await DatabaseProvider.instance.init();
    AudioProvider.instance.init();
    Future.delayed(Duration.zero, () => Get.offNamed(Routes.MUSIC_LIST));
  }
}
