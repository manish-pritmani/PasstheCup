import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/utils.dart';

import 'gamelobby.dart';

class GameId extends StatefulWidget {
  @override
  _GameIdState createState() => _GameIdState();
}

class _GameIdState extends State<GameId> {
  //Todo : Capture Game Id in this string
  String _enteredGameId = '';

  //Todo : Query firestore for the game.
  void _searchGame() async {
//    var result = await Firestore.instance
//        .collection("games")
//        .where("creatorId", isEqualTo: _enteredGameId)
//        .where("joinPlayers", isLessThan: 4)
//        .getDocuments();
//    result.documents.forEach((result) {
//      print(result.data);
//    });
    Navigator.of(context).push(new MaterialPageRoute<Lobby>(
      builder: (BuildContext context) {
        return new Lobby();
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Utils().getBGColor(),
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Utils().getBGColor(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: Container(
        color: Utils().getBGColor(),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: FadeAnimation(
                            1,
                            Text(
                              "Enter Game-Code to Join",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w500),
                            )),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(1.2, makeInput(label: "Game Code")),
                          ],
                        ),
                      ),
                      FadeAnimation(
                          1.2,
                          Text(
                            "Your Coins : 250",
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          )),
                    ],
                  ),
                  FadeAnimation(
                      1.4,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                          padding: EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: _searchGame,
                            color: Colors.redAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: Text(
                              "Enter Game",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            FadeAnimation(
                1.2,
                Container(
                  height: MediaQuery.of(context).size.height / 2.9,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/homerun4_blue.png'),
                          fit: BoxFit.cover)),
                ))
          ],
        ),
      ),
    );
  }

  //Todo : Capture Game Id input from this class only
  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black87),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
          validator: (value) {
            return value.isEmpty ? 'Please provide correct game id.' : null;
          },
          onSaved: (value) {
            return _enteredGameId = value;
          },
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
