import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/model/Player.dart';
import 'package:passthecup/model/firebasegameObject.dart';
import 'package:passthecup/utils.dart';

class ResultScreen extends StatefulWidget {
  final FirebaseGameObject firebaseGameObject;

  final bool celibrate;

  ResultScreen(this.firebaseGameObject, {this.celibrate = true});

  @override
  _ResultScreenState createState() => _ResultScreenState(firebaseGameObject);
}

class _ResultScreenState extends State<ResultScreen> {
  FirebaseGameObject firebaseGameObject;

  _ResultScreenState(this.firebaseGameObject);

  String bgImage;
  ConfettiController _controllerBottomCenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchBackgroundImage();
    _controllerBottomCenter =
        ConfettiController(duration: const Duration(seconds: 10));

    Future.delayed(const Duration(milliseconds: 1500), () {
      _controllerBottomCenter.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Results"),
      ),
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _controllerBottomCenter.dispose();
    super.dispose();
  }

  Widget getBody() {
    if (widget.celibrate) {
      _controllerBottomCenter.play();
    }
    return Stack(
      children: <Widget>[
        Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.black,
            image: DecorationImage(
                image: getBackgroundImage(),
                fit: BoxFit.cover,
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.75), BlendMode.srcOver)),
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  getGameFinalCard(),
                  getPlayerWinCard(),
                  getAllPlayersScoreCard(),
                ],
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ConfettiWidget(
              confettiController: _controllerBottomCenter,
              numberOfParticles: 20,
              blastDirectionality: BlastDirectionality.explosive,
              // don't specify a direction, blast randomly
              shouldLoop: false,
              colors: const [
                Colors.redAccent,
                Colors.blueAccent,
                Colors.white
              ]),
        ),
      ],
    );
  }

  ImageProvider<dynamic> getBackgroundImage() {
    if (bgImage == null) {
      return AssetImage("assets/stadium.jpg");
    } else {
      return NetworkImage(bgImage);
    }
  }

  void fetchBackgroundImage() {
    FirebaseFirestore.instance
        .collection("images")
        .doc(firebaseGameObject.selectedGame.homeTeam)
        .get()
        .then((value) {
      var src = value.data()["link"];
      setState(() {
        bgImage = src;
      });
    }).catchError((e) {});
  }

  Container getGameFinalCard() {
    return Container(
      width: double.maxFinite,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Game Final",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              getPointsColumn(),
              SizedBox(
                height: 10,
              ),
//                    getBSOLive(),
            ],
          ),
        ),
      ),
    );
  }

  Container getPlayerWinCard() {
    return Container(
      width: double.maxFinite,
      child: Card(
        elevation: 3,
        color: Colors.greenAccent,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "${getWinningPlayerName()} Wins!!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container getAllPlayersScoreCard() {
    return Container(
      width: double.maxFinite,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Final Scores",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: getPlayersScores(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPointsColumn() {
    try {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    firebaseGameObject.selectedGame.awayTeam,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.redAccent),
                        child: Column(
                          children: <Widget>[
                            Text(
                              firebaseGameObject.selectedGame.awayTeamRuns
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Utils().getBlue()),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Final",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    )),
              ),
              Column(
                children: <Widget>[
                  Text(
                    firebaseGameObject.selectedGame.homeTeam,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.redAccent),
                        child: Column(
                          children: <Widget>[
                            Text(
                              firebaseGameObject.selectedGame.homeTeamRuns
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                  ),
                  /* Text(
                        "Balls",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white),
                      ),*/
                ],
              ),
            ],
          ),
        ],
      );
    } catch (e) {
      print(e);
      return Text(e.toString());
    }
  }

  Widget getBSOLive() {
    try {
      var ballsCount = firebaseGameObject.selectedGame.balls;
      if (ballsCount > 3) {
        ballsCount = 3;
      }
      var strikesCount = firebaseGameObject.selectedGame.strikes;
      if (strikesCount > 2) {
        strikesCount = 2;
      }
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          getDotView("BALL", ballsCount),
          SizedBox(
            width: 30,
          ),
          getDotView("STRIKE", strikesCount),
          SizedBox(
            width: 30,
          ),
          getDotView("OUT", firebaseGameObject.selectedGame.outs),
        ],
      );
    } catch (e) {
      print(e);
      return SizedBox();
    }
  }

  Column getDotView(String title, int count) {
    if (count == null) {
      count = 0;
    }
    String dots = "";
    for (int i = 0; i < count; i++) {
      dots = dots + "⚪ ";
    }
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          height: 0,
        ),
        Text(dots,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ],
    );
  }

  String getWinningPlayerName() {
    Player winner;
    int max = -10000;
    for (Player player in firebaseGameObject.players) {
      if (player.gamescore > max) {
        max = player.gamescore;
        winner = player;
      }
    }
    if (winner != null) {
      return winner.name;
    } else {
      return "null";
    }
  }

  List<Widget> getPlayersScores() {
    List<Widget> widgets = new List();
    List<Player> players = firebaseGameObject.players;

    players.sort((Player p1, Player p2) {
      if (p1.gamescore > p2.gamescore) {
        return -1;
      } else {
        return 1;
      }
    });

    for (Player player in players) {
      widgets.add(Padding(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16, right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              player.name,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              /*player.gamescore.toString()+', '+*/player.gamescore2.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            )
          ],
        ),
      ));
    }

    return widgets;
  }
}
