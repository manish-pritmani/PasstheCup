import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/api.dart';
import 'package:passthecup/utils.dart';

import 'game2.dart';
import 'model/Player.dart';
import 'model/firebasegameObject.dart';

class Lobby extends StatefulWidget {
  final String gameID;
  final bool add;

  final FirebaseUser user;
  final bool simulation;

  Lobby(this.gameID, this.add, {this.user, this.simulation = false});

  @override
  LobbyState createState() => LobbyState(gameID, add, user);
}

class LobbyState extends State<Lobby> {
  String gameID;
  bool isAdded;
  bool add;

  FirebaseGameObject firebaseGameObject;

//  LobbyObject lobbyObject;
  FirebaseUser user;
  DocumentReference gameDocumentRef;
  DocumentReference lobbyDocumentRef;
  StreamSubscription<DocumentSnapshot> gameDocumentSubscription;

  bool hideListView = false;

  // StreamSubscription<DocumentSnapshot> lobbyDocumentSubscription;

  LobbyState(this.gameID, this.add, this.user);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isAdded = false;
    gameDocumentRef = Firestore.instance.collection('games').document(gameID);
//    lobbyDocumentRef =
//        Firestore.instance.collection('players').document(gameID);
    setState(() {
      hideListView = false;
    });
    startFetching();
  }

  void startFetching() async {
    try {
      //fetch gameObject and LobbyObject first
      var value = await gameDocumentRef.get();
      onGetObject(value);
      //var valueLobby = await lobbyDocumentRef.get();
      // onGetObjectLobby(valueLobby);

      //Once Fetched, listen for any changes in gameObject and lobbyObject
      if (firebaseGameObject.status == 0) {
        listenToGameObjectChanges();
      } else {
        if (firebaseGameObject.status == 1) {
          if (firebaseGameObject.selectedGame.status == "InProgress") {
            Utils().showToast("Game has already started", context, oktext: "OK",
                ok: () {
              Navigator.pop(context, false);
            });
          } else {
            if (add) {
              addMeAsAPlayer();
              addToMyGames();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => GameScreen(
                            firebaseGameObject,
                            doubleClose: true,
                          )));
            }
          }
        } else {
          if (!exists(user.email)) {
            Utils().showToast("Game has already ended", context, oktext: "OK",
                ok: () {
              Navigator.pop(context, false);
            });
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => GameScreen(
                          firebaseGameObject,
                          doubleClose: true,
                        )));
          }
        }
      }
      //listenLobby();
    } catch (e) {
      print(e);
      Navigator.pop(context, false);
    }

//     gameDocumentRef.get().then((value) {
//      onGetObject(value);
//      lobbyDocumentRef.get().then((value) {
//        onGetObjectLobby(value);
//        listenToGameObjectChanges();
//        if (add) {
//          addMeAsAPlayer();
//        }
//      });
//      if (firebaseGameObject.status == 1) {
//        joinGameInBetween(context, firebaseGameObject.simulation);
//      } else {
//        listenLobby();
//      }
//    }).catchError((e) {
//    //      Utils().showToast(e.toString(), context, ok: (){
//    //        Navigator.pop(context);
//    //      });
//      Navigator.pop(context, false);
//    });
  }

  void performActionBasedOnGameStatus() {
    switch (firebaseGameObject.status) {
      case 0: //not started
        if (add) {
          addToMyGames();
          addMeAsAPlayer();
        }
        break;
      case 1: //in Progress
        //joinGameInBetween(context, firebaseGameObject.simulation);
        addToMyGames();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GameScreen(
                      firebaseGameObject,
                    )));
        break;
      case -1: // game ended
        Utils().showToast("Game has ended", context);
        break;
      default:
        Utils().showToast(
            "Unknown Game status: ${firebaseGameObject.status}", context);
    }
  }

  void listenToGameObjectChanges() {
    gameDocumentSubscription = gameDocumentRef.snapshots().listen((event) {
      onGetUpdates(event);
    });
  }

//  void listenLobby() {
//    lobbyDocumentSubscription = lobbyDocumentRef.snapshots().listen((event) {
//      onGetUpdatesLobby(event);
//    });
//  }

  void onGetObject(DocumentSnapshot event) {
    var map = event.data;
    var encode = jsonEncode(map);
    print(encode);
    setState(() {
      firebaseGameObject = FirebaseGameObject.fromJson(map);
    });
  }

