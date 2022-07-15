import 'package:http/http.dart';
import 'dart:convert';
import '../models/category.dart';
import '../models/pet.dart';

class ApiService {
  static var client = Client();
  static Future<List<Pet>> getAllpets() async {
    const String petsURL = 'https://petstore.swagger.io/v2/pet/';
    Map<String, String> requestHeaders = {'accept': 'application/json'};
    List<Pet> petsList = List.empty(growable: true);
    List<String> status = ["available", "pending", "sold"];
    for (int statusIndex = 0; statusIndex < 3; statusIndex++) {
      Response response = await get(
          Uri.parse('${petsURL}findByStatus?status=${status[statusIndex]}'));
      if (response.statusCode == 200) {
        List<dynamic> values = List.empty(growable: true);

        values = jsonDecode(response.body);
        if (values.isNotEmpty) {
          for (int i = 0; i < values.length; i++) {
            if (values[i] != null) {
              Map<String, dynamic> map = values[i];
              petsList.add(Pet.fromJson(map));
            }
          }
        }
      } else {
        throw Exception("error loading animals + ${jsonDecode(response.body)}");
      }
    }
    return petsList;
  }

  static Future<Pet> putPet(
    int petId,
    Category category,
    String name,
    List<String> photosUrl,
    List<dynamic> tags,
    String status,
  ) async {
    const String petsURL = 'https://petstore.swagger.io/v2/pet/';
    Map<String, String> requestHeaders = {'accept': 'application/json'};
    late Pet myPet;
    Response response = await put(
      Uri.parse(petsURL),
      headers: requestHeaders,
      body: jsonEncode(<String, dynamic>{
        "id": petId,
        "category": category.toJson(),
        "name": name,
        "photoUrls": photosUrl,
        "tags": tags,
        "status": status
      }),
    );
    if (response.statusCode == 200) {
      myPet = Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("error loading animals + ${jsonDecode(response.body)}");
    }

    return myPet;
  }

  static Future<Pet> postPet(Pet myPet) async {
    final response = await post(
      Uri.parse('https://petstore.swagger.io/v2/pet'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(myPet.toJson()),
    );

    if (response.statusCode == 201) {
      return Pet.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create album.');
    }
  }
}
