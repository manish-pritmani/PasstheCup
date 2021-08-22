import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/logscreen2.dart';
import 'package:passthecup/model/firebasegameObject.dart';
import 'package:passthecup/resultscreen.dart';

import 'game2.dart';
import 'logscreen.dart';

class OnGoingGames extends StatefulWidget {
  final String status;

  final Function(FirebaseGameObject) onClick;

  OnGoingGames(this.status, {this.onClick});

  @override
  _OnGoingGamesState createState() => _OnGoingGamesState();
}

class _OnGoingGamesState extends State<OnGoingGames>
    with AutomaticKeepAliveClientMixin<OnGoingGames> {
  User firebaseUser;

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
    firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;
    QuerySnapshot querySnapshot = await fetchGames();
    setState(() {
      documents = querySnapshot.docs;
      loaded = true;
    });
  }

  Future<QuerySnapshot> fetchGames() async {
    QuerySnapshot documents = await FirebaseFirestore.instance
        .collection("user")
        .doc(firebaseUser.email)
        .collection("mygames")
        .orderBy("createdOn", descending: true)
        .get();
    return documents;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loaded != null) {
      if (documents.length > 0) {
        return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (context, index) {
              return OnGoingGameWidget(
                  document: documents[index],
                  user: firebaseUser,
                  status: widget.status,
                  onClick: widget.onClick);
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

  final Function(FirebaseGameObject) onClick;

  const OnGoingGameWidget({
    Key key,
    @required this.document,
    @required this.user,
    this.status,
    this.onClick,
  }) : super(key: key);

  final DocumentSnapshot document;
  final User user;

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

    listen = FirebaseFirestore.instance
        .collection("games")
        .doc(widget.document.data()["gameCode"])
        .snapshots()
        .listen((event) {
      setState(() {
        gameObject = FirebaseGameObject.fromJson(event.data());
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
    var map = widget.document.data();
    Map<String, dynamic> data2 = map["selectedGame"];
    var eventDate;
    if (gameObject != null && gameObject.createdOn!=null) {
      eventDate =
          gameObject.createdOn.substring(0, gameObject.createdOn.indexOf("."));
    }
    return Visibility(
      visible:
          gameObject != null && (gameObject.selectedGame?.status??'') == widget.status,
      child: GestureDetector(
        onLongPress: () {
          var materialPageRoute = MaterialPageRoute(builder: (context) => LogScreen2(gameObject));
          Navigator.push(context, materialPageRoute);
          //openPlayByPlayData(context);
        },
        onTap: () {
          if (gameObject.selectedGame.status != "Final") {
            if (widget.onClick == null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameScreen(
                            gameObject,
                          )));
            } else {
              widget.onClick.call(gameObject);
            }
          } else {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ResultScreen(gameObject, celibrate: false)));
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
                      child: Text(
                        "Created on: " + getinUserFormat(eventDate),
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    widget.status=='Final'?OutlineButton(onPressed: (){
                      var materialPageRoute = MaterialPageRoute(builder: (context) => LogScreen2(gameObject));
                      Navigator.push(context, materialPageRoute);
//                      openPlayByPlayData(context);
                    }, child: Text('Show play by play data'),):SizedBox()
                  ],
                ),
                widget.status == "Final"
                    ? buildMyScoreColumn()
                    : buildCupScoreColumn()
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openPlayByPlayData(BuildContext context) {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Select type of logs:'),
            actions: <Widget>[
              FlatButton(
                child: Text('Real time Play by Play'),
                onPressed: () {
                  var materialPageRoute = MaterialPageRoute(builder: (context) => LogScreen(gameObject));
                  Navigator.push(context, materialPageRoute);
                },
              ),
              FlatButton(
                child: Text('Play by Play'),
                onPressed: () {
                  var materialPageRoute = MaterialPageRoute(builder: (context) => LogScreen2(gameObject));
                  Navigator.push(context, materialPageRoute);
                },
              )
            ],
          );
        });
  }

  Column buildMyScoreColumn() {
    return Column(
      children: [
        Text(
          gameObject == null ? "0" : getmyscore(),
          style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        ),
        Text(
          "My Score",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Column buildCupScoreColumn() {
    return Column(
      children: [
        Text(
          gameObject == null ? "0" : gameObject.cupScore2.toString(),
          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
        Text(
          "Cupscore",
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        )
      ],
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
    } else if (gameObject.selectedGame.status == "Scheduled") {
      return getGameScheduledText();
    } else {
      return Text("Status: " + gameObject.status.toString());
    }
  }

  Text getOngoingText() {
    return Text(
      "Active",
      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
    );
  }

  Text getGameEndedText() {
    return Text(
      "Complete",
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
    if (widget.status != "Final") {
      return Text(
        "My score: " + getmyscore(),
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
      );
    } else {
      return Text(
        "" + getWinner(),
        style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
      );
    }
  }

  String getmyscore() {
    int myscore = 0;
    for (int i = 0; i < gameObject.players.length; i++) {
      if (gameObject.players[i].email == widget.user.email) {
        myscore = gameObject.players[i].gamescore2;
      }
    }
    return myscore.toString();
  }

  String getWinner() {
    int myscore = 0;
    int winnerIndex = 0;
    for (int i = 0; i < gameObject.players.length; i++) {
      if (gameObject.players[i].gamescore2 > myscore) {
        myscore = gameObject.players[i].gamescore2;
        winnerIndex = i;
      }
    }
    if (gameObject.players[winnerIndex].email == widget.user.email) {
      return "You Won";
    } else {
      return gameObject.players[winnerIndex].name + " won. You lost";
    }
  }
}
