import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/ongoinggames.dart';

class MyGamesScreen extends StatefulWidget {
  @override
  _MyGamesScreenState createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Games"),
          bottom: TabBar(
            tabs: [
              new Tab(
                text: "Active",
              ),
              new Tab(
                text: "Scheduled",
              ),
              new Tab(
                text: "Complete",
              ),
            ],
            controller: _tabController,
          ),
        ),
        body: TabBarView(
          children: [OnGoingGames("InProgress"), OnGoingGames("Scheduled"), OnGoingGames("Final")],
          controller: _tabController,
        ),
      ),
    );
  }
}
