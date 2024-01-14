import 'package:musicplayer/app/data/model/audio_model.dart';
import 'package:musicplayer/app/data/provider/database_provider.dart';
import 'package:musicplayer/app/data/provider/file_provider.dart';

class FileRepository {
  static const FileRepository _fileRepository = FileRepository._internal();
  static FileRepository get instance => _fileRepository;
  const FileRepository._internal();

  Future<void> insertMusics(List<AudioModel> audios) async {
    for (AudioModel audio in audios) {
      await DatabaseProvider.instance.insertMusic(
        params: audio.toJson()..remove("id"),
      );
    }
  }

  Future<List<AudioModel>> getAllMusics() async {
    List<Map<String, dynamic>> musics =
        await DatabaseProvider.instance.getMusics();
    return musics.map((e) => AudioModel.fromJson(e)).toList();
  }

  Future<int> deleteMusic({required int id}) async {
    return DatabaseProvider.instance.deleteMusic(id: id);
  }

  Future<List<String>> getAllMusicFilesPath() async {
    return await FileProvider.instance.getAllMusicFilesPath();
  }
}
