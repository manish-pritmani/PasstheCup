import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/api.dart';
import 'package:passthecup/game.dart';
import 'package:passthecup/model/gameObject.dart';
import 'package:passthecup/model/teamobject.dart';
import 'package:passthecup/utils.dart';

import 'game2.dart';
import 'model/Player.dart';
import 'model/firebasegameObject.dart';

class Lobby extends StatefulWidget {
  String gameID;
  bool add;

  FirebaseUser user;

  Lobby(this.gameID, this.add, {this.user});

  @override
  LobbyState createState() => LobbyState(gameID, add, user);
}

class LobbyState extends State<Lobby> {
  String gameID;
  bool isAdded;
  bool add;

  FirebaseGameObject firebaseGameObject;
  FirebaseUser user;

  LobbyState(this.gameID, this.add, this.user);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAdded = false;
    var document = Firestore.instance.collection('games').document(gameID);
    document.snapshots().listen((event) {
      onGetUpdates(event);
    });
    document.get().then((value) {
      onGetObject(value);
      if (add) {
        addMeAsAPlayer();
      }
    }).catchError((e) {
//      Utils().showToast(e.toString(), context, ok: (){
//        Navigator.pop(context);
//      });
      Navigator.pop(context, false);
    });
  }

  void onGetObject(DocumentSnapshot event) {
    var map = event.data;
    var encode = jsonEncode(map);
    print(encode);
    setState(() {
      firebaseGameObject = FirebaseGameObject.fromJson(map);
    });
  }

  void addMeAsAPlayer() {
    var email = user.email;
    if (/*!exists(email) &&*/ !isAdded) {
      firebaseGameObject.players.add(Player(
          name: user.displayName, email: email, gamescore: -5, host: false));
      isAdded = true;
    }
    var document = Firestore.instance.collection('games').document(gameID);
    document.setData(firebaseGameObject.toJson());
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
        body: firebaseGameObject == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildSingleChildScrollView(context));
  }

  Widget buildSingleChildScrollView(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              getGameLobbyTitle(),
              getTeamvsTeam(),
              SizedBox(
                height: 20,
              ),
              getGameCodeWidget(),
              SizedBox(
                height: 20,
              ),
              Text(
                "Players in Lobby (${firebaseGameObject.players.length})",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Container(
                    height: 220,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent),
                    child: ListView(
                      children: getAllPlayers(),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: MaterialButton(
                  minWidth: double.infinity,
                  height: 60,
                  onPressed: () {
                    if (!add) {
//                      showAlertDialog(context, "", "Select Mode", "Simulation",
//                          "Live Game");
                      openGameScreen(context, false);
                    } else {
                      Utils().showToast(
                          "Wait for host to start the game", context);
                    }
                  },
                  color: Utils().getBlue(),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    add ? "WAITING FOR GAME TO START" : "START GAME",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context, String message, String heading,
      String buttonAcceptTitle, String buttonCancelTitle) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text(buttonCancelTitle),
      onPressed: () {
        openGameScreen(context, false);
      },
    );
    Widget continueButton = FlatButton(
      child: Text(buttonAcceptTitle),
      onPressed: () {
        openGameScreen(context, true);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(heading),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void openGameScreen(BuildContext context, bool simulation) {
    Utils().showLoaderDialog(context);
    firebaseGameObject.status = 1;
    firebaseGameObject.simulation = simulation;
    firebaseGameObject.cupScore = firebaseGameObject.players.length * 5;
    Firestore.instance
        .collection("games")
        .document(firebaseGameObject.gameCode)
        .setData(firebaseGameObject.toJson(), merge: true)
        .then((value) {
      API()
          .startGame(firebaseGameObject.selectedGame.gameID,
              firebaseGameObject.gameCode)
          .then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GameScreen(
                      firebaseGameObject,
                    )));
      }).catchError((onError) => {Utils().showToast(onError.message, context)});
    }).catchError((onError) => {Utils().showToast(onError.message, context)});
  }

  List<Widget> getAllPlayers() {
    List<Widget> widgets = List();
    for (Player player in firebaseGameObject.players) {
      widgets.add(getPlayerWidget(player));
    }
    return widgets;
  }

  Padding getGameCodeWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Utils().getBlue()),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              FadeAnimation(
                  1.3,
                  Text(
                    "Pass the Cup Game Code",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  )),
              SizedBox(
                height: 10,
              ),
              FadeAnimation(
                  1,
                  Text(
                    firebaseGameObject.gameCode,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  Column getGameLobbyTitle() {
    return Column(
      children: <Widget>[
        FadeAnimation(
            1,
            Text(
              "Game Lobby",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            )),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Padding getTeamvsTeam() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10), color: Colors.redAccent),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                      1.3,
                      Text(
                        firebaseGameObject.selectedGame.awayTeam,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
              SizedBox(
                width: 20,
              ),
              FadeAnimation(
                  1,
                  Text(
                    "vs",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                width: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                      1.3,
                      Text(
                        firebaseGameObject.selectedGame.homeTeam,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            ],
          )),
    );
  }

  Widget getPlayerWidget(Player player) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            maxRadius: 15,
            backgroundImage: NetworkImage(
                "https://ui-avatars.com/api/?name=${player.name}&bold=true&background=808080&color=ffffff"),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            player.name + (player.host ? " (Host)" : ""),
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

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
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  bool exists(String email) {
    for (Player player in firebaseGameObject.players) {
      if (player.email == email) {
        return true;
      }
    }
    return false;
  }

  void onGetUpdates(DocumentSnapshot event) {
    var map = event.data;
    var encode = jsonEncode(map);
    print(encode);
    setState(() {
      firebaseGameObject = FirebaseGameObject.fromJson(map);
    });
    if (firebaseGameObject.status == 1) {
      openGameScreen(context, firebaseGameObject.simulation);
    }
  }
}
