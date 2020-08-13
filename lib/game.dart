import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:passthecup/model/firebasegameObject.dart';
import 'package:passthecup/model/gameObjectPlaybyPlay.dart';
import 'package:passthecup/utils.dart';
import 'package:sa_stateless_animation/sa_stateless_animation.dart';

import 'api.dart';
import 'model/Player.dart';

class inGame extends StatefulWidget {
  FirebaseGameObject firebaseGameObject;

  bool simulation;

  inGame(this.firebaseGameObject, {this.simulation});

  @override
  State<StatefulWidget> createState() =>
      _inGameState(firebaseGameObject, simulation);
}

class _inGameState extends State<inGame>
    with PortraitStatefulModeMixin<inGame> {
  GameObjectPlayByPlay gameObjectPlayByPlay;
  FirebaseGameObject firebaseGameObject;
  bool fetching;

  Timer timer;

  Color borderColor;

  int activePlayer = 0;
  int currentPlay = 0;
  int currentPitch = 0;
  int currentInnings = 0;
  bool simulation;

//  List<Player> players = List();

  bool sim;
  bool gameOver;

  bool dialogShown;

  int cupScore;

  String displaymsg;

  int lastScoreUpdatedinPlay;

  int homeTeamRuns;

  int awayTeamRuns;

  _inGameState(this.firebaseGameObject, this.sim);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    if (sim == null) {
      sim = false;
    }
    setState(() {
      currentPitch = 0;
      currentPlay = 0;
      currentInnings = 0;
      simulation = sim;
      activePlayer = 0;
      gameOver = false;
      cupScore = firebaseGameObject.cupScore;
      displaymsg = "";
      lastScoreUpdatedinPlay = -1;
      homeTeamRuns = 0;
      awayTeamRuns = 0;
    });

    borderColor = Colors.transparent;

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      simulation ? onGameFetched(gameObjectPlayByPlay) : fetchGameDetails();
    });
    fetchGameDetails();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    timer?.cancel();
    super.dispose();
  }

  void fetchGameDetails() {
    setState(() {
      fetching = true;
    });
    API()
        .fetchGamePlayByPlay(firebaseGameObject.selectedGame.gameID.toString())
        .then((value) {
      onGameFetched(value);
      return null;
    }).catchError((onError) {
      setState(() {
        fetching = false;
      });
    });
  }

  void onGameFetched(GameObjectPlayByPlay value) {
    if (gameOver) {
      if (!dialogShown) {
        Utils().showToast("Game Over", context);
        setState(() {
          dialogShown = true;
        });
      }
      return;
    }

    if (value == null) {
      print("Null Game Object");
      return;
    }
    setState(() {
      gameObjectPlayByPlay = value;
      fetching = false;
      List<Plays> plays = gameObjectPlayByPlay.plays;

      //check if there are plays available or not
      if (plays.length > 0) {
        var latestPlay = plays[plays.length - 1];

        if (!simulation) {
          currentPlay = plays.length - 1;
          currentInnings = latestPlay.inningNumber - 1;
          currentPitch = latestPlay.pitches.length - 1;
        } else {
          var sizeOfPitchesInCurrentPlay = plays[currentPlay].pitches.length;
          if (sizeOfPitchesInCurrentPlay - 1 < currentPitch) {
            awardScoresToPlayers(plays[currentPlay]);
            if (currentPlay + 1 < gameObjectPlayByPlay.plays.length) {
              currentPlay = currentPlay + 1;
              changeActivePlayer();
              updateAwayTeamRuns();
              updateHomeTeamRuns();
              currentPitch = 1;
              currentInnings = plays[currentPlay].inningNumber - 1;
            } else {
              setState(() {
                gameOver = true;
              });
            }
          } else {
            currentPitch++;
          }
        }
      }
    });

    var counter = 1;
    for (Plays play in gameObjectPlayByPlay.plays) {
      var result = play.result;
      var description = play.description;
      var runsBattedIn = play.runsBattedIn;
      //print("Play $counter:\nResult: $result\nDescription: $description\nRuns Batted In: $runsBattedIn\n\n");
      counter++;
    }
  }

  void changeActivePlayer() {
    var length = firebaseGameObject.players.length;
    if (activePlayer + 1 > length - 1) {
      setState(() {
        activePlayer = 0;
      });
    } else {
      setState(() {
        activePlayer++;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Utils().getBGColor(),
      body: gameObjectPlayByPlay == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildSafeArea(),
    );
  }

  Widget buildSafeArea() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/stadium.jpg"),
            fit: BoxFit.cover,
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.75), BlendMode.srcOver)),
      ),
      child: buildColumn(),
    );
  }

  getAnimatedWidget() {
//    return PlayAnimation<Color>( // <-- specify type of animated variable
//        tween: Colors.red.tweenTo(Colors.blue), // <-- define tween of colors
//        builder: (context, child, value) { // <-- builder function
//          return Container(
//              color: value, // <-- use animated value
//              width: 100,
//              height: 100
//          );
//        });
//  }
  }

  Widget buildColumn() {
    return Container(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Visibility(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                displaymsg,
                style: TextStyle(color: Colors.white),
              ),
            ),
            visible: true,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              getCurrentPlayersInfo(),
              getCurrentInningData(),
              getScoreData(),
            ],
          ),
          SizedBox(
            height: 0,
          ),
          buildResultWidget(),
          SizedBox(
            height: 0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getCupWidget(),
                SizedBox(
                  width: 0,
                ),
                getPlayersRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildResultWidget() {
    try {
      return Visibility(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            gameObjectPlayByPlay.plays[currentPlay - 1].description,
            style: TextStyle(color: Colors.white),
          ),
        ),
        visible: true,
      );
    } catch (e) {
      print(e);
      return SizedBox();
    }
  }

  Container getScoreData() {
    try {
      return Container(
        width: MediaQuery.of(context).size.width * .49,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            getPointsColumn(),
            SizedBox(
              height: 20,
            ),
            simulation ? getBSO() : getBSOLive(),
            SizedBox(
              height: 20,
            ),
            getPointsTable(),
          ],
        ),
      );
    } catch (e) {
      print(e);
      return Container(child: Text(e.message));
    }
  }

  Container getCurrentInningData() {
    return Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * .23,
        padding: EdgeInsets.only(top: 3, left: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border(
              bottom: BorderSide(color: borderColor),
              top: BorderSide(color: borderColor),
              left: BorderSide(color: borderColor),
              right: BorderSide(color: borderColor),
            )),
        child: FittedBox(
          child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Utils().getBlue()),
              child: getPitchColumn()),
        ));
  }

  Column getPitchColumn() {
    List<Widget> pitches = new List();
    if (simulation) {
//      pitches.add(Text(
//        "Play No.   " + (currentPlay + 1).toString(),
//        style: TextStyle(color: Colors.white),
//      ));
    }
    if (gameObjectPlayByPlay != null && gameObjectPlayByPlay.plays.length > 0) {
      for (int i = 0; i < currentPitch; i++) {
        try {
          pitches.add(getPitchRow(
              gameObjectPlayByPlay.plays[currentPlay].pitches[i], i + 1));
        } catch (e) {
          print(e);
        }
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: pitches,
    );
  }

  Widget getPitchRow(Pitches pitch, int index) {
    return Padding(
      padding: EdgeInsets.all(2),
      child: Row(
        children: <Widget>[
          Text(
            "Pitch " + index.toString(),
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            getResultForPitch(pitch),
            style: TextStyle(
                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String getResultForPitch(Pitches pitch) {
    if (pitch.strike) {
      return "Strike";
    } else if (pitch.ball) {
      return "Ball";
    } else if (pitch.foul) {
      return "Foul";
    } else if (pitch.swinging) {
      return "Swinging";
    } else if (pitch.looking) {
      return "Looking";
    }
    bool hit = gameObjectPlayByPlay.plays[currentPlay].hit;
    bool out = gameObjectPlayByPlay.plays[currentPlay].out;
    bool walk = gameObjectPlayByPlay.plays[currentPlay].walk;
    if (hit) {
      return "Hit";
    }
    if (out) {
      return "Out";
    }
    if (walk) {
      return "Walk";
    }
    return "Unknown";
  }

  Row getCurrentPlayerInfoWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        FadeAnimation(
            1.3,
            Text(
              "4.",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            )),
        SizedBox(
          width: 10,
        ),
        FadeAnimation(
            1.3,
            CircleAvatar(
              maxRadius: 15,
              backgroundImage: AssetImage("assets/girl.png"),
            )),
        SizedBox(
          width: 10,
        ),
        FadeAnimation(
            1.3,
            Text(
              "Ayush Mehre",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w400),
            )),
      ],
    );
  }

  Container getCurrentPlayersInfo() {
    return Container(
      width: MediaQuery.of(context).size.width * .28,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
              onPressed: () {
                Utils().showToast(
                    "Are you sure you want to exit the game?", context, ok: () {
                  Navigator.pop(context);
                }, cancel: true, oktext: "Exit Game");
              }),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    padding: EdgeInsets.only(top: 3, left: 0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border(
                          bottom: BorderSide(color: borderColor),
                          top: BorderSide(color: borderColor),
                          left: BorderSide(color: borderColor),
                          right: BorderSide(color: borderColor),
                        )),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(0),
                            color: Colors.transparent),
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              "https://s3-us-west-2.amazonaws.com/static.fantasydata.com/headshots/mlb/low-res/10005716.png",
                              width: 50,
                              height: 50,
                            )
                          ],
                        ))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Current Hitter",
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      gameObjectPlayByPlay == null ||
                              gameObjectPlayByPlay == null
                          ? "Loading..."
                          : getBatterNameText(),
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      maxLines: 5,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    padding: EdgeInsets.only(top: 3, left: 3),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        border: Border(
                          bottom: BorderSide(color: borderColor),
                          top: BorderSide(color: borderColor),
                          left: BorderSide(color: borderColor),
                          right: BorderSide(color: borderColor),
                        )),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.transparent),
                        child: Column(
                          children: <Widget>[
                            Image.network(
                              "https://s3-us-west-2.amazonaws.com/static.fantasydata.com/headshots/mlb/low-res/10000242.png",
                              width: 50,
                              height: 50,
                            )
                          ],
                        ))),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Current Pitcher",
                    style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      gameObjectPlayByPlay == null ||
                              gameObjectPlayByPlay.game == null
                          ? "Loading..."
                          : getPitcherNAmeText(),
                      softWrap: true,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  String getImageURLFor() {
    return "";
  }

  String getBatterNameText() {
    try {
      return gameObjectPlayByPlay.plays[currentPlay].hitterName.toString() +
          " (" +
          gameObjectPlayByPlay.plays[currentPlay].hitterPosition +
          ")";
    } catch (e) {
      print(e);
      return "";
    }
  }

  String getPitcherNAmeText() {
    try {
      return gameObjectPlayByPlay.plays[currentPlay].pitcherName.toString() +
          " (" +
          gameObjectPlayByPlay.plays[currentPlay].pitcherThrowHand +
          ")";
    } catch (e) {
      print(e);
      return "";
    }
  }

  Widget getPlayersRow() {
    List<Widget> playersW = List();
    //playersW.add(getCupWidget());
    var count = 0;
    for (Player player in firebaseGameObject.players) {
      playersW.add(getPlayerWidget(player, active: count == activePlayer));
      count++;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: playersW,
    );
  }

  Widget getPlayerWidget(Player player, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: active ? 17 : 15,
            backgroundColor: Colors.yellow,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  "https://ui-avatars.com/api/?name=${player.name}&bold=true&background=808080&color=ffffff"),
            ),
          ),
          Text(
            player.name,
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          ),
          Text(
            "${player.gamescore} Points",
            style: TextStyle(
                color: Colors.white, fontSize: 10, fontWeight: FontWeight.w400),
          ),
          active
              ? Image.asset("assets/logo.png",
                  width: 25, height: 25, fit: BoxFit.contain)
              : SizedBox(
                  width: 25,
                  height: 25,
                ),
        ],
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
                    gameObjectPlayByPlay.game.awayTeam,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: Column(
                          children: <Widget>[
                            Text(
                              awayTeamRuns.toString(),
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
                        borderRadius: BorderRadius.circular(10),
                        color: Utils().getBlue()),
                    child: Column(
                      children: <Widget>[
                        Text(
                          getCurrentInningNumber(),
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
                    gameObjectPlayByPlay.game.homeTeam,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0),
                    child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.redAccent),
                        child: Column(
                          children: <Widget>[
                            Text(
                              homeTeamRuns.toString(),
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

  void updateHomeTeamRuns() {
    if (currentPlay != lastScoreUpdatedinPlay) {
      var score = 0;
      for (int i = 0; i <= currentPlay; i++) {
        if (gameObjectPlayByPlay.plays[i].inningHalf=="B") {
          score = gameObjectPlayByPlay.plays[i].runsBattedIn + score;
        }
      }
      setState(() {
        lastScoreUpdatedinPlay = currentPlay;
        homeTeamRuns = score;
      });
    }
  }

  void updateAwayTeamRuns() {
      if (currentPlay != lastScoreUpdatedinPlay) {
        var score = 0;
        for (int i = 0; i <= currentPlay; i++) {
          if (gameObjectPlayByPlay.plays[i].inningHalf=="T") {
            score = gameObjectPlayByPlay.plays[i].runsBattedIn + score;
          }
        }
        setState(() {
          awayTeamRuns = score;
          lastScoreUpdatedinPlay = currentPlay;
        });
      }
  }

  String getCurrentInningNumber() {
    try {
      var play = gameObjectPlayByPlay.plays[currentPlay];
      int number = play.inningNumber;
      if (number == 1) {
        return number.toString() + "st(${play.inningHalf})";
      } else if (number == 2) {
        return number.toString() + "nd (${play.inningHalf})";
      } else if (number == 3) {
        return number.toString() + "rd (${play.inningHalf})";
      } else {
        return number.toString() + "th (${play.inningHalf})";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  getPointsTable() {
    return FittedBox(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              children: getInningsUptoNow(),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.white),
              top: BorderSide(color: Colors.white),
              left: BorderSide(color: Colors.white),
              right: BorderSide(color: Colors.white),
            )),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.white),
                    top: BorderSide(color: Colors.white),
                    left: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                  )),
                  child: Row(
                    children: getInningsScoreUptoNowTeamAway(),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.white),
                    top: BorderSide(color: Colors.white),
                    left: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                  )),
                  child: Row(
                    children: getInningsScoreUptoNow(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> getInningsScoreUptoNowTeamAway() {
    List<Widget> widgets = List<Widget>();
    widgets.add(getTextForTable(gameObjectPlayByPlay.game.awayTeam,
        wide: true, bold: true));
    for (int i = 0; i < 9; i++) {
      if (i <= currentInnings) {
        widgets.add(getTextForTable(
            gameObjectPlayByPlay.game.innings[i].awayTeamRuns.toString()));
      } else {
        widgets.add(getTextForTable(""));
      }
    }
    return widgets;
  }

  List<Widget> getInningsScoreUptoNow() {
    List<Widget> widgets = List<Widget>();
    widgets.add(getTextForTable(gameObjectPlayByPlay.game.homeTeam,
        wide: true, bold: true));
    for (int i = 0; i < 9; i++) {
      if (i <= currentInnings) {
        widgets.add(getTextForTable(
            gameObjectPlayByPlay.game.innings[i].homeTeamRuns.toString()));
      } else {
        widgets.add(getTextForTable(""));
      }
    }
    return widgets;
//    return <Widget>[
//      getTextForTable(gameObjectPlayByPlay.game.homeTeam,
//          wide: true, bold: true),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[0].homeTeamRuns.toString()),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[1].homeTeamRuns.toString()),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[2].homeTeamRuns.toString()),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[3].homeTeamRuns.toString()),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[4].homeTeamRuns.toString()),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[5].homeTeamRuns.toString()),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[6].homeTeamRuns.toString()),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[7].homeTeamRuns.toString()),
//      getTextForTable(
//          gameObjectPlayByPlay.game.innings[8].homeTeamRuns.toString()),
//    ];
  }

  List<Widget> getInningsUptoNow() {
    return <Widget>[
      getTextForTable("Innings", wide: true, bold: true),
      getTextForTable("1"),
      getTextForTable("2"),
      getTextForTable("3"),
      getTextForTable("4"),
      getTextForTable("5"),
      getTextForTable("6"),
      getTextForTable("7"),
      getTextForTable("8"),
      getTextForTable("9"),
    ];
  }

  Widget getTextForTable(String text, {bool wide = false, bool bold = false}) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        text,
        style: TextStyle(
            fontWeight: bold ? FontWeight.bold : null,
            color: Colors.white,
            fontSize: 13),
      ),
      height: 23,
      width: wide ? 50 : 25,
    );
  }

  Widget getBSO() {
    try {
      Plays play = gameObjectPlayByPlay.plays[currentPlay];
      Pitches pitch = play.pitches[currentPitch - 1];

      var ballsBeforePitch = pitch.ballsBeforePitch + (pitch.ball ? 1 : 0);
      var strikesBeforePitch =
          pitch.strikesBeforePitch + (pitch.strike ? 1 : 0);

      var variable = 0;
      if (!pitch.strike &&
          !pitch.ball &&
          !pitch.foul &&
          !pitch.swinging &&
          !pitch.looking &&
          play.out) {
        variable++;
      }
      var outs = pitch.outs + variable;
      return Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          getDotView("BALL", ballsBeforePitch),
          SizedBox(
            width: 30,
          ),
          getDotView("STRIKE", strikesBeforePitch),
          SizedBox(
            width: 30,
          ),
          getDotView("OUT", outs),
        ],
      );
    } catch (e) {
      print(e);
      return Text(e.toString());
    }
  }

  Widget getBSOLive() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        getDotView("BALL", gameObjectPlayByPlay.plays[currentPlay].balls),
        SizedBox(
          width: 30,
        ),
        getDotView("STRIKE", gameObjectPlayByPlay.plays[currentPlay].strikes),
        SizedBox(
          width: 30,
        ),
        getDotView("OUT", gameObjectPlayByPlay.plays[currentPlay].outs),
      ],
    );
  }

  Column getDotView(String title, int count) {
    String dots = "";
    for (int i = 0; i < count; i++) {
      dots = dots + "⚪ ";
    }
    return Column(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(
          height: 0,
        ),
        Text(dots,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget getCupWidget() {
    return Container(
      margin: EdgeInsets.only(right: 26),
      width: 80,
      height: 80,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              cupScore.toString(),
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Cup\nPoints",
              style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 3),
        borderRadius: BorderRadius.all(
          Radius.circular(200),
        ),
        color: Colors.white70,
      ),
    );
  }

  void awardScoresToPlayers(Plays play) {
    var result = play.result;
    int pointsToBeAwarded = getPointsToBeAwardedByResult(result);
    setState(() {
      firebaseGameObject.players[activePlayer].gamescore =
          firebaseGameObject.players[activePlayer].gamescore +
              pointsToBeAwarded;
      cupScore = cupScore - pointsToBeAwarded;
      displaymsg =
          "$pointsToBeAwarded points awarded to ${firebaseGameObject.players[activePlayer].name} for $result";
    });
    print(
        "$pointsToBeAwarded points awarded to ${firebaseGameObject.players[activePlayer].name} for $result");
    // updateFirebaseGameObject();
  }

  int getPointsToBeAwardedByResult(String result) {
    int points = 0;
    switch (result) {
      case "Ground out":
        points = -1;
        break;
      case "Single":
        points = 1;
        break;
      case "Foul Out":
        points = -1;
        break;
      case "Strikeout Swinging":
        points = -2;
        break;
      case "Home Run":
        points = cupScore;
        break;
      case "Walk":
        points = 1;
        break;
      case "Fielder’s Choice":
        points = -1;
        break;
      case "Pop Out":
        points = -1;
        break;
      case "Lineout":
        points = -1;
        break;
      case "Sacrifice Fly":
        points = 1;
        break;
      case "Line into Double Play":
        points = -2;
        break;
      case "Double":
        points = 2;
        break;
      case "Hit by Pitch":
        points = 1;
        break;
      case "Stolen Base":
        points = 0;
        break;
      case "Sacrifice":
        points = 0;
        break;
      case "Error":
        points = -1;
        break;
      case "Intentional Walk":
        points = 1;
        break;
      case "Triple":
        points = 5;
        break;
    }
    return points;
  }

  void updateFirebaseGameObject() {
    Firestore.instance
        .collection('games')
        .document(firebaseGameObject.gameCode)
        .setData(firebaseGameObject.toJson());
  }
}

mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }

  @override
  void dispose() {
    _enableRotation();
  }
}

void _portraitModeOnly() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}

void _enableRotation() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
}
