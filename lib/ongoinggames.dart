import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OnGoingGames extends StatefulWidget {
  @override
  _OnGoingGamesState createState() => _OnGoingGamesState();
}

class _OnGoingGamesState extends State<OnGoingGames> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGames();
  }

  Future<QuerySnapshot> fetchGames() async {
//    var documents = await Firestore.instance.collection("players").where("players", arrayContains: user).getDocuments();
//    return documents;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
