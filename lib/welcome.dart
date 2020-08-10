import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/create-game.dart';
import 'package:passthecup/gameid.dart';
import 'package:passthecup/invite.dart';
import 'package:passthecup/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share/share.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;
  bool isSignedIn = false;
  String gamerImage;
  DocumentSnapshot firebaseUserObject;
  Color borderColor;

  //Todo : check if authenticated
  checkAuthentication() async {
    _auth.onAuthStateChanged.listen((user) {
      if (user == null) {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    });
  }

  //Todo : get user details
  getUser() async {
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isSignedIn = true;
        this.gamerImage = user.photoUrl;
      });
      Firestore.instance
          .collection("user")
          .document(user.email)
          .get()
          .then((value) {
        setState(() {
          firebaseUserObject = value;
        });
        return null;
      });
    } else {
      Utils().showToast("UserObject null", context);
    }
    print(
        "${user.displayName} is the gamer name with profile image url ${user.photoUrl}");
  }

  //TODO: Implement logout button somewhere in welcome screen
  signout() async {
    _auth.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    this.getUser();
    setState(() {
      borderColor = Colors.transparent;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (firebaseUserObject != null) {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Utils().getBGColor(),
        appBar: AppBar(
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Utils().getBGColor(),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  "Your coins💰: ${firebaseUserObject.data["score"]}",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            )
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: Colors.transparent,
            ),
          ),
        ),
        body: user == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : buildContainer(context),
      );
    } else {
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  Container buildContainer(BuildContext context) {
    Color color = Colors.primaries[Random().nextInt(Colors.primaries.length)];
    String hex = "808080"; // color.value.toRadixString(16).substring(2);
    return Container(
      color: Utils().getBGColor(),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    getAvatarWidget(hex),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: <Widget>[
//                    getAvatar(),
                        FadeAnimation(
                            1,
                            Text(
                              "Welcome",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            )),
                        FadeAnimation(
                          1,
                          Text(
                            "${firebaseUserObject.data["name"] == null ? user.email : user.displayName}"
                                .toUpperCase(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          height: 0,
                        ),
                      ],
                    ),
                  ],
                ),
                FadeAnimation(
                    1.4,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: borderColor),
                              top: BorderSide(color: borderColor),
                              left: BorderSide(color: borderColor),
                              right: BorderSide(color: borderColor),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GameId()));
                          },
                          color: Colors.redAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Join Game",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    )),
                FadeAnimation(
                    1.4,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: borderColor),
                              top: BorderSide(color: borderColor),
                              left: BorderSide(color: borderColor),
                              right: BorderSide(color: borderColor),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreateGame()));
                          },
                          color: Colors.redAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Create Game",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    )),
                FadeAnimation(
                    1.4,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: borderColor),
                              top: BorderSide(color: borderColor),
                              left: BorderSide(color: borderColor),
                              right: BorderSide(color: borderColor),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            Share.share(
                                'Download the PassTheCup App from AppStore: https://apps.apple.com/in/app/facebook/id284882215');
//                            Navigator.push(
//                                context,
//                                MaterialPageRoute(
//                                    builder: (context) => Invite()));
                          },
                          color: Utils().getBlue(),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Invite Friends",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    )),
                FadeAnimation(
                    1.4,
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: borderColor),
                              top: BorderSide(color: borderColor),
                              left: BorderSide(color: borderColor),
                              right: BorderSide(color: borderColor),
                            )),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: signout,
                          color: Utils().getBlue(),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Signout",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    )),
              ],
            ),
          ),
          FadeAnimation(
              1.2,
              Container(
                height: MediaQuery.of(context).size.height / 2.9,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/people.png'),
                        fit: BoxFit.cover)),
              ))
        ],
      ),
    );
  }

  FadeAnimation getAvatarWidget(String hex) {
    return FadeAnimation(
        1,
        CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(
              "https://ui-avatars.com/api/?name=${user.displayName}&bold=true&background=$hex&color=ffffff"),
        ));
  }

  FadeAnimation getAvatar() {
    return FadeAnimation(
        1,
        CircleAvatar(
          backgroundImage: user.photoUrl != null
              ? NetworkImage("${user.photoUrl}")
              : AssetImage('asset/index.png'),
        ));
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
}
