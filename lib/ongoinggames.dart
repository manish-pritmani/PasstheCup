import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/model/firebasegameObject.dart';

import 'game2.dart';

class OnGoingGames extends StatefulWidget {
  final String status;

  OnGoingGames(this.status);

  @override
  _OnGoingGamesState createState() => _OnGoingGamesState();
}

class _OnGoingGamesState extends State<OnGoingGames>
    with AutomaticKeepAliveClientMixin<OnGoingGames> {
  FirebaseUser firebaseUser;

  List<DocumentSnapshot> documents = List();

  bool loaded;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  Future getUser() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();
    QuerySnapshot querySnapshot = await fetchGames();
    setState(() {
      documents = querySnapshot.documents;
      loaded = true;
    });
  }

  Future<QuerySnapshot> fetchGames() async {
    QuerySnapshot documents = await Firestore.instance
        .collection("user")
        .document(firebaseUser.email)
        .collection("mygames")
        .orderBy("createdOn", descending: true)
        .limit(10)
        .getDocuments();
    return documents;
  }

  @override
  Widget build(BuildContext context) {
    if (loaded != null) {
      if (documents.length > 0) {
        return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return OnGoingGameWidget(
                  document: documents[index],
                  user: firebaseUser,
                  status: widget.status);
            });
      } else {
        return Center(child: Text("No games found"));
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class OnGoingGameWidget extends StatefulWidget {
  final String status;

  const OnGoingGameWidget({
    Key key,
    @required this.document,
    @required this.user,
    this.status,
  }) : super(key: key);

  final DocumentSnapshot document;
  final FirebaseUser user;

  @override
  _OnGoingGameWidgetState createState() => _OnGoingGameWidgetState();
}

class _OnGoingGameWidgetState extends State<OnGoingGameWidget> {
  FirebaseGameObject gameObject;
  StreamSubscription<DocumentSnapshot> listen;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchGame();
  }

  void fetchGame() async {
//    var documentSnapshot = await Firestore.instance
//        .collection("games")
//        .document(widget.document.data["gameCode"])
//        .get();

    listen = Firestore.instance
        .collection("games")
        .document(widget.document.data["gameCode"])
        .snapshots()
        .listen((event) {
      setState(() {
        gameObject = FirebaseGameObject.fromJson(event.data);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    listen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var map = widget.document.data;
    Map<String, dynamic> data2 = map["selectedGame"];
    var eventDate;
    if (gameObject != null) {
      eventDate =
          gameObject.createdOn.substring(0, gameObject.createdOn.indexOf("."));
    }
    return Visibility(
      visible: gameObject != null && gameObject.selectedGame.status == widget.status,
      child: GestureDetector(
        onTap: () {
          if (gameObject.selectedGame.status != "Final") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(
                          gameObject,
                        )));
          }
        },
        child: Card(
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("GameID: " +
                        (gameObject == null ? "" : gameObject.gameCode)),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      data2["AwayTeam"].toString() +
                          " vs. " +
                          data2["HomeTeam"].toString(),
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    gameObject == null
                        ? Text("fetching status")
                        : buildStatusText(),
                    SizedBox(
                      height: 2,
                    ),
                    gameObject == null
                        ? Text("fetching status")
                        : buildMyPointsText(),
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text("Created on: " + getinUserFormat(eventDate), style: TextStyle(color: Colors.grey),),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      gameObject == null ? "0" : gameObject.cupScore.toString(),
                      style:
                          TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Cupscore",
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String getinUserFormat(String eventDate) {
    if (eventDate != null) {
      DateFormat dateFormat = new DateFormat("yyyy-MM-dd hh:mm:ss");
      DateTime parse = dateFormat.parse(eventDate);
      return new DateFormat("dd MMM, hh:mm a").format(parse);
    } else {
      return "";
    }
  }

  Text buildStatusText() {
    if (gameObject.selectedGame.status == "InProgress") {
      return getOngoingText();
    } else if (gameObject.selectedGame.status == "Final") {
      return getGameEndedText();
    } else if (gameObject.selectedGame.status== "Scheduled") {
      return getGameScheduledText();
    } else {
      return Text("Status: " + gameObject.status.toString());
    }
  }

  Text getOngoingText() {
    return Text(
      "OnGoing",
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
  }

  Text getGameEndedText() {
    return Text(
      "Game Ended",
      style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
    );
  }

  Text getGameScheduledText() {
    return Text(
      "Scheduled",
      style: TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
    );
  }

  buildMyPointsText() {
    return Text(
      "My score: " + getmyscore(),
      style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
    );
  }

  String getmyscore() {
    int myscore = 0;
    for (int i = 0; i < gameObject.players.length; i++) {
      if (gameObject.players[i].email == widget.user.email) {
        myscore = gameObject.players[i].gamescore;
      }
    }
    return myscore.toString();
  }
}
