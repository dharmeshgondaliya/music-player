import 'dart:async';
import 'package:get/get.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';

class MusicListController extends GetxController {
  List<AudioModel> audioFiles = Get.arguments;

  @override
  void onInit() {
    Future.delayed(Duration.zero, () => init());
    super.onInit();
  }

  void init() async {}
}
