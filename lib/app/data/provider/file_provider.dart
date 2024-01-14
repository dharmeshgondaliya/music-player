import 'dart:async';
import 'dart:io';

import 'package:musicplayer/app/utils/constants.dart';

class FileProvider {
  static const FileProvider _fileProvider = FileProvider._internal();
  static FileProvider get instance => _fileProvider;
  const FileProvider._internal();

  Future<List<String>> getAllMusicFilesPath() async {
    final Completer<List<String>> fileCompleter = Completer<List<String>>();
    Directory directory = Directory("/storage/emulated/0");
    List<String> files = [];
    directory.list(recursive: true).listen((event) {
      String extension = event.path.split(".").last.toLowerCase();
      if (audioExtensions.contains(extension)) {
        files.add(event.path);
      }
    }).onDone(() {
      fileCompleter.complete(files);
    });
    return fileCompleter.future;
  }
}
