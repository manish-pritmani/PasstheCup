import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/gamelobby.dart';
import 'package:passthecup/model/gameObject.dart';
import 'package:passthecup/model/teamobject.dart';
import 'package:passthecup/teamselectscreen.dart';
import 'package:passthecup/utils.dart';

import 'gameselectscreen.dart';
import 'model/Player.dart';

class CreateGame extends StatefulWidget {
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;

  TeamObject _currenteam;

  GameObject _currengame;

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
    super.initState();
    this.getUser();

    setState(() {
      _currenteam = null;
      _currengame = null;
    });
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
            : buildSingleChildScrollView(context));
  }

  SingleChildScrollView buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
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
                      FadeAnimation(
                          1,
                          Text(
                            "Create New Game",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.w500),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                                1.2,
                                makeInput(
                                    enabled: false,
                                    value: _currenteam == null
                                        ? "No Team Selected"
                                        : _currenteam.name,
                                    label: "Select Team",
                                    onPress: () {
                                      openTeamSelectScreen(context);
                                    })),
                            OutlineButton(
                                child: Text("Select a Team"),
                                onPressed: () => openTeamSelectScreen(context))
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          children: <Widget>[
                            FadeAnimation(
                                1.2,
                                makeInput(
                                    value: _currengame == null
                                        ? "No Game Selected"
                                        : _currengame.awayTeam +
                                            " vs. " +
                                            _currengame.homeTeam,
                                    onPress: () {
                                      openGameSelectscreen(context);
                                    },
                                    enabled: false,
                                    label: "Select Game")),
                            OutlineButton(
                                child: Text("Select a Game"),
                                onPressed: () => openGameSelectscreen(context))
                          ],
                        ),
                      ),
                    ],
                  ),
                  FadeAnimation(
                      1.4,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            if (_currenteam != null && _currengame != null) {
                              createGameAndEnter(context);
                            } else {
                              Utils().showToast(
                                  "Select Team and Game before creating game",
                                  context);
                            }
                          },
                          color: Colors.redAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Create New Game",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
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
      ),
    );
  }

  void createGameAndEnter(BuildContext context) {
    List<Map<String, dynamic>> players = List();
    var player = Player(
        name: user.displayName, email: user.email, gamescore: -5, host: true);
    players.add(player.toJson());
    player.host = false;
    players.add(player.toJson());
    String gameID = generateGameID();
    var map = {
      "selectedGame": _currengame.toJson(),
      "selectedTeam": _currenteam.toJson(),
      "name": user.displayName,
      "hostID": user.email,
      "joinPlayers": 0,
      "creatorId": user.uid,
      "status": 0,
      "gameCode": gameID,
      "createdOn": DateTime.now().toString(),
      "players": players,
      "simulation": false,
      "lastResult": "",
      "lastResultPointsAwarded": 0,
      "currentHitter": "",
      "currentPitcher": "",
      "currentHitterID": 0,
      "currentPitcherID":0,
      "currentInningNumber": 0,
      "currentInningHalf": "T",
      "currentActivePlayer": 0,
      "cupScore":0,
      "lastUpdatedAt":""
    };
    Firestore.instance
        .collection("games")
        .document(gameID)
        .setData(map)
        .then((_) {
      print("Game Created Successfully!");
      Navigator.of(context).push(new MaterialPageRoute<TeamObject>(
        builder: (BuildContext context) {
          return new Lobby(gameID, false);
        },
      ));
    });
  }

  void openTeamSelectScreen(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<TeamObject>(
      builder: (BuildContext context) {
        return new TeamSelectScreen();
      },
    )).then((value) {
      setState(() {
        _currenteam = value;
      });
      return null;
    });
  }

  String generateGameID() {
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    return code.toString();
  }

  //Todo : Take create game inputs
  Widget makeInput(
      {label,
      obscureText = false,
      Null Function() onPress,
      String value = "",
      bool enabled = true}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: onPress,
          child: TextField(
            controller: new TextEditingController(text: value),
            enabled: enabled,
            obscureText: obscureText,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400])),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400])),
            ),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  void openGameSelectscreen(BuildContext context) {
    Navigator.of(context).push(new MaterialPageRoute<GameObject>(
      builder: (BuildContext context) {
        return new GameSelectScreen(currenteam: _currenteam);
      },
    )).then((value) {
      setState(() {
        _currengame = value;
      });
      return null;
    });
  }
}
