class FileItem {
  List<FileData> objects = List.empty();
  String parent = '';

  FileItem();

  FileItem.fromJson(Map<String, dynamic> json) {
    if (json['objects'] != null) {
      objects = List<FileData>.empty(growable: true);
      json['objects'].forEach((v) {
        objects.add(FileData.fromJson(v));
      });
    }
    parent = json['parent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['objects'] = this.objects.map((v) => v.toJson()).toList();
    data['parent'] = this.parent;
    return data;
  }
}

class FileData {
  String id = '';
  String name = '';
  String path = '';
  String pic = '';
  int size = 0;
  String type = '';
  String date = '';

  FileData();

  FileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    path = json['path'];
    pic = json['pic'];
    size = json['size'];
    type = json['type'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['path'] = this.path;
    data['pic'] = this.pic;
    data['size'] = this.size;
    data['type'] = this.type;
    data['date'] = this.date;
    return data;
  }
}
