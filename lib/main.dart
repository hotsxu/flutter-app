import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/net/api.dart';
import 'package:http/http.dart';

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile();
                },
              ),
              onRefresh: _onRefresh,
            ),
            Icon(Icons.map),
            Icon(Icons.alarm),
          ]),
        ));
  }

  loadData() async {
    Response response = await Api.get(null);
    String json = response.body;
    print(json);
  }
}
