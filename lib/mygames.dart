import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/ongoinggames.dart';

class MyGamesScreen extends StatefulWidget {
  @override
  _MyGamesScreenState createState() => _MyGamesScreenState();
}


class _MyGamesScreenState extends State<MyGamesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



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
