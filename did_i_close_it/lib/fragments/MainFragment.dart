import 'dart:async';
import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainFragment extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MainFragmentState();
  }
}

class _MainFragmentState extends State<MainFragment> {
  SharedPreferences prefs;
  bool _locked = false;
  String _rawNonceInput;

  Future<Null> _init() async{
    this.prefs =  await SharedPreferences.getInstance();
    bool lockState;
    if (prefs.getKeys().contains("DOOR_LOCKED_KEY"))
      lockState = prefs.getBool("DOOR_LOCKED_KEY");
    else
      lockState = false;

    setState(() {
      _locked = lockState;
        });
  }

  void _setLock() {
    setState(() {
      _locked = true;
    });
    prefs.setBool("DOOR_LOCKED_KEY", true);
  }

  void _setUnlock() {
    setState(() {
      _locked = false;
    });
    prefs.setBool("DOOR_LOCKED_KEY", false);
  }

  void _onNonceTextChange(String s) {
    _rawNonceInput = s;
  }

  Future<Null> _beSure() async {
    var generator = new Random();
    int nonce = generator.nextInt(1000);
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: new Text("Just to be sure..."),
            children: <Widget>[
              new Column(
                children: <Widget>[
                  new Padding(
                      padding: new EdgeInsets.all(8.0),
                      child: new TextField(
                        decoration: new InputDecoration(
                          labelText: 'Insert this random number: $nonce',
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (String s) {
                          _onNonceTextChange(s);
                        },
                      )),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        new RaisedButton(
                          child: new Text("Unlock it!"),
                          onPressed: () {
                            Navigator.of(context).pop(context);
                          },
                        )
                      ])
                ],
              )
            ],
          );
        });
    int input = int.tryParse(_rawNonceInput);
    print(input);
    if (input != null && input == nonce) {
      print("Unlocking");
      _setUnlock();
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          new Flexible(
            flex: 1,
            child: new Container(
              child: Center(
                  child: new Image.asset("assets/images/" +
                      (_locked ? "lock_closed.png" : "lock_open.png"))),
            ),
          ),
          new Flexible(
            flex: 1,
            child: new Container(
              child: new Center(
                  child: new MaterialButton(
                child: new Text(_locked ? "Unlock" : "Lock"),
                onPressed: () {
                  if (_locked)
                    _beSure();
                  else
                    _setLock();
                },
                height: 100.0,
                minWidth: 200.0,
                color: Colors.blue,
                splashColor: Colors.lightBlue,
              )),
            ),
          )
        ],
      ),
    );
  }
}
