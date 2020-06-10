import 'package:flutter/material.dart';
import 'package:merosathi/ui/constants.dart';
import 'package:merosathi/ui/pages/matches.dart';
import 'package:merosathi/ui/pages/messages.dart';
import 'package:merosathi/ui/pages/search.dart';

class Tabs extends StatelessWidget {

  List<Widget> pages = [
    Search(),
    Matches(),
    Messages(),
  ];
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        primaryColor: backgroundColor,
        accentColor: Colors.white,
      ),
      child: DefaultTabController(length: 3,
      
       child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("MeroSathi", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            actions: <Widget>[
              IconButton(icon: Icon(Icons.exit_to_app),
              onPressed: null)
            ],
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(48), 
              child: Container(
                height: 48,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TabBar(
                        tabs: <Widget>[
                          Tab(icon: Icon(Icons.search),),
                          Tab(icon: Icon(Icons.people),),
                          Tab(icon: Icon(Icons.message),),
                        ],
                    ),
                  ],
                ),
              ),),
          ),
          body: TabBarView(
            children: pages),
       )),
    );
  }
}