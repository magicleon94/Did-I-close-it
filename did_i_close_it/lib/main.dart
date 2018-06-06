import 'package:flutter/material.dart';
import 'HomeScreen.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Did I lock it??',
      theme: new ThemeData(
          primarySwatch: Colors.blue, 
          backgroundColor: Colors.lightBlueAccent,
          primaryColor: Colors.blue,
          accentColor: Colors.lightBlue),
      home: new HomeScreen(),
    );
  }
}



