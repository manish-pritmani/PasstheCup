import 'package:flutter/material.dart';
import 'package:passthecup/ProfilePage.dart';
import 'package:passthecup/StatsPage.dart';

import 'ongoinggames.dart';

class ProfileStatsPage extends StatefulWidget {
  final int page;

  ProfileStatsPage({this.page = 0});

  @override
  _ProfileStatsPageState createState() => _ProfileStatsPageState();
}

class _ProfileStatsPageState extends State<ProfileStatsPage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController =
        new TabController(length: 2, vsync: this, initialIndex: widget.page);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Profile & Stats"),
            bottom: TabBar(
              tabs: [
                new Tab(
                  text: "My Profile",
                ),
                new Tab(
                  text: "Stats",
                ),
              ],
              controller: _tabController,
            ),
          ),
          body: TabBarView(
            children: [
              ProfilePage(),
              StatsPage(),
            ],
            controller: _tabController,
          ),
        ));
  }
}
