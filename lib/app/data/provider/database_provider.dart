import 'package:sqflite/sqflite.dart';

class DatabaseProvider {
  static final DatabaseProvider _databaseProvider =
      DatabaseProvider._internal();
  static DatabaseProvider get instance => _databaseProvider;
  DatabaseProvider._internal();
  late final Database? _database;

  Future<void> init() async {
    String path = await getDatabasesPath();
    _database = await openDatabase(
      "$path/music.db",
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "create table musics(id INTEGER PRIMARY KEY,name TEXT,path TEXT,directory TEXT)",
        );
      },
    );
  }

  Future<int> insertMusic({required Map<String, dynamic> params}) async {
    return await _database?.insert("musics", params) ?? 0;
  }

  Future<int> updateMusic(
      {required int id, required Map<String, dynamic> params}) async {
    return await _database
            ?.update("musics", params, where: 'id=?', whereArgs: [id]) ??
        0;
  }

  Future<int> deleteMusic({required int id}) async {
    return await _database?.delete("musics", where: "id=?", whereArgs: [id]) ??
        0;
  }

  Future<List<Map<String, dynamic>>> getMusics() async {
    return await _database?.query("musics") ?? [];
  }
}
