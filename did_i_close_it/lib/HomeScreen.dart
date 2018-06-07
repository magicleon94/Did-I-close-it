import 'dart:async';

import 'package:flutter/material.dart';
import 'TwoPanels.dart';
import 'SplashScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  SharedPreferences prefs;
    bool ready = false;

  Future<Null> _getPrefs() async{
    print("Getting Prefs...");
    this.prefs = await SharedPreferences.getInstance();
        print("Got prefs");
    setState(() {
          this.ready = true;
        });
  }

  @override
  void initState() {
    super.initState();
    _getPrefs();
    controller = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 200), value: 0.0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (ready){
      return new Scaffold(
          resizeToAvoidBottomPadding: false,
          body: TwoPanels(
                controller: this.controller,
                prefs: this.prefs,
              )
      );
    }else{
      return new SplashScreen();
    }
  }
}
