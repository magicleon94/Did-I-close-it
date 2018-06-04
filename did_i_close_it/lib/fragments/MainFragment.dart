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
  final _formKey = new GlobalKey<FormState>();

  Future<Null> _init() async {
    this.prefs = await SharedPreferences.getInstance();
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

  void _submitNonce(s) {
    if (_formKey.currentState.validate()) {
      Navigator.of(context).pop(context);
      _setUnlock();
    }
  }

  Future<Null> _beSure() async {
    var generator = new Random();
    int nonce = generator.nextInt(10000);

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
              title: new Text("Just to be sure..."),
              children: <Widget>[
                new Container(
                    width: 300.0,
                    height: 200.0,
                    child: new Padding(
                        padding: new EdgeInsets.all(16.0),
                        child: new Form(
                            key: _formKey,
                            child: new Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new TextFormField(
                                    decoration: new InputDecoration(
                                      labelText:
                                          'Insert this random number: $nonce',
                                      labelStyle:
                                          new TextStyle(color: Colors.black),
                                    ),
                                    keyboardType: TextInputType.number,
                                    onFieldSubmitted: (s) => _submitNonce(s),
                                    validator: (value) {
                                      print(value);
                                      if (value.isEmpty ||
                                          value != nonce.toString()) {
                                        return 'Incorrect value';
                                      }
                                    },
                                  ),
                                  new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        new RaisedButton(
                                          child: new Text("Unlock it!"),
                                          color: Theme.of(context).accentColor,
                                          textColor: Colors.white,
                                          onPressed: () {
                                            _submitNonce("");
                                          },
                                        )
                                      ])
                                ]))))
              ]);
        });
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
        verticalDirection: VerticalDirection.down,
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
                textColor: Colors.white,
                splashColor: Colors.lightBlue,
              )),
            ),
          )
        ],
      ),
    );
  }
}
