import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/login.dart';
import 'package:passthecup/signup.dart';
import 'package:passthecup/utils.dart';
import 'package:passthecup/welcome.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
    routes: {
      //Todo : created routes for quick navigation within app
      '/decide': (BuildContext context)=> HomePage(),

      '/signin': (BuildContext context)=> LoginPage(),

      '/signup': (BuildContext context)=> SignupPage(),

      '/welcome': (BuildContext context)=> Welcome(),
    },
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var borderColor = Colors.transparent;
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Utils().getBGColor(),
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "Pass the Cup",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 40),
                      )
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.2,
                      Text(
                        "Glad to see you here. Join Now",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: borderColor, fontSize: 15),
                      )),
                ],
              ),
              FadeAnimation(
                  1.4,
                  Container(
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/logo.png'))),
                  )),
              Column(
                children: <Widget>[
                  FadeAnimation(
                      1.5,
                      Container(
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
                                    builder: (context) => LoginPage()));
                          },
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          color:Utils().getBlue(),
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  ),
                  FadeAnimation(
                      1.6,
                      Container(
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
                                    builder: (context) => SignupPage()));
                          },
                          color: Colors.red,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "Sign up",
                            style: TextStyle( color: Colors.white,
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top:32.0),
                    child: Image.asset(
                      "assets/sagames_full.png",
                      height: 70,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
