import 'package:flutter/material.dart';
import 'package:VegNSnap/cameraPage.dart';
import 'package:VegNSnap/ProfilePage.dart';
import 'package:flutter/services.dart';

void main(){
  runApp(Home());
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print("App started");
    SystemChrome.setEnabledSystemUIOverlays([]);
    return new MaterialApp(
      color: Colors.yellow,
      home: DefaultTabController(
        length: 2,
        child: new Scaffold(
          body: TabBarView(
            children: [
              FlutterVisionApp(),
              Profile(),
            ],
          ),
          bottomNavigationBar: new TabBar(
            tabs: [
              Tab(
                icon: new Icon(Icons.home),
              ),
              Tab(
                icon: new Icon(Icons.perm_identity),
              ),
            ],
            labelColor: Colors.blue[300],
            unselectedLabelColor: Colors.grey,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.all(5.0),
            indicatorColor: Colors.red[300],
          ),
          backgroundColor: Colors.black,
        ),
      ),
    );
  }
}
