import 'dart:async';
import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/model/firebasegameObject.dart';
import 'package:passthecup/resultscreen.dart';
import 'package:passthecup/utils.dart';
import 'package:screen/screen.dart';

import 'api.dart';
import 'model/Player.dart';

class GameScreen extends StatefulWidget {
  final FirebaseGameObject firebaseGameObject;

  GameScreen(this.firebaseGameObject);

  @override
  State<StatefulWidget> createState() => _GameScreenState(firebaseGameObject);
}

class _GameScreenState extends State<GameScreen>
    with PortraitStatefulModeMixin<GameScreen> {
  FirebaseGameObject firebaseGameObject;
  bool gameOver;
  String displayMsg;
  String hitterImageLink;
  String pitcherImageLink;
  String bgImage;

  int lastSnapshotReceivedTime = 0;
  List<int> updateDurationArray = List();
  Timer timer;
  DateTime lastchanged = DateTime.now();
  int currentIndex = 0;
  var ads = [
    "assets/ad1.png",
    "assets/ad2.png",
    "assets/ad3.png",
    "assets/ad4.png",
    "assets/ad5.png"
  ];

  Duration timeSinceLastUpdate = Duration(seconds: 0);

  bool dialogVisible = false;

  _GameScreenState(this.firebaseGameObject);

  @override
  void initState() {
    super.initState();
    // Prevent screen from going into sleep mode:
    Screen.keepOn(true);
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    setState(() {
      gameOver = false;
      displayMsg = "";
      hitterImageLink = "";
      pitcherImageLink = "";
    });

    fetchBackgroundImage();
    listenGameObject();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        timeSinceLastUpdate = DateTime.now().difference(
            DateTime.fromMillisecondsSinceEpoch(lastSnapshotReceivedTime));
      });
    });
  }

  void listenGameObject() {
    Firestore.instance
        .collection("games")
        .document(firebaseGameObject.gameCode)
        .snapshots()
        .listen((event) {
      try {
        var map = event.data;
        var encode = jsonEncode(map);
        print("Snapshot Received: " + encode);
        setState(() {
          firebaseGameObject = FirebaseGameObject.fromJson(map);
          displayMsg = firebaseGameObject.selectedGame.lastPlay.toString();
          lastSnapshotReceivedTime = DateTime.now().millisecondsSinceEpoch;
          updateDurationArray.add(timeSinceLastUpdate.inSeconds);
        });
        fetchHitterProfilePicture();
        fetchPitcherProfilePicture();

        if (firebaseGameObject.status == -1) {
          openResultScreen();
        }

        if (firebaseGameObject.selectedGame.status == "Scheduled") {
          showGameNotStartedDialog();
        } else {
          if (dialogVisible) {
            Navigator.pop(context);
          }
        }
      } catch (e) {
        print(e);
      }
    });
  }

  void openResultScreen() {
    Navigator.of(context).pushReplacement(new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return new ResultScreen(firebaseGameObject);
      },
    ));
  }

  void fetchBackgroundImage() {
    Firestore.instance
        .collection("images")
        .document(firebaseGameObject.selectedGame.homeTeam)
        .get()
        .then((value) {
      var src = value.data["link"];
      setState(() {
        bgImage = src;
      });
    }).catchError((e) {});
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: firebaseGameObject == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : buildBuildSafeArea(),
    );
  }

  Widget buildBuildSafeArea() {
    return buildSafeArea();
  }

  Widget buildSafeArea() {
    return FadeAnimation(
      1,
      Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
              image: getBackgroundImage(),
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.5), BlendMode.srcOver)),
        ),
        child: buildColumn(context),
      ),
    );
  }

  ImageProvider<dynamic> getBackgroundImage() {
    if (bgImage == null) {
      return AssetImage("assets/stadium.jpg");
    } else {
      return NetworkImage(bgImage);
    }
  }

  Widget buildColumn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 16),
      child: Stack(
        children: <Widget>[
          Align(
            child: getExitButton(),
            alignment: Alignment.topRight,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[getMainRow(context), getBottomRow()],
          ),
          Align(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  getGameIDText(),
                  getChannelNameText(),
                  getLastSnapshotTimeText(),
                  //getPlayID(),
                ],
              ),
            ),
            alignment: Alignment.topLeft,
          ),
          Align(
            child: Image.asset(
              getAdImageName(),
              width: 250,
              height: 40,
              fit: BoxFit.fitWidth,
            ),
            alignment: Alignment.topCenter,
          ),
        ],
      ),
    );
  }

  String getAdImageName() {
    var seconds = DateTime.now().difference(lastchanged).inSeconds;
    if (seconds > 15) {
      var i = currentIndex + 1;
      var j = ads.length - 1;
      if (i < j) {
        currentIndex = currentIndex + 1;
      } else {
        currentIndex = 0;
      }
      lastchanged = DateTime.now();
    }
    return ads[currentIndex];
  }

  Padding getBottomRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          getLastPlayDescriptionWidget(),
          getPlayersRow(),
          getCupWidget()
        ],
      ),
    );
  }

  Widget getCupWidget() {
    var scoreToShow = firebaseGameObject.cupScore.toString();
    if (firebaseGameObject.cupScore > 10 && firebaseGameObject.cupScore < 10) {
      scoreToShow = "0" + firebaseGameObject.cupScore.toString();
    }
    return Stack(
      children: <Widget>[
        Image.asset(
          "assets/Cup_Icon.png",
          width: 70,
          height: 100,
        ),
        Positioned(
          top: 35,
          left: 25,
          child: Text(
            scoreToShow + "",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Row getMainRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        getRightWidget(),
        getFieldWidget(),
        getScoreData(),
      ],
    );
  }

  Widget getRightWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * .2,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          getPointsAwardedWidget(),
          Padding(
            padding: const EdgeInsets.only(right: 26.0, top: 8),
            child: Text(
              "${firebaseGameObject.lastResult}",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  IconButton getExitButton() {
    return IconButton(
        icon: Icon(
          Icons.close,
          color: Colors.white,
        ),
        onPressed: () {
          Utils().showToast("Are you sure you want to exit the game?", context,
              ok: () {
            Navigator.pop(context);
          }, cancel: true, oktext: "Exit Game");
        });
  }

  Widget getFieldWidget() {
    return Container(
      width: MediaQuery.of(context).size.width * .3,
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Image.asset(
            "assets/baseball_field_image.png",
            width: 200,
            height: 200,
          ),
          Positioned(
            bottom: 75,
            left: 55,
            child: Column(
              children: <Widget>[
                getPitcherImage(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  firebaseGameObject.selectedGame.currentPitcher == null
                      ? ""
                      : firebaseGameObject.selectedGame.currentPitcher
                          .toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )
              ],
            ),
          ),
          Positioned(
            bottom: -10,
            left: 50,
            child: Column(
              children: <Widget>[
                getHitterImage(),
                SizedBox(
                  height: 5,
                ),
                Text(
                  firebaseGameObject.selectedGame.currentHitter == null
                      ? ""
                      : firebaseGameObject.selectedGame.currentHitter
                          .toString(),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          getFieldPlayerWidgetLeft(),
          getFieldPlayerRightWidget(),
          getFieldPlayerTopWidget(),
        ],
      ),
    );
  }

  Widget getFieldPlayerTopWidget() {
    bool b = firebaseGameObject.selectedGame.runnerOnSecond;
    if (b == null) {
      b = false;
    }
    return Visibility(
      visible: b,
      child: Positioned(
        top: 35,
        left: 95,
        child: Image.asset(
          "assets/dot.png",
          width: 15,
          height: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getFieldPlayerRightWidget() {
    bool b = firebaseGameObject.selectedGame.runnerOnFirst;
    if (b == null) {
      b = false;
    }
    return Visibility(
      visible: b,
      child: Positioned(
        bottom: 87,
        right: 27,
        child: Image.asset(
          "assets/dot.png",
          width: 15,
          height: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getFieldPlayerWidgetLeft() {
    bool b = firebaseGameObject.selectedGame.runnerOnThird;
    if (b == null) {
      b = false;
    }
    return Visibility(
      visible: b,
      child: Positioned(
        bottom: 87,
        left: 27,
        child: Image.asset(
          "assets/dot.png",
          width: 15,
          height: 15,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget getLastPlayDescriptionWidget() {
    bool b = displayMsg != "null";
    return Container(
      width: 300,
      child: Visibility(
        visible: b,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            padding: EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
            color: Colors.blueAccent.withOpacity(0.5),
            child: AutoSizeText(
              displayMsg.toString(),
              style: TextStyle(color: Colors.white),
              maxLines: 2,
              textAlign: TextAlign.center,
              presetFontSizes: [16, 12, 10],
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
    );
  }

  Text getChannelNameText() {
    return Text(
      "Channel: ${firebaseGameObject.selectedGame.channel}",
      style: TextStyle(color: Hexcolor("#99FFFFFF")),
    );
  }

  Text getLastSnapshotTimeText() {
    return Text(
      "Last Updated: ${timeSinceLastUpdate.inSeconds.toString()} sec ago",
      //"\nShortest Time: ${getSmallest()} sec"
      //"\nLongest Time: ${getLargest()} sec"
      // "\nAverage Time: ${getAvg()} sec"
      //"\n${updateDurationArray.toString()}",
      style: TextStyle(color: Hexcolor("#99FFFFFF")),
    );
  }

  Text getPlayID() {
    var string = firebaseGameObject.toJson().toString();
    print(string);
    return Text(
      "Last PlayID: ${firebaseGameObject.lastPlayID}",
      //"\nShortest Time: ${getSmallest()} sec"
      //"\nLongest Time: ${getLargest()} sec"
      // "\nAverage Time: ${getAvg()} sec"
      //"\n${updateDurationArray.toString()}",
      style: TextStyle(color: Hexcolor("#99FFFFFF")),
    );
  }

  Text getGameIDText() {
    return Text(
      "Game ID: ${firebaseGameObject.gameCode}",
      style: TextStyle(color: Hexcolor("#99FFFFFF")),
    );
  }

  Widget buildResultWidget() {
    try {
      return Visibility(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Text(
            "Last Result: ${firebaseGameObject.lastResult} (${firebaseGameObject.lastResultPointsAwarded})",
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
        width: MediaQuery.of(context).size.width * .4,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            getPointsColumn(),
            SizedBox(
              height: 20,
            ),
            /*simulation ? getBSO() : */ getBSOLive(),
            SizedBox(
              height: 20,
            ),
            getPointsTable(),
          ],
        ),
      );
    } catch (e) {
      print(e);
      return Container(child: Text("e.message"));
    }
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

//  Container getCurrentPlayersInfo() {
//    return Container(
//      width: MediaQuery.of(context).size.width * .28,
//      child: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          IconButton(
//              icon: Icon(
//                Icons.close,
//                color: Colors.white,
//              ),
//              onPressed: () {
//                Utils().showToast(
//                    "Are you sure you want to exit the game?", context, ok: () {
//                  Navigator.pop(context);
//                }, cancel: true, oktext: "Exit Game");
//              }),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 10),
//                child: Container(
//                    padding: EdgeInsets.only(top: 3, left: 0),
//                    child: Container(
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(0),
//                            color: Colors.transparent),
//                        child: Column(
//                          children: <Widget>[getHitterImage()],
//                        ))),
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "Current Hitter",
//                    style: TextStyle(
//                        color: Colors.white60,
//                        fontSize: 14,
//                        fontWeight: FontWeight.w400),
//                  ),
//                  SizedBox(
//                    width: 100,
//                    child: Text(
//                      firebaseGameObject == null || firebaseGameObject == null
//                          ? "Loading..."
//                          : getBatterNameText(),
//                      softWrap: true,
//                      overflow: TextOverflow.fade,
//                      maxLines: 5,
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 14,
//                          fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                ],
//              )
//            ],
//          ),
//          SizedBox(
//            height: 10,
//          ),
//          Row(
//            children: <Widget>[
//              Padding(
//                padding: EdgeInsets.symmetric(horizontal: 10),
//                child: Container(
//                    padding: EdgeInsets.only(top: 3, left: 3),
//                    child: Container(
//                        decoration: BoxDecoration(
//                            borderRadius: BorderRadius.circular(10),
//                            color: Colors.transparent),
//                        child: Column(
//                          children: <Widget>[getPitcherImage()],
//                        ))),
//              ),
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(
//                    "Current Pitcher",
//                    style: TextStyle(
//                        color: Colors.white60,
//                        fontSize: 14,
//                        fontWeight: FontWeight.w400),
//                  ),
//                  SizedBox(
//                    width: 100,
//                    child: Text(
//                      firebaseGameObject == null
//                          /*||
//                          firebaseGameObject.gameProgress.currentPitcher == null*/
//                          ? "Loading..."
//                          : getPitcherNAmeText(),
//                      softWrap: true,
//                      style: TextStyle(
//                          color: Colors.white,
//                          fontSize: 14,
//                          fontWeight: FontWeight.bold),
//                    ),
//                  ),
//                ],
//              )
//            ],
//          ),
//        ],
//      ),
//    );
//  }

  Widget getPitcherImage() {
    return Image.network(
      pitcherImageLink,
      width: 50,
      height: 50,
    );
  }

  Widget getHitterImage() {
    return Image.network(
      hitterImageLink,
      width: 50,
      height: 50,
    );
  }

  String getBatterNameText() {
    return firebaseGameObject.selectedGame.currentHitter.toString();
  }

  String getPitcherNAmeText() {
    return firebaseGameObject.selectedGame.currentPitcher.toString();
  }

  Widget getPlayersRow() {
    List<Widget> playersW = List();
    //playersW.add(getCupWidget());
    var count = 0;
    for (Player player in firebaseGameObject.players) {
      playersW.add(getPlayerWidget(player,
          active: count == firebaseGameObject.currentActivePlayer));
      count++;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: playersW,
    );
  }

  Widget getPlayersInLobby() {
//    List<Widget> playersW = List();
//    //playersW.add(getCupWidget());
//    var count = 0;
//    for (Player player in firebaseGameObject.players) {
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      playersW.add(getPlayerWidgetLobby(player, active: player.host));
//      count++;
//    }
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: firebaseGameObject.players.length,
        itemBuilder: (context, index) {
          return getPlayerWidgetLobby(firebaseGameObject.players[index],
              active: firebaseGameObject.players[index].host);
        },
      ),
    );
  }

  Widget getPlayerWidgetLobby(Player player, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: active ? 17 : 15,
            backgroundColor: Colors.redAccent,
            child: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(
                  "https://ui-avatars.com/api/?name=${player.name}&bold=true&background=808080&color=ffffff"),
            ),
          ),
          Text(
            player.name.substring(0, player.name.indexOf(" ")),
            style: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  Widget getPlayerWidget(Player player, {bool active = false}) {
    return Padding(
      padding: const EdgeInsets.only(right: 24.0),
      child: Column(
        children: <Widget>[
          active
              ? Image.asset("assets/logo.png",
                  width: 25, height: 25, fit: BoxFit.contain)
              : SizedBox(
                  width: 25,
                  height: 25,
                ),
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
                    firebaseGameObject.selectedGame.awayTeam,
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
                    firebaseGameObject.selectedGame.homeTeam,
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

  Widget getVersusWidget() {
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                firebaseGameObject.selectedGame.awayTeam
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "VS",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                firebaseGameObject.selectedGame.homeTeam
                                    .toString(),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
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

  String getCurrentInningNumber() {
    try {
//      var play = firebaseGameObject.currentInningNumber[currentPlay];
      int number = firebaseGameObject.selectedGame.inning;
      var inningHalf = firebaseGameObject.currentInningHalf == "T" ? "▲" : "▼";
      if (number == 1) {
        return number.toString() + "st $inningHalf";
      } else if (number == 2) {
        return number.toString() + "nd $inningHalf";
      } else if (number == 3) {
        return number.toString() + "rd $inningHalf";
      } else {
        return number.toString() + "th $inningHalf";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }

  getPointsTable() {
    return FittedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            child: Row(
              children: getInningsUptoNow(),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                border: Border(
              bottom: BorderSide(color: Colors.white),
              top: BorderSide(color: Colors.white),
              left: BorderSide(color: Colors.white),
              right: BorderSide(color: Colors.white),
            )),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
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
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      border: Border(
                    bottom: BorderSide(color: Colors.white),
                    top: BorderSide(color: Colors.white),
                    left: BorderSide(color: Colors.white),
                    right: BorderSide(color: Colors.white),
                  )),
                  child: Row(
                    children: getInningsScoreUptoNowHomeTeam(),
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
    widgets.add(getTextForTable(firebaseGameObject.selectedGame.awayTeam,
        wide: true, bold: true));
    for (int i = 0; i < 9; i++) {
      if (i <= firebaseGameObject.selectedGame.inning) {
        try {
          var string = firebaseGameObject.selectedGame.innings[i].awayTeamRuns
              .toString();
          widgets.add(getTextForTable(string));
        } catch (e) {
          print(e);
          widgets.add(getTextForTable(""));
        }
      }
      /*else if (i == currentInnings) {
//          if (gameObjectPlayByPlay.plays[currentPlay].inningHalf == "T") {
//            widgets.add(getTextForTable(
//                gameObjectPlayByPlay.game.innings[i].awayTeamRuns.toString()));
//          } else {
//            widgets.add(getTextForTable(
//                gameObjectPlayByPlay.game.innings[i].awayTeamRuns.toString()));
//          }
          widgets.add(getTextForTable(""));
        } */
      else {
        widgets.add(getTextForTable(""));
      }
    }
    return widgets;
  }

  List<Widget> getInningsScoreUptoNowHomeTeam() {
    List<Widget> widgets = List<Widget>();
    try {
      widgets.add(getTextForTable(firebaseGameObject.selectedGame.homeTeam,
          wide: true, bold: true));
      for (int i = 0; i < 9; i++) {
        if (i <= firebaseGameObject.selectedGame.inning) {
          try {
            var string = firebaseGameObject.selectedGame.innings[i].homeTeamRuns
                .toString();
            if (string != "null") {
              widgets.add(getTextForTable(string));
            } else {
              widgets.add(getTextForTable(""));
            }
          } catch (e) {
            print(e);
            widgets.add(getTextForTable(""));
          }
        }
        /*else if (i == currentInnings) {
//          if (gameObjectPlayByPlay.plays[currentPlay].inningHalf == "B") {
//            widgets.add(getTextForTable(
//                gameObjectPlayByPlay.game.innings[i].homeTeamRuns.toString()));
//          } else {
//            widgets.add(getTextForTable(""));
          widgets.add(getTextForTable(""));
//          }
        }*/
        else {
          widgets.add(getTextForTable(""));
        }
      }
    } catch (e) {
      print(e);
    }
    return widgets;
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

  Widget getBSOLive() {
    try {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          getDotView("BALL", firebaseGameObject.selectedGame.balls),
          SizedBox(
            width: 30,
          ),
          getDotView("STRIKE", firebaseGameObject.selectedGame.strikes),
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

  Widget getPointsAwardedWidget() {
    var pointsAwarded = firebaseGameObject.lastResultPointsAwarded;
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
              pointsAwarded.toString(),
              style: TextStyle(
                color: pointsAwarded >= 0 ? Colors.black : Colors.white,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              getPointText(pointsAwarded),
              style: TextStyle(
                fontSize: 12.0,
                color: pointsAwarded >= 0 ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 0),
        borderRadius: BorderRadius.all(
          Radius.circular(200),
        ),
        color: getColorByPointsAwarded(pointsAwarded),
      ),
    );
  }

  String getPointText(int pointsAwarded) {
    if ((pointsAwarded == 1 || pointsAwarded == -1)) {
      return "Point";
    } else {
      return "Points";
    }
  }

  Color getColorByPointsAwarded(int pointsAwarded) {
    if (pointsAwarded > 0) {
      return Colors.greenAccent;
    } else if (pointsAwarded < 0) {
      return Colors.redAccent;
    } else {
      return Colors.white70;
    }
  }

  void fetchHitterProfilePicture() {
    API()
        .fetchPlayerImage(firebaseGameObject.selectedGame.currentHitterID)
        .then((value) {
      setState(() {
        hitterImageLink = value;
      });
      return null;
    });
  }

  void fetchPitcherProfilePicture() {
    API()
        .fetchPlayerImage(firebaseGameObject.selectedGame.currentPitcherID)
        .then((value) {
      setState(() {
        pitcherImageLink = value;
      });
      return null;
    });
  }

  showQDialog() {
//    showGeneralDialog(
//      barrierLabel: "Barrier",
//      barrierDismissible: true,
//      barrierColor: Colors.black.withOpacity(0.7),
//      transitionDuration: Duration(milliseconds: 200),
//      context: context,
//      pageBuilder: (_, __, ___) {
//        return Align(
//          alignment: Alignment.bottomRight,
//          child: GestureDetector(
//            onTap: () {
//              Navigator.pop(context);
//            },
//            child: Scaffold(
//              backgroundColor: Colors.redAccent,
//              body: Container(
//                child: Stack(
//                  children: <Widget>[],
//                ),
//              ),
//            ),
//          ),
//        );
//      },
//    );
  }

  int getSmallest() {
    int smallest = 1000000;
    updateDurationArray.removeWhere((element) => element == 0);

    updateDurationArray = updateDurationArray.toSet().toList();

    for (int i in updateDurationArray) {
      if (i < smallest) {
        smallest = i;
      }
    }
    return smallest == 1000000 ? 0 : smallest;
  }

  int getLargest() {
    int largest = 0;
    for (int i in updateDurationArray) {
      if (i > largest) {
        largest = i;
      }
    }
    return largest;
  }

  int getAvg() {
    int sum = 0;
    for (int i in updateDurationArray) {
      try {
        sum += updateDurationArray[i];
      } catch (e) {
        print(e);
      }
    }
    var d = sum / updateDurationArray.length;
    try {
      return d.round();
    } catch (e) {
      return 0;
    }
  }

  void showGameNotStartedDialog() async {
    dialogVisible = true;
    await showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
      context: context,
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () {},
          child: Align(
            alignment: Alignment.center,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: MediaQuery.of(context).size.height * 0.75,
              child: getGameInfoWidget(),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(1),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(
            begin: Offset(0, 1),
            end: Offset(0, 0),
          ).animate(anim),
          child: child,
        );
      },
    );
  }

  Widget getGameInfoWidget() {
    return Material(
      color: Colors.white.withOpacity(0.0),
      child: Container(
        padding: EdgeInsets.all(16),
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width * 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Waiting for the Game to Start",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28,
                  decoration: TextDecoration.none,
                )),
            getVersusWidget(),
            getGameTimeText(),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getChannelInfor(),
                getWeatherInfo(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                firebaseGameObject.players.length == 1
                    ? "${firebaseGameObject.players.length} Player Joined"
                    : "${firebaseGameObject.players.length} Players Joined",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 18),
              ),
            ),
//            Padding(
//              padding: const EdgeInsets.all(8.0),
//              child: getPlayersInLobby(),
//            ),
            OutlineButton(
              borderSide: BorderSide(color: Colors.black26),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text(
                "OK",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Text getWeatherInfo() {
    return Text(
      "Weather: ${firebaseGameObject.selectedGame.forecastDescription}",
      style: TextStyle(
          color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Text getChannelInfor() {
    return Text(
      "Channel: ${firebaseGameObject.selectedGame.channel}",
      style: TextStyle(
          color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  Widget getGameTimeText() {
    var dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss");
    var dateTime = firebaseGameObject.selectedGame.dateTime;
    var parsedDate = dateFormat.parse(dateTime);
    var dateFormat2 = DateFormat("dd MMM yyyy hh:mm a");
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        "Game Time: ${dateFormat2.format(parsedDate)}",
        style: TextStyle(
            color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

//Widget getEmptyArea(BuildContext context) {
//  return Container(
//    alignment: Alignment.center,
//    width: MediaQuery.of(context).size.width * .23,
//  );
//}

mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }

  @override
  void dispose() {
    _enableRotation();
    super.dispose();
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
