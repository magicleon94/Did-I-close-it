import 'package:flutter/material.dart';
import 'package:did_i_close_it/fragments/DoorLocked.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TwoPanels extends StatefulWidget {
  final AnimationController controller;
  final SharedPreferences prefs;

  TwoPanels({this.controller, this.prefs});

  @override
  _TwoPanelState createState() => new _TwoPanelState();
}

class _TwoPanelState extends State<TwoPanels> {
  static const header_height = 32.0;
  bool _switchValue;
  int _selectedDrawerIndex = 0;

  bool get isFrontPanelVisible {
    final AnimationStatus status = widget.controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  @override
  void initState() {
    super.initState();
    if (widget.prefs.getKeys().contains("ASK_NUMBER_ON_UNLOCK")) {
      _switchValue = widget.prefs.getBool("ASK_NUMBER_ON_UNLOCK");
    } else {
      _switchValue = false;
      widget.prefs.setBool("ASK_NUMBER_ON_UNLOCK", false);
    }
  }

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DoorLocked(prefs: widget.prefs);
      default:
        return new Text("Error");
    }
  }

/*   _onSelectDrawerItemWidget(int pos) {
    setState(() {
      _selectedDrawerIndex = pos;
      widget.onChanged(appBarColor);
    });
  } */

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return new RelativeRectTween(
            begin: new RelativeRect.fromLTRB(
                0.0, backPanelHeight, 0.0, frontPanelHeight),
            end: new RelativeRect.fromLTRB(0.0, height/1.5, 0.0, 0.0))
        .animate(new CurvedAnimation(
            parent: widget.controller, curve: Curves.linear));
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Stack(
        children: <Widget>[
          _getDrawerItemWidget(_selectedDrawerIndex),
          new PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: new GestureDetector(
              onVerticalDragEnd: (details) {
                if (details.primaryVelocity == 0) return;

                widget.controller
                    .fling(velocity: details.primaryVelocity > 0 ? -1.0 : 1.0);
              },
              child: new Material(
                elevation: 12.0,
                borderRadius: new BorderRadius.only(
                  topLeft: new Radius.circular(42.0),
                  topRight: new Radius.circular(42.0),
                ),
                child: new Container(
                    child: new Column(
                  children: <Widget>[
                    new Container(
                      height: header_height,
                      child: new Center(
                        child: new Text("Menu"),
                      ),
                    ),
                    new Container(
                        child: new Column(
                      children: <Widget>[
                        new SwitchListTile(
                          value: _switchValue,
                          title: new Text("Number check for unlock"),
                          onChanged: (newValue) {
                            widget.prefs.setBool("ASK_NUMBER_ON_UNLOCK", newValue);
                            setState(() {
                              _switchValue = newValue;
                            });
                          },
                        ),
                      ],
                    )),
                  ],
                )),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new LayoutBuilder(
      builder: bothPanels,
    );
  }
}
