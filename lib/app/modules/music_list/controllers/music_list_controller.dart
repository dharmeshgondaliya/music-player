import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';
import 'package:musicplayer/app/data/repository/file_repository.dart';
import 'package:musicplayer/app/utils/permission_handler.dart';

class MusicListController extends GetxController {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final Rx<Map<String, List<AudioModel>>> audioData = Rx({});
  final Rxn<PlayerState> playerState = Rxn();

  @override
  void onInit() {
    Future.delayed(Duration.zero, () => init());
    super.onInit();
  }

  void init() async {
    try {
      bool hasPermission =
          await PermissionHandler.instance.checkAndAskStoragePermission();
      if (hasPermission) {
        List<AudioModel> audios = await FileRepository.instance.getAllMusics();
        Map<String, List<AudioModel>> data = {};
        for (AudioModel audio in audios) {
          data[audio.directory!] ??= [];
          data[audio.directory!]?.add(audio);
        }
        audioData.value = data;
        List<String> filePaths =
            await FileRepository.instance.getAllMusicFilesPath();
        List<String> audioPaths =
            audios.map((element) => element.path ?? "").toList()..remove("");
        bool hasUpdate = await syncFiles(filePaths, audioPaths);
        if (hasUpdate) {
          audios = await FileRepository.instance.getAllMusics();
          data = {};
          for (AudioModel audio in audios) {
            data[audio.directory!] ??= [];
            data[audio.directory!]?.add(audio);
          }
          audioData.value = data;
        }
      }
    } catch (e) {
      print("Exception: $e");
    }
  }

  Future<bool> syncFiles(List<String> files, List<String> audios) async {
    files.removeWhere((element) => audios.contains(element));
    audios.removeWhere((element) => files.contains(element));
    if (files.isEmpty && audios.isEmpty) return false;
    if (audios.isNotEmpty) {}

    if (files.isNotEmpty) {
      List<AudioModel> audioModels = [];
      for (String path in files) {
        List splitPath = path.split("/");
        File file = File(path);
        if (await file.exists()) {
          audioModels.add(AudioModel(
            name: splitPath.last,
            path: path,
            directory: splitPath[splitPath.length - 2],
          ));
        }
      }
      await FileRepository.instance.insertMusics(audioModels);
    }
    return true;
  }
}
