import 'package:flutter/material.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:passthecup/utils.dart';

class SampleScreen extends StatefulWidget {
  SampleScreen() : super();

  @override
  State<StatefulWidget> createState() => _SampleScreenState();
}

class _SampleScreenState extends State<SampleScreen>
    with PortraitStatefulModeMixin<SampleScreen> {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Utils().getBGColor(),
      body: SafeArea(
          child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                                      color: Colors.amberAccent),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                      )
                                    ],
                                  ))),
                        ),
                        Column(
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )),
                            FadeAnimation(
                                1,
                                Text(
                                  "ERA     ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                                      color: Colors.amberAccent),
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(
                                        height: 100,
                                        width: 100,
                                      )
                                    ],
                                  ))),
                        ),
                        Column(
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  "Name",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500),
                                )),
                            FadeAnimation(
                                1,
                                Text(
                                  "Battling",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w400),
                                )),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
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
                              color: Colors.amberAccent),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "Pitch 1",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "Strike",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "Pitch 2",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "Strike",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "Pitch 3",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "Strike",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              Divider(),
                              Row(
                                children: <Widget>[
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "Pitch 4",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "Strike",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  FadeAnimation(
                                      1.3,
                                      Text(
                                        "4.",
                                        style: TextStyle(
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
                                        "Ayush Mehre",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ))),
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.amberAccent),
                                  child: Column(
                                    children: <Widget>[
                                      FadeAnimation(
                                          1,
                                          Text(
                                            "3",
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  ))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.tealAccent),
                                  child: Column(
                                    children: <Widget>[
                                      FadeAnimation(
                                          1,
                                          Text(
                                            "7th",
                                            style: TextStyle(
                                                fontSize: 25,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  ))),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Colors.amberAccent),
                                  child: Column(
                                    children: <Widget>[
                                      FadeAnimation(
                                          1,
                                          Text(
                                            "3",
                                            style: TextStyle(
                                                fontSize: 40,
                                                fontWeight: FontWeight.w400),
                                          )),
                                    ],
                                  ))),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.3,
                        CircleAvatar(
                          maxRadius: 20,
                          backgroundImage: AssetImage("assets/girl.png"),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Player",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "45 Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.3,
                        CircleAvatar(
                          maxRadius: 20,
                          backgroundImage: AssetImage("assets/girl.png"),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Player",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "100 Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.3,
                        CircleAvatar(
                          maxRadius: 20,
                          backgroundImage: AssetImage("assets/girl.png"),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Player",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "39 Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.3,
                        CircleAvatar(
                          maxRadius: 20,
                          backgroundImage: AssetImage("assets/girl.png"),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Player",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "480 Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.3,
                        CircleAvatar(
                          maxRadius: 20,
                          backgroundImage: AssetImage("assets/girl.png"),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Player",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "96 Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  children: <Widget>[
                    FadeAnimation(
                        1.3,
                        CircleAvatar(
                          maxRadius: 20,
                          backgroundImage: AssetImage("assets/girl.png"),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "Player",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w400),
                        )),
                    FadeAnimation(
                        1.3,
                        Text(
                          "269 Points",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w400),
                        )),
                  ],
                ),
              ],
            )
          ],
        ),
      )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

mixin PortraitStatefulModeMixin<T extends StatefulWidget> on State<T> {
  @override
  Widget build(BuildContext context) {
    _portraitModeOnly();
    return null;
  }

  @override
  void dispose() {
    _enableRotation();
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
