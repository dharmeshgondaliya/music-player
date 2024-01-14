import 'dart:io';

import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:get/get.dart';
import 'package:musicplayer/app/data/model/audio_model.dart';
import 'package:musicplayer/app/data/provider/file_provider.dart';
import 'package:musicplayer/app/data/repository/file_repository.dart';
import 'package:musicplayer/app/utils/permission_handler.dart';

class HomeController extends GetxController {
  final Rx<Map<String, List<AudioModel>>> audioData = Rx({});

  @override
  void onInit() {
    Future.delayed(Duration.zero, () => init());
    super.onInit();
  }

  void init() async {
    try {
      Map<String, List<AudioModel>> data = {};
      bool hasPermission =
          await PermissionHandler.instance.checkAndAskStoragePermission();
      if (hasPermission) {
        List filePaths = await FileProvider.instance.getAllMusicFilesPath();
        for (String filePath in filePaths) {
          // List splitPath = filePath.split("/");
          // data[splitPath[splitPath.length - 2]] ??= [];
          // data[splitPath[splitPath.length - 2]]?.add(
          //   AudioModel(
          //     filepath: filePath,
          //     filename: splitPath.last,
          //     parentDirectoryName: splitPath[splitPath.length - 2],
          //   ),
          // );
        }
      }
      audioData.value = data;
    } catch (e) {
      print("Exception: ${e.toString()}");
    }
  }

  void getFlieMetaData(List<AudioModel> files) async {
    for (AudioModel model in files) {
      // File file = File(model.filepath);
      // if (await file.exists()) {
      //   Metadata metadata = await MetadataRetriever.fromFile(file);
      //   print({
      //     "albumArtistName: ": metadata.albumArtistName,
      //     "albumName: ": metadata.albumName,
      //     "authorName: ": metadata.authorName,
      //     "genre: ": metadata.genre,
      //     "year: ": metadata.year,
      //     "trackArtistNames: ": metadata.trackArtistNames,
      //     "trackName: ": metadata.trackName,
      //     "writerName: ": metadata.writerName,
      //     "albumArt: ": metadata.albumArt,
      //   });
      //   if (metadata.albumArt != null) {
      //     File thumbnail = File("path");
      //     thumbnail.writeAsBytesSync(metadata.albumArt!);
      //   }
      // }
    }
  }
}
