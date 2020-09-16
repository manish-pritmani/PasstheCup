import 'package:flutter/material.dart';
import 'package:passthecup/ongoinggames.dart';

class MyGamesScreen extends StatefulWidget {
  @override
  _MyGamesScreenState createState() => _MyGamesScreenState();
}

class _MyGamesScreenState extends State<MyGamesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Games"),
      ),
      body: OnGoingGames(),
    );
  }
}
