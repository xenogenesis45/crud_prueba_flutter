import 'package:flutter/material.dart';
import 'package:prueba_crud/pages/datos_prueba.dart';

void main() {
  runApp(MyApp());
}

const darkBlueColor = Color(0xff486579);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact App',
      theme: ThemeData(
        primaryColor: darkBlueColor,
      ),
      initialRoute: 'home',
      routes: {'home': (BuildContext context) => MyPages()},
    );
  }
}
