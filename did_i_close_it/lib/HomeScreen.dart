import 'package:flutter/material.dart';
import 'TwoPanels.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  void initState() {
    super.initState();
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
        body: new GestureDetector(
            onVerticalDragEnd: (details) {
              if (details.primaryVelocity == 0) return;
              controller.fling(
                  velocity: details.primaryVelocity > 0 ? -1.0 : 1.0);
            },
            child: TwoPanels(
              controller: this.controller,
            )));
  }
}
