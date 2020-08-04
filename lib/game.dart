import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:passthecup/model/firebasegameObject.dart';
import 'package:passthecup/model/gameObjectPlaybyPlay.dart';
import 'package:passthecup/utils.dart';

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

  int currentPlay = 0;
  int currentPitch = 0;
  int currentInnings = 0;
  bool simulation;
  List<Player> players = List();

  bool sim;

  _inGameState(this.firebaseGameObject, this.sim);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);
    if (sim == null) {
      sim = false;
    }
    setState(() {
      currentPitch = 0;
      currentPlay = 0;
      currentInnings = 0;
      simulation = sim;
    });

    borderColor = Colors.transparent;

    timer = Timer.periodic(
        Duration(seconds: 5),
        (Timer t) => simulation
            ? onGameFetched(gameObjectPlayByPlay)
            : fetchGameDetails());
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
    API().fetchGamePlayByPlay().then((value) {
      onGameFetched(value);
      return null;
    }).catchError((onError) {
      setState(() {
        fetching = false;
      });
    });
  }

  void onGameFetched(GameObjectPlayByPlay value) {
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
            currentPlay++;
            currentPitch = 1;
            currentInnings = plays[currentPlay].inningNumber - 1;
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

  Widget buildColumn() {
    return Container(
      padding: EdgeInsets.only(top: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              getCurrentPlayersInfo(),
              getCurrentInningData(),
              getScoreData(),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 100.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                getCupWidget(),
                SizedBox(
                  width: 100,
                ),
                getPlayersRow(),
              ],
            ),
          ),
          Visibility(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "refreshing....",
                style: TextStyle(color: Colors.white),
              ),
            ),
            visible: false,
          )
        ],
      ),
    );
  }

  Column getScoreData() {
    return Column(
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
    );
  }

  Widget getCurrentInningData() {
    return Container(
        padding: EdgeInsets.only(top: 3, left: 3),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border(
              bottom: BorderSide(color: borderColor),
              top: BorderSide(color: borderColor),
              left: BorderSide(color: borderColor),
              right: BorderSide(color: borderColor),
            )),
        child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Utils().getBlue()),
            child: getPitchColumn()));
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
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            getResultForPitch(pitch),
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
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

  Column getCurrentPlayersInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                            width: 75,
                            height: 75,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  gameObjectPlayByPlay == null || gameObjectPlayByPlay == null
                      ? "Loading..."
                      : getBatterNameText(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
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
                            width: 75,
                            height: 75,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
                Text(
                  gameObjectPlayByPlay == null ||
                          gameObjectPlayByPlay.game == null
                      ? "Loading..."
                      : getPitcherNAmeText(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ],
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
    for (Player player in firebaseGameObject.players) {
      playersW.add(getPlayerWidget(player));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: playersW,
    );
  }

  Widget getPlayerWidget(Player player) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            maxRadius: 20,
            backgroundImage: AssetImage("assets/user.png"),
          ),
          Text(
            player.name,
            style: TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w400),
          ),
          Text(
            "${player.gamescore} Points",
            style: TextStyle(
                color: Colors.white, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Column getPointsColumn() {
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
                      fontSize: 18,
                      color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            bottom: BorderSide(color: borderColor),
                            top: BorderSide(color: borderColor),
                            left: BorderSide(color: borderColor),
                            right: BorderSide(color: borderColor),
                          )),
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent),
                          child: Column(
                            children: <Widget>[
                              Text(
                                getAwayTeamRuns().toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Utils().getBlue()),
                  child: Column(
                    children: <Widget>[
                      Text(
                        getCurrentInningNumber(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
            Column(
              children: <Widget>[
                Text(
                  getHomeTeamRuns(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                      padding: EdgeInsets.only(top: 3, left: 3),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border(
                            bottom: BorderSide(color: borderColor),
                            top: BorderSide(color: borderColor),
                            left: BorderSide(color: borderColor),
                            right: BorderSide(color: borderColor),
                          )),
                      child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.redAccent),
                          child: Column(
                            children: <Widget>[
                              Text(
                                gameObjectPlayByPlay.game.homeTeamRuns
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ))),
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
  }

  String getHomeTeamRuns() {
    if (!simulation) {
      return gameObjectPlayByPlay.game.homeTeam;
    } else {
      return gameObjectPlayByPlay.game.homeTeam;
    }
  }

  int getAwayTeamRuns() {
    if (!simulation) {
      return gameObjectPlayByPlay.game.awayTeamRuns;
    } else {
      return gameObjectPlayByPlay.game.awayTeamRuns;
    }
  }

  String getCurrentInningNumber() {
    try {
      var play = gameObjectPlayByPlay.plays[currentPlay];
      int number = play.inningNumber;
      if (number == 1) {
        return number.toString() + "st (${play.inningHalf})";
      } else if (number == 2) {
        return number.toString() + "nd  (${play.inningHalf})";
      } else if (number == 3) {
        return number.toString() + "rd  (${play.inningHalf})";
      } else {
        return number.toString() + "th  (${play.inningHalf})";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  getPointsTable() {
    return Container(
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
    widgets.add(getTextForTable(getHomeTeamRuns(), wide: true, bold: true));
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
            fontWeight: bold ? FontWeight.bold : null, color: Colors.white),
      ),
      height: 25,
      width: wide ? 50 : 25,
    );
  }

  Widget getBSO() {
    Plays play = gameObjectPlayByPlay.plays[currentPlay];
    Pitches pitch = play.pitches[currentPitch - 1];

    var ballsBeforePitch = pitch.ballsBeforePitch + (pitch.ball ? 1 : 0);
    var strikesBeforePitch = pitch.strikesBeforePitch + (pitch.strike ? 1 : 0);

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
  }

  Widget getBSOLive() {
    return Row(
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
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(
          height: 5,
        ),
        Text(dots,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget getCupWidget() {
    return Container(
      margin: EdgeInsets.only(right: 26),
      width: 100,
      height: 100,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "25",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              "Cup Points",
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
