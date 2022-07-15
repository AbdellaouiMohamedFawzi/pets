import 'package:flutter/material.dart';
import 'package:pets/service/api_service.dart';
import 'package:pets/ui/add_new_pet.dart';
import 'package:pets/ui/edit_pet.dart';

import '../models/pet.dart';

class AllPets extends StatefulWidget {
  const AllPets({Key? key}) : super(key: key);

  @override
  State<AllPets> createState() => _AllPetsState();
  static String id = "AllPets";
}

class _AllPetsState extends State<AllPets> {
  int selected = 0;
  late Future<List<Pet>> futurePet;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futurePet = ApiService.getAllpets();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
              ),
            ),
            title: const Text(
              "all pets",
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return AddPet();
                    }));
                  },
                  icon: const Icon(Icons.add))
            ],
          ),
          body: ListView(
            shrinkWrap: true,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenSize.height * .05,
                  ),
                  const Text(
                    "   Search for pet",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * .02,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * .1,
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "search for a pet",
                        suffixIcon: Icon(Icons.settings),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: screenSize.height * .02,
              ),
              FutureBuilder<List<Pet>>(
                future: futurePet,
                builder: (context, snapshot) {
                  late Widget returnedWidget;
                  if (snapshot.hasData) {
                    returnedWidget = ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, i) {
                          return ListTile(
                            leading: snapshot.data![i].photosUrl != null
                                ? SizedBox(
                                    width: screenSize.width * .2,
                                    height: double.maxFinite,
                                    child: Image.network(
                                        snapshot.data![i].photosUrl![0]))
                                : SizedBox(
                                    width: screenSize.width * .2,
                                    height: double.maxFinite,
                                  ),
                            title: Text(
                              snapshot.data![i].name != null
                                  ? snapshot.data![i].name!
                                  : "null value found",
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                              ),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditPet(pet: snapshot.data![i]);
                                }));
                              },
                            ),
                          );
                        });
                  } else if (snapshot.hasError) {
                    returnedWidget = Text('${snapshot.error}');
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    returnedWidget = const CircularProgressIndicator();
                  }
                  return returnedWidget;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
