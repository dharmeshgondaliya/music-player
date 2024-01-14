class AudioModel {
  int? id;
  String? name;
  String? path;
  String? directory;

  AudioModel({
    this.id,
    this.name,
    this.path,
    this.directory,
  });

  AudioModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    path = json['path'];
    directory = json['directory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['path'] = path;
    data['directory'] = directory;
    return data;
  }
}
