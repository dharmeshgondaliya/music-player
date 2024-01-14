import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';
import 'package:musicplayer/app/data/model/audio_player_state.dart';
import 'package:musicplayer/app/data/provider/audio_provider.dart';

class PlayerScreenController extends GetxController {
  final List<AudioModel> audios = Get.arguments['audios'] ?? [];
  final RxInt index = RxInt(Get.arguments['index'] ?? 0);
  final RxBool isFavourite = RxBool(false);
  final PageController pageController =
      PageController(initialPage: Get.arguments['index'] ?? 0);
  // final StreamController<PlayerState> streamController = StreamController();
  late final StreamSubscription<AudioPlayerState> playerStateStream;

  @override
  void onInit() {
    Future.delayed(Duration.zero, init);
    super.onInit();
  }

  @override
  void onClose() {
    try {
      AudioProvider.instance.setHandleAutoPlay = true;
      playerStateStream.cancel();
    } catch (e) {
      e.toString();
    }
    super.onClose();
  }

  void init() async {
    AudioProvider.instance.setMusicPlayList = audios;
    AudioProvider.instance.setPlayingIndex = index.value;
    AudioProvider.instance.setHandleAutoPlay = false;
    if (audios[index.value].id !=
        AudioProvider.instance.currentAudioPlaying?.id) {
      setCurrentAudio();
    }
    listenAudioPlaying();
  }

  Future<void> setCurrentAudio() async {
    if (audios[index.value].path == null) return;
    await AudioProvider.instance.setFilePath(audios[index.value]);
    await AudioProvider.instance.play();
  }

  void listenAudioPlaying() async {
    playerStateStream =
        AudioProvider.instance.playerStateStream.listen((event) {
      if (event.playerState.processingState == ProcessingState.completed) {
        int changeIndex = 0;
        if (audios.length != index.value + 1) {
          changeIndex = index.value + 1;
        }
        if (!isClosed) {
          pageController.animateToPage(
            changeIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  void toggleFafvourite() {
    isFavourite.value = !isFavourite.value;
  }

  void togglePlaying() async {
    if (AudioProvider.instance.playing) {
      await AudioProvider.instance.pause();
    } else {
      await AudioProvider.instance.play();
    }
  }

  void seekAudio(double seconds) {
    AudioProvider.instance.seek(Duration(seconds: seconds.toInt()));
  }

  void changeNextPrevious(int val) {
    pageController.animateToPage(
      val,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void changeMusic(int val) async {
    AudioProvider.instance.setPlayingIndex = val;
    await AudioProvider.instance.pause();
    index.value = val;
    await setCurrentAudio();
  }
}
