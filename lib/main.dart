import 'package:flutter/material.dart';
import 'package:pets/ui/all_pets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      initialRoute: AllPets.id,
      routes: {AllPets.id: (context) => AllPets()},
    );
  }
}
