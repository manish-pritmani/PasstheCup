import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;

  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();
    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getUser();
    setState(() {
      _enteredGameId = "";
    });
  }

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
    if (_enteredGameId.length == 6) {
      Navigator.of(context).push(new MaterialPageRoute<Lobby>(
        builder: (BuildContext context) {
          return new Lobby(_enteredGameId, true, user: user);
        },
      ));
    } else {
      Utils().showToast("Invalid Game ID, must be 6 characters", context);
    }
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
      body: user == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildContainer(context),
    );
  }

  Container buildContainer(BuildContext context) {
    return Container(
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
                          "Your Coins : 100",
                          style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )),
                  ],
                ),
                FadeAnimation(
                    1.4,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
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
                        image: AssetImage('assets/people.png'),
                        fit: BoxFit.cover)),
              ))
        ],
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
          onChanged: (value) {
            setState(() {
              _enteredGameId = value;
            });
          },
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}
