import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/net/api.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'UNSPLASH'),
    );
  }
}

final String _latest = "latest";
final String _oldest = "oldest";
final String _popular = "popular";

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> _latestGrid = [];
  List<Widget> _oldestGrid = [];
  List<Widget> _popularGrid = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<Null> _onRefresh() async {
    await Future.delayed(Duration(seconds: 5), () {});
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
        length: 3,
        child: new Scaffold(
          appBar: new AppBar(
            title: Text(widget.title),
            actions: <Widget>[
              IconButton(
                icon: Text("Test"),
                onPressed: () {
                  loadData();
                },
              )
            ],
            bottom: new TabBar(tabs: [
              Tab(text: "LASTEXT"),
              Tab(text: "OLDEST"),
              Tab(text: "POPULAR"),
            ]),
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                DrawerHeader(
                  child: new Container(
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.bottomLeft,
                    child: Text("Half of the soul"),
                  ),
                ),
                new ListTile(
                  leading: Icon(Icons.alarm),
                  title: Text("alarm"),
                ),
                new ListTile(
                  leading: Icon(Icons.map),
                  title: Text("map"),
                ),
                new ListTile(
                  leading: Icon(Icons.print),
                  title: Text("print"),
                ),
              ],
            ),
          ),
          body: new TabBarView(children: [
            new RefreshIndicator(
              child: SingleChildScrollView(
                child: Flow(
                  delegate: _MyFlowDelegate(),
                  children: _latestGrid,
                ),
              ),
              onRefresh: _onRefresh,
            ),
            Icon(Icons.map),
            Icon(Icons.alarm),
          ]),
        ));
  }

  loadData() async {
    List jsonObj = await Api.get(map: {"order_by": _latest});
    print(jsonObj);
    List images = jsonObj.map((json) {
      return json["urls"]["thumb"];
    }).toList();
    setState(() {
      if (images.isEmpty) {
        return;
      } else {
        _latestGrid = images.map((image) {
          return Image.network(
            image,
            width: context.size.width / 2.0,
          );
        }).toList();
      }
    });
  }
}

class _MyFlowDelegate extends FlowDelegate {
  final padding = 0.0;

  @override
  void paintChildren(FlowPaintingContext context) {
    var tempWidth = 0.0;
    var tempLeftHeight = 0.0;
    var tempRightHeight = 0.0;
    var half = context.size.width / 2;
    for (int i = 0; i < context.childCount; i++) {
      if (i % 2 == 0) {
        tempWidth = 0.0;
        context.paintChild(i,
            transform: new Matrix4.translationValues(
                tempWidth + padding, tempLeftHeight, 0.0));
        tempLeftHeight += context.getChildSize(i).height;
      } else {
        tempWidth = half;
        context.paintChild(i,
            transform: new Matrix4.translationValues(
                tempWidth + padding, tempRightHeight, 0.0));
        tempRightHeight += context.getChildSize(i).height;
      }
    }
  }

  @override
  bool shouldRepaint(FlowDelegate oldDelegate) {
    return oldDelegate != this;
  }

  @override
  BoxConstraints getConstraintsForChild(int i, BoxConstraints constraints) {
    BoxConstraints boxConstraints = new BoxConstraints(
        maxHeight: constraints.maxHeight, maxWidth: constraints.maxWidth);
    return boxConstraints;
  }
}
