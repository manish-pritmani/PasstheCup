import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/model/gameObject.dart';
import 'package:passthecup/utils.dart';

import 'api.dart';
import 'gamelobby.dart';
import 'model/Player.dart';
import 'model/teamobject.dart';

class TodaysGameScreen extends StatefulWidget {
  @override
  _TodaysGameScreenState createState() => _TodaysGameScreenState();
}

class _TodaysGameScreenState extends State<TodaysGameScreen> {
  Future<List<GameObject>> futureResult;
  List<GameObject> gamesList;
  bool fetching;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.getUser();


    futureResult = API().fetchGames().then((value) {
      setState(() {
        gamesList = value;
        fetching = false;
      });
      return null;
    });
    setState(() {
      fetching = true;
      gamesList = List<GameObject>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Today's Game"),
          leading: NavBackButton(),
        ),
        body: getBody());
  }

  Widget getBody() {
    if (fetching) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        padding: EdgeInsets.all(4),
        color: Hexcolor("#eeeeee"),
        child: ListView.builder(
            itemCount: gamesList.length,
            itemBuilder: (context, index) {
              // bool before = gamesList[index].status == "Final";
              return Visibility(
                child: GestureDetector(
                  onTap: () {
                    if (gamesList[index].status != "Canceled") {
                      createGameAndEnter(context, gamesList[index]);
                    } else {
                      Utils().showToast(
                          "Canceled games cannot be selected", context);
                    }
                  },
                  child: Card(
                    elevation: 1,
                    margin: EdgeInsets.all(4),
                    child: ListTile(
                      title: getTitleText(index),
                      subtitle: getSubTitleText(index),
                    ),
                  ),
                ),
              );
            }),
      );
    }
  }

  FirebaseUser user;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Text getTitleText(int index) {
    return Text(
      gamesList[index].awayTeam +
          " vs." +
          gamesList[index].homeTeam +
          "   (" +
          gamesList[index].status +
          ")",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Text getSubTitleText(int index) {
    bool before = gamesList[index].status == "Final";
    return Text(
      getinUserFormat(gamesList[index].dateTime) +
          ", " +
          getinDayUserFormat(gamesList[index].day),
      style: TextStyle(color: before ? Colors.red : null),
    );
  }

  void createGameAndEnter(BuildContext context, GameObject _currengame) {
    Utils().showLoaderDialog(context);
    List<Map<String, dynamic>> players = List();
    List<Map<String, dynamic>> playersLobby = List();
    var player = Player(
        name: user.displayName, email: user.email, gamescore: -5, host: true);
    playersLobby.add(player.toJson());
//    player.host = false;
//    playersLobby.add(player.toJson());
    String gameID = generateGameID();
    var map = {
      "gameID": _currengame.gameID,
      "selectedGame": _currengame.toJson(),
      "selectedTeam": null, //_currenteam.toJson(),
      "name": user.displayName,
      "hostID": user.email,
      "joinPlayers": 0,
      "creatorId": user.uid,
      "status": 0,
      "gameCode": gameID,
      "createdOn": DateTime.now().toString(),
      "players": playersLobby,
      "simulation": false,
      "lastResult": "",
      "lastResultPointsAwarded": 0,
      "currentHitter": "",
      "currentPitcher": "",
      "currentHitterID": 0,
      "currentPitcherID": 0,
      "currentInningNumber": 0,
      "currentInningHalf": "T",
      "currentActivePlayer": 0,
      "cupScore": 0,
      "lastUpdatedAt": ""
    };
    var lobbymap = {
      "players": playersLobby,
    };
    Firestore.instance
        .collection("games")
        .document(gameID)
        .setData(map)
        .then((_) {
      print("Game Created Successfully!");
      Firestore.instance
          .collection("players")
          .document(gameID)
          .setData(lobbymap)
          .then((value) {
        Navigator.pop(context);
        openLoabbyScreen(context, gameID);
      });
    });
  }

  void openLoabbyScreen(BuildContext context, String gameID) {
    Navigator.of(context).push(new MaterialPageRoute<TeamObject>(
      builder: (BuildContext context) {
        return new Lobby(gameID, false);
      },
    ));
  }

  String generateGameID() {
    var rng = new Random();
    var code = rng.nextInt(900000) + 100000;
    return code.toString();
  }
}

String getinUserFormat(String eventDate) {
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd'T'hh:mm:ss");
  DateTime parse = dateFormat.parse(eventDate);
  return new DateFormat("dd MMM, hh:mm a").format(parse);
}

String getinDayUserFormat(String eventDate) {
  DateFormat dateFormat = new DateFormat("yyyy-MM-dd'T'hh:mm:ss");
  DateTime parse = dateFormat.parse(eventDate);
  return new DateFormat("EEEE").format(parse);
}

class NavBackButton extends StatelessWidget {
  const NavBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {Navigator.pop(context)},
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
