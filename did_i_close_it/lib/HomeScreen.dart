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
 bool get isFrontPanelVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }
  @override
  Widget build(BuildContext context) {
    if (ready){
      return new Scaffold(
          resizeToAvoidBottomPadding: false,
          appBar: new AppBar(
            title: new Text("Did I close it?"),
            elevation: 0.0,
            leading: new IconButton(
              onPressed: () {
                controller.fling(velocity: isFrontPanelVisible ? -1.0 : 1.0);
              },
              icon: new AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                progress: controller.view,
              ),
            ),
          ),
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
