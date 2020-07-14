import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/utils.dart';

class CreateGame extends StatefulWidget {
  @override
  _CreateGameState createState() => _CreateGameState();
}

class _CreateGameState extends State<CreateGame> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser user;

  getUser() async{
    FirebaseUser firebaseUser = await _auth.currentUser();
    await firebaseUser?.reload();
    firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      setState(() {
        this.user = firebaseUser;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:  Utils().getBGColor(),
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor:  Utils().getBGColor(),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios, size: 20, color: Colors.white,),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
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
                    Column(
                      children: <Widget>[
                        FadeAnimation(1, Text("Create New Game", style: TextStyle( color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.w500
                        ),)),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(1.2, makeInput(label: "Select Session")),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(1.2, makeInput(label: "Select Team")),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(1.2, makeInput(label: "Select Game")),
                            ],
                          ),
                        ),
                      ],
                    ),
                    FadeAnimation(1.4, Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: Container(
                        padding: EdgeInsets.only(top: 3, left: 3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border(
                              bottom: BorderSide(color: Colors.black),
                              top: BorderSide(color: Colors.black),
                              left: BorderSide(color: Colors.black),
                              right: BorderSide(color: Colors.black),
                            )
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () {
                            //Todo : Create game with the details
                            Firestore.instance.collection("games").document(user.uid).setData(
                                {
                                  "name" : user.displayName,
                                  "joinPlayers" : 0,
                                  "creatorId" : user.uid,
                                  "status": 0,
                                  "createdOn": DateTime.now().toString(),
                                }).then((_){
                              print("Game Created Successfully!");
                            });
                          },
                          color: Colors.amberAccent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                          ),
                          child: Text("Create New Game", style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18
                          ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              ),
              FadeAnimation(1.2, Container(
                height: MediaQuery.of(context).size.height / 2.9,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/homerun3.png'),
                        fit: BoxFit.cover
                    )
                ),
              ))
            ],
          ),
        ),
      )
    );
  }

  //Todo : Take create game inputs
  Widget makeInput({label, obscureText = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(label, style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.white
        ),),
        SizedBox(height: 5,),
        TextField(
          obscureText: obscureText,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            ),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])
            ),
          ),
        ),
        SizedBox(height: 30,),
      ],
    );
  }
}