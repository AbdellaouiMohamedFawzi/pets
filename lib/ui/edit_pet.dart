import 'package:flutter/material.dart';
import 'package:pets/service/api_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pets/ui/all_pets.dart';

import '../models/category.dart';
import '../models/pet.dart';
import '../models/tag.dart';

class EditPet extends StatefulWidget {
  Pet pet;
  EditPet({Key? key, required this.pet}) : super(key: key);

  @override
  State<EditPet> createState() => _EditPetState();
  static String id = "editPet";
}

class _EditPetState extends State<EditPet> {
  final ImagePicker imgpicker = ImagePicker();
  List<XFile>? imagefiles;
  late String dropDownVal;
  String? tagName, petName, categoryName;
  List<String> urls = List.empty(growable: true);
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dropDownVal = widget.pet.status!;
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
              "edit ${widget.pet.name!}",
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
                        widget.pet.photosUrl != null
                            ? Image.network(widget.pet.photosUrl![0])
                            : const Center(
                                child: Text(
                                  "This message appears because the current pet url photos in database is null",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                        IconButton(
                            onPressed: () async {
                              final List<XFile>? selectedImages =
                                  await imgpicker.pickMultiImage();
                              if (selectedImages!.isNotEmpty) {
                                imagefiles!.addAll(selectedImages);
                                for (int i = 0;
                                    i < selectedImages.length;
                                    i++) {
                                  urls.add(selectedImages[i].path);
                                }
                              }
                            },
                            icon: const Icon(Icons.edit))
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenSize.width * .15),
                    child: TextFormField(
                      initialValue: widget.pet.name,
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
                          initialValue: widget.pet.category!.name,
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
                          initialValue: widget.pet.tags![0]["name"],
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
                        widget.pet = await ApiService.putPet(
                            widget.pet.id!,
                            Category.fromJson({
                              "name": categoryName,
                              "id": widget.pet.category!.id
                            }),
                            petName!,
                            urls,
                            [
                              Tag.fromJson({
                                "id": widget.pet.tags![0]["id"],
                                "name": tagName
                              })
                            ],
                            dropDownVal);
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
