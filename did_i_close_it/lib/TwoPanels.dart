import 'package:flutter/material.dart';
import 'package:did_i_close_it/fragments/DoorLocked.dart';
import 'package:did_i_close_it/fragments/GasLocked.dart';

class TwoPanels extends StatefulWidget {
  final AnimationController controller;
  TwoPanels({this.controller});

  @override
  _TwoPanelState createState() => new _TwoPanelState();
}

class _TwoPanelState extends State<TwoPanels> {
  static const header_height = 32.0;

  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new DoorLocked();
      case 1:
        return new GasLocked();
      default:
        return new Text("Error");
    }
  }

  _onSelectDrawerItemWidget(int pos){
    setState((){
      print("Setting state to: " + pos.toString());
      _selectedDrawerIndex = pos;
    });
  }

  Animation<RelativeRect> getPanelAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return new RelativeRectTween(
            begin: new RelativeRect.fromLTRB(
                0.0, backPanelHeight, 0.0, frontPanelHeight),
            end: new RelativeRect.fromLTRB(0.0, 0.0, 0.0, 0.0))
        .animate(new CurvedAnimation(
            parent: widget.controller, curve: Curves.linear));
  }

  Widget bothPanels(BuildContext context, BoxConstraints constraints) {
    return new Container(
      child: new Stack(
        children: <Widget>[
          _getDrawerItemWidget(_selectedDrawerIndex),
          new PositionedTransition(
            rect: getPanelAnimation(constraints),
            child: new Material(
              elevation: 12.0,
              borderRadius: new BorderRadius.only(
                topLeft: new Radius.circular(32.0),
                topRight: new Radius.circular(32.0),
              ),
              child: new Container(
                  child: new Column(
                children: <Widget>[
                  new GestureDetector(
                    onTap: (){widget.controller.fling(velocity: 1.0)},
                      child: new Container(
                      height: header_height,
                      child: new Center(
                        child: new Text("Menu"),
                      ),
                    ),
                  ),
                  new Expanded(
                    child: new Container(
                      child: new ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          new ListTile(
                            title: new Text("Did I lock the door?"),
                            leading: new Icon(
                              Icons.lock
                            ),
                            onTap: (){
                              _onSelectDrawerItemWidget(0);
                              widget.controller.fling(velocity: -1.0);
                            },
                          ),
                          new ListTile(
                            title: new Text("Did I close the gas?"),
                            leading: new Icon(
                              Icons.local_gas_station
                            ),
                            onTap: (){
                              _onSelectDrawerItemWidget(1);
                              widget.controller.fling(velocity: -1.0);
                            },
                          )
                        ],
                      )
                    ),
                  )
                ],
              )),
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