//  void onGetObjectLobby(DocumentSnapshot event) {
//    var map = event.data;
//    var encode = jsonEncode(map);
//    print(encode);
//    setState(() {
//      lobbyObject = LobbyObject.fromJson(map);
//    });
//  }

  @override
  void dispose() {
    super.dispose();
//    lobbyDocumentSubscription?.cancel();
    gameDocumentSubscription?.cancel();
  }

  void addMeAsAPlayer() {
    var email = user.email;
    if (!exists(email) && !isAdded) {
      firebaseGameObject.players.add(Player(
          name: user.displayName, email: email, gamescore: -5, host: false));
      firebaseGameObject.cupScore = firebaseGameObject.cupScore + 5;
      isAdded = true;
    }
    //var document = Firestore.instance.collection('players').document(gameID);
    gameDocumentRef.setData(firebaseGameObject.toJson());
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
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FadeAnimation(
                1, Text(widget.simulation ? 'Simulation Mode' : 'Real Game')),
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
                  child: buildListView()),
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
                  if (!add || isHost()) {
//                      showAlertDialog(context, "", "Select Mode", "Simulation",
//                          "Live Game");

                    showAttendingDialog();
//                    openGameScreen(context, widget.simulation);
                  } else {
                    Utils()
                        .showToast("Wait for host to start the game", context);
                  }
                },
                color: Utils().getBlue(),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
                child: Text(
                  add && !isHost() ? "WAITING FOR GAME TO START" : "START GAME",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListView() {
    if (!hideListView) {
      return ListView(
        children: getAllPlayers(),
      );
    } else {
      return Text("");
    }
  }

  // showAlertDialog(BuildContext context, String message, String heading,
  //     String buttonAcceptTitle, String buttonCancelTitle) {
  //   // set up the buttons
  //   Widget cancelButton = FlatButton(
  //     child: Text(buttonCancelTitle),
  //     onPressed: () {
  //       openGameScreen(context, false);
  //     },
  //   );
  //   Widget continueButton = FlatButton(
  //     child: Text(buttonAcceptTitle),
  //     onPressed: () {
  //       openGameScreen(context, true);
  //     },
  //   );
  //
  //   // set up the AlertDialog
  //   AlertDialog alert = AlertDialog(
  //     title: Text(heading),
  //     actions: [
  //       cancelButton,
  //       continueButton,
  //     ],
  //   );
  //
  //   // show the dialog
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return alert;
  //     },
  //   );
  // }

//  void joinGameInBetween(BuildContext context, bool simulation) {
//    addToMyGames();
//    if (add) {
//      addMeAsAPlayer();
//    }
//    Navigator.pop(context, false);
//    Navigator.pushReplacement(
//        context,
//        MaterialPageRoute(
//            builder: (context) => GameScreen(
//                  firebaseGameObject,
//                )));
//  }

  void openGameScreen(BuildContext context, bool simulation,
      {bool attending = false}) async {
    Utils().showLoaderDialog(context);
    await Firestore.instance
        .collection('games')
        .document(widget.gameID)
        .setData({'attending': attending}, merge: true);
    Navigator.pop(context);

    setState(() {
      hideListView = true;
    });
    addToMyGames();
    Utils().showLoaderDialog(context);
    firebaseGameObject.status = 1;
    firebaseGameObject.simulation = simulation;
    firebaseGameObject.cupScore = firebaseGameObject.players.length * 5;
    Firestore.instance
        .collection("games")
        .document(firebaseGameObject.gameCode)
        .setData(firebaseGameObject.toJson(), merge: true)
        .then((value) {
      if (!simulation) {
        startActualGame(context, attending);
      } else {
        startSimulatedGame(context, attending);
      }
    }).catchError((onError) => {Utils().showToast(onError.message, context)});
  }

  void startActualGame(BuildContext context, bool attending) {
    API()
        .startGame(
            firebaseGameObject.selectedGame.gameID, firebaseGameObject.gameCode)
        .then((value) {
      openNextScreen(context, attending);
    }).catchError((onError) => {Utils().showToast(onError.message, context)});
  }

  void startSimulatedGame(BuildContext context, bool attending) {
    Utils().showLoaderDialog(context);
    API()
        .startSimulation(
            firebaseGameObject.selectedGame.gameID, firebaseGameObject.gameCode)
        .then((value) {
      Navigator.pop(context);
      openNextScreen(context, attending);
    }).catchError((onError) => {Utils().showToast(onError.message, context)});
  }

  void openNextScreen(BuildContext context, bool attending) {
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.pop(context);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => GameScreen(
                  firebaseGameObject,
//                  attending: attending,
                  tripleClose: true,
                )));
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
    //print(encode);
    setState(() {
      firebaseGameObject = FirebaseGameObject.fromJson(map);
    });
    //Now, check the status of game to know weather game has started, inProgress, or ended.
    performActionBasedOnGameStatus();
  }

//  void onGetUpdatesLobby(DocumentSnapshot event) {
//    var map = event.data;
//    var encode = jsonEncode(map);
//    print(encode);
//    setState(() {
//      lobbyObject = LobbyObject.fromJson(map);
//    });
//  }

  void addToMyGames() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    await Firestore.instance
        .collection("user")
        .document(firebaseUser.email)
        .collection("mygames")
        .document(gameID)
        .setData(firebaseGameObject.toJson());

    print("Done");
  }

  bool isHost() {
    Player hostPlayer;
    for (Player player in firebaseGameObject.players) {
      if (player.host) {
        hostPlayer = player;
      }
    }
    return user.email == hostPlayer.email;
  }

  showAttendingDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text('Will you be attending this game?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  openGameScreen(context, widget.simulation, attending: true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  openGameScreen(context, widget.simulation, attending: false);
                },
              )
            ],
          );
        });
  }
}
