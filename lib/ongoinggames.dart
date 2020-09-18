import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/model/firebasegameObject.dart';

class OnGoingGames extends StatefulWidget {
  @override
  _OnGoingGamesState createState() => _OnGoingGamesState();
}

class _OnGoingGamesState extends State<OnGoingGames> {
  FirebaseUser firebaseUser;

  List<DocumentSnapshot> documents;

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
                  document: documents[index], user: firebaseUser);
            });
      } else {
        return Center(child: Text("You have no ongoing games"));
      }
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}

class OnGoingGameWidget extends StatefulWidget {
  const OnGoingGameWidget({
    Key key,
    @required this.document,
    @required this.user,
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
    return Card(
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
                Text(
                  data2["AwayTeam"].toString() +
                      " vs. " +
                      data2["HomeTeam"].toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                ),
                Text("Created on: " + getinUserFormat(eventDate)),
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
              ],
            ),
            Column(
              children: [
                Text(
                  gameObject == null ? "0" : gameObject.cupScore.toString(),
                  style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Cupscore",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                )
              ],
            )
          ],
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
    if (gameObject.status == 1) {
      return getOngoingText();
    } else if (gameObject.status == -1) {
      return getGameEndedText();
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
