class Tag {
  int? id;
  String? name;
   Tag.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    name = data["name"];
  }

  toJson(){
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    return data;
  }
}
