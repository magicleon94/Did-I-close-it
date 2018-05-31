import 'package:flutter/material.dart';
import 'package:did_i_close_it/fragments/MainFragment.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _HomeScreenState createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    int _selectedDrawerIndex = 0;

    _getDrawerItemWidget(int pos) {
      switch (pos) {
        case 0:
        
          return new MainFragment();
        default:
          return new Text("Error");
      }
    }

    // _onSelectItem(int index){
    //   setState(() {
    //           _selectedDrawerIndex = index;
    //         });
    //   Navigator.of(context).pop();
    // }

    @override
    Widget build(BuildContext context){
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Did I close it?"),
          ),
          // drawer: new Drawer(
          //   child: new ListView(
          //     children: <Widget>[
          //           new ListTile(
          //             title: new Text("Item 1"),
          //             selected: 0 == _selectedDrawerIndex,
          //             onTap: () => _onSelectItem(0),
          //           ),
          //           new ListTile(
          //             title: new Text("Righizitto"),
          //             selected: 1 == _selectedDrawerIndex,
          //             onTap: () => _onSelectItem(1),
          //           )
          //         ]
          //       ),
          // ),
          body: _getDrawerItemWidget(_selectedDrawerIndex),
        );
        }
}
              
