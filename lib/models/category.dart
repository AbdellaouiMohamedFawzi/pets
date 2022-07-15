class Category {
  int? id;
  String? name;

  Category({required this.id, required this.name});

  Category.fromJson(Map<String, dynamic> data) {
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
