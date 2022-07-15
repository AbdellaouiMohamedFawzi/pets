import 'package:flutter/material.dart';
import 'package:pets/service/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pets/ui/all_pets.dart';

import '../models/category.dart';
import '../models/pet.dart';
import '../models/tag.dart';

class AddPet extends StatefulWidget {
  AddPet({Key? key}) : super(key: key);

  @override
  State<AddPet> createState() => _AddPetState();
  static String id = "AddPet";
}

class _AddPetState extends State<AddPet> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  String dropDownVal = "available";
  String? tagName, petName, categoryName;
  List<String> urls = List.empty(growable: true);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late List<XFile>? selectedImages;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            title: Text(
              "Add new pet ",
              style: const TextStyle(color: Colors.black),
            ),
            //centerTitle: true,
            elevation: 0,
          ),
          body: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: screenSize.height * .4,
                    width: screenSize.width,
                    color: Colors.red,
                    margin: EdgeInsets.all(screenSize.width * .05),
                    child: Stack(
                      children: [
                        selectedImages != null
                            ? Image.file(File(selectedImages![0].path))
                            : Container(),
                        IconButton(
                            onPressed: () async {
                              selectedImages = await imgpicker.pickMultiImage();

                              setState(() {
                                if (selectedImages!.isNotEmpty) {
                                  imagefiles!.addAll(selectedImages!);
                                  for (int i = 0;
                                      i < selectedImages!.length;
                                      i++) {
                                    urls.add(selectedImages![i].path);
                                  }
                                }
                              });
                            },
                            icon: const Icon(Icons.edit))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * .15),
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Pet name",
                        labelStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      onSaved: (value) {
                        petName = value;
                      },
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * .01,
                  ),
                  Column(
                    children: [
                      const Text(
                        "Pet Category ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * .05,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * .15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Category name",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          onSaved: (value) {
                            categoryName = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: screenSize.height * .05,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Text(
                        "Pet Tag ",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                        ),
                      ),
                      SizedBox(
                        height: screenSize.height * .01,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenSize.width * .15),
                        child: TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Tag name",
                            labelStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 25,
                            ),
                          ),
                          onSaved: (value) {
                            tagName = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  DropdownButton<String>(
                      value: dropDownVal,
                      items: const [
                        DropdownMenuItem(
                          value: "available",
                          child: Text("available"),
                        ),
                        DropdownMenuItem(value: "sold", child: Text("sold")),
                        DropdownMenuItem(
                          value: "pending",
                          child: Text(
                            "pending",
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          dropDownVal = value!;
                        });
                      }),
                  ElevatedButton(
                      onPressed: () async {
                        formKey.currentState!.save();
                        Pet newPet = Pet(
                            id: 58547844,
                            category: Category.fromJson(
                                {"id": 4585, "name": categoryName}),
                            name: petName,
                            tags: [
                              Tag.fromJson({"id": 584785, "name": tagName})
                            ],
                            photosUrl: urls,
                            status: dropDownVal);
                        ApiService.postPet(newPet);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const AllPets();
                        }));
                      },
                      child: const Text("Save"))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
