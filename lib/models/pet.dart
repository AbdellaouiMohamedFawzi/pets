import 'package:pets/models/tag.dart';

import 'category.dart';

class Pet {
  int? id;
  Category? category;
  String? name;
  List<String>? photosUrl;
  List<dynamic>? tags;
  String? status;

  Pet(
      {required this.id,
      required this.category,
      required this.name,
      required this.tags,
      required this.photosUrl,
      required this.status});

  Pet.fromJson(Map<String, dynamic> data) {
    id = data["id"];
    category =
        Category.fromJson(data["category"] ?? {"id": 404, "name": "not found"});
    name = data["name"];
    tags = data["tags"];
    photosUrl = data["photosUrls"];
    status = data["status"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["category"] = category;
    data["name"] = name;
    data["photosUrls"] = photosUrl;
    data["tags"] = tags;
    data["status"] = status;
    return data;
  }
}
