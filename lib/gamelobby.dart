import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/game.dart';
import 'package:passthecup/utils.dart';

class Lobby extends StatelessWidget {
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
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 15),
              child: Column(
                children: <Widget>[
                  FadeAnimation(
                      1.3,
                      CircleAvatar(
                        backgroundImage: AssetImage("assets/man.png"),
                      )),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
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
                          FadeAnimation(
                              1,
                              Text(
                                "Game Lobby",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w400),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border(
                                      bottom: BorderSide(color: Colors.black),
                                      top: BorderSide(color: Colors.black),
                                      left: BorderSide(color: Colors.black),
                                      right: BorderSide(color: Colors.black),
                                    )),
                                child: Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.redAccent),
                                    child: Column(
                                      children: <Widget>[
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            FadeAnimation(
                                                1.3,
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "assets/man.png"),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            FadeAnimation(
                                                1.3,
                                                Text(
                                                  "Ayush Mehre",
                                                  style: TextStyle( color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        FadeAnimation(
                                            1,
                                            Text(
                                              "vs",
                                              style: TextStyle( color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            FadeAnimation(
                                                1.3,
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "assets/girl.png"),
                                                )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            FadeAnimation(
                                                1.3,
                                                Text(
                                                  "Player Name",
                                                  style: TextStyle( color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w400),
                                                )),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "Game Date : 20th June 2020",
                                              style: TextStyle( color: Colors.white,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                        SizedBox(
                                          height: 10,
                                        ),
                                      ],
                                    ))),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                            padding: EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )),
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
                                          "Pass the Cup Game- Code",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FadeAnimation(
                                        1,
                                        Text(
                                          "3J9C5F",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25,
                                              fontWeight: FontWeight.w500),
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ))),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40),
                        child: Container(
                            padding: EdgeInsets.only(top: 3, left: 3),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border(
                                  bottom: BorderSide(color: Colors.black),
                                  top: BorderSide(color: Colors.black),
                                  left: BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )),
                            child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.redAccent),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FadeAnimation(
                                        1,
                                        Text(
                                          "Players in Lobby",
                                          style: TextStyle( color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w400),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "1.",
                                              style: TextStyle( color: Colors.white,
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
                                              backgroundImage:
                                                  AssetImage("assets/girl.png"),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "Player Name",
                                              style: TextStyle( color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "2.",
                                              style: TextStyle( color: Colors.white,
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
                                              backgroundImage:
                                                  AssetImage("assets/girl.png"),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "Player Name",
                                              style: TextStyle( color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "3.",
                                              style: TextStyle( color: Colors.white,
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
                                              backgroundImage:
                                                  AssetImage("assets/girl.png"),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "Player Name",
                                              style: TextStyle( color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "4.",
                                              style: TextStyle( color: Colors.white,
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
                                              backgroundImage:
                                                  AssetImage("assets/girl.png"),
                                            )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        FadeAnimation(
                                            1.3,
                                            Text(
                                              "Player Name",
                                              style: TextStyle( color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w400),
                                            )),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    FadeAnimation(
                                        1.4,
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 40),
                                          child: Container(
                                            child: FlatButton.icon(
                                              icon: Icon(
                                                  Icons.add_circle_outline),
                                              onPressed: () {},
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                              label: Text(
                                                "Invite Friends",
                                                style: TextStyle( color: Colors.black,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 10,
                                    ),
                                  ],
                                ))),
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
                                    bottom: BorderSide(color: Colors.black),
                                    top: BorderSide(color: Colors.black),
                                    left: BorderSide(color: Colors.black),
                                    right: BorderSide(color: Colors.black),
                                  )),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => inGame()));
                                },
                                color: Utils().getBlue(),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  "Enter Game",
                                  style: TextStyle( color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
