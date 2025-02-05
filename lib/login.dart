import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/socialbutton.dart';
import 'package:passthecup/utils.dart';
import 'package:passthecup/welcome.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'authentication.dart';
import 'googlesigninbtn.dart';

class LoginPage extends StatefulWidget {

  LoginPage();

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _email, _password;

  bool showloading = false;

  //Todo : navigate to sign up
  navigateToSignUpScreen() {
    Navigator.pushReplacementNamed(context, '/signup');
  }

  //Todo : check if already authenticated
  checkAuthentication() async {
    _auth.authStateChanges().listen((user) async {
//      if (user != null) {
//        Navigator.pushReplacementNamed(context, '/decide');
//      }
    });
  }

  //Todo : Check form state and sign in
  void signin() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        Utils().showAlertDialog(context);
        UserCredential user = await _auth.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Navigator.pop(context);
        Navigator.of(context).pushReplacement(new MaterialPageRoute<Welcome>(
          builder: (BuildContext context) {
            return new Welcome();
          },
        ));
      } catch (e) {
//        showError(e);
        Navigator.pop(context);
        Utils().showToast("Wrong credentials", context);
      }
    }
  }

  void signinFB() async {
    try {
      Utils().showAlertDialog(context);
      UserCredential user = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(new MaterialPageRoute<Welcome>(
        builder: (BuildContext context) {
          return new Welcome();
        },
      ));
    } catch (e) {
//        showError(e);
      Navigator.pop(context);
      Utils().showToast(
          "No account found for $_email. Please Sign up first", context);
    }
  }

//  void signinGoogle(User userobj) async {
//    if (_formKey.currentState.validate()) {
//      _formKey.currentState.save();
//      try {
//        Utils().showAlertDialog(context);
//        UserCredential user = await _auth.signInWithEmailAndPassword(
//          email: userobj.email,
//          password: ,
//        );
//        Navigator.pop(context);
//        Navigator.of(context).pushReplacement(new MaterialPageRoute<Welcome>(
//          builder: (BuildContext context) {
//            return new Welcome();
//          },
//        ));
//      } catch (e) {
////        showError(e);
//        Navigator.pop(context);
//        Utils().showToast("Wrong credentials", context);
//      }
//    }
//  }

  //Todo : Show errors in login
  showError(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(message),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    setState(() {
//      _email = "ayush@gmail.com";
//      _password = "123456";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
      body: SingleChildScrollView(
        child: Container(
            color: Utils().getBGColor(),
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  FadeAnimation(
                      1.2,
                      Container(
                        height: 150,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage('assets/logo.png'),
                                fit: BoxFit.contain)),
                      )),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 5,
                            ),
                            FadeAnimation(
                                1.2,
                                Text(
                                  "Login to your account",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                )),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 40, right: 40),
                          child: Column(
                            children: <Widget>[
                              FadeAnimation(
                                  1.2,
                                  makeInput(
//                                      defaultvalue: "ayushmehre@gmail.com",
                                      label: "Email",
                                      message: "Provide an email",
                                      onSave: _email)),
                              FadeAnimation(
                                  1.3,
                                  makeInput(
//                                      defaultvalue: "123456",
                                      label: "Password",
                                      obscureText: true,
                                      message: "Provide password",
                                      onSave: _password)),
                            ],
                          ),
                        ),
                        FadeAnimation(
                            1.4,
                            Padding(
                              padding: EdgeInsets.only(left: 40, right: 40),
                              child: Container(
                                padding: EdgeInsets.only(top: 3, left: 3),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.transparent),
                                      top:
                                          BorderSide(color: Colors.transparent),
                                      left:
                                          BorderSide(color: Colors.transparent),
                                      right:
                                          BorderSide(color: Colors.transparent),
                                    )),
                                child: MaterialButton(
                                  minWidth: double.infinity,
                                  height: 60,
                                  onPressed: signin,
                                  color: Colors.redAccent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                            )),
                        FadeAnimation(
                            1,
                            Column(
                              children: [
                                getGoogleSigninButton(),
                                getFBSigninButton(),
                              ],
                            )),
                        FadeAnimation(
                            1.5,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Don't have an account?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                FlatButton(
                                  onPressed: navigateToSignUpScreen,
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  ),
                                )
                              ],
                            )),
                        FadeAnimation(
                          1,
                          Image.asset(
                            "assets/sagames_full.png",
                            height: 50,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  getGoogleSigninButton() {
    return FutureBuilder(
      future: Authentication.initializeFirebase(context: context),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error initializing Firebase');
        } else if (snapshot.connectionState == ConnectionState.done) {
          return GoogleSignInButton(
            onSuccess: (user) {
              onGoogleSignInSuccess(user);
            },
          );
        }
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white,
          ),
        );
      },
    );
  }

//  //Todo : input taker
//  Widget makeInput(
//      {label, obscureText = false, message, onSave, defaultvalue = ""}) {
//    return Column(
//      crossAxisAlignment: CrossAxisAlignment.start,
//      children: <Widget>[
//        Text(
//          label,
//          style: TextStyle(
//              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
//        ),
//        SizedBox(
//          height: 5,
//        ),
//        TextFormField(
//          controller: new TextEditingController(text: defaultvalue),
//          obscureText: obscureText,
//          validator: (input) {
//            if (input.isEmpty) {
//              return message;
//            }
//          },
//          decoration: InputDecoration(
//            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
//            enabledBorder: OutlineInputBorder(
//                borderSide: BorderSide(color: Colors.grey[400])),
//            border: OutlineInputBorder(
//                borderSide: BorderSide(color: Colors.grey[400])),
//          ),
//          onSaved: (input) {
//            setState(() {
//              switch (label) {
//                case "Email":
//                  _email = input;
//                  break;
//                case "Password":
//                  _password = input;
//                  break;
//              }
//            });
//          },
//        ),
//        SizedBox(
//          height: 30,
//        ),
//      ],
//    );
//  }

  Widget makeInput({label, obscureText = false, message, onSave}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
              fontSize: 15, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        SizedBox(
          height: 5,
        ),
        TextFormField(
          obscureText: obscureText,
          validator: (input) {
            if (input.isEmpty) {
              return message;
            }
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
            border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[400])),
          ),
          onSaved: (input) {
            setState(() {
              switch (label) {
                case "Email":
                  _email = input;
                  break;
//                case "Name":
//                  _name = input;
//                  break;
                case "Password":
                  _password = input;
                  break;
              }
            });
          },
        ),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }

  Widget getFBSigninButton() {
    return SignInButtonCustom(
      Buttons.FacebookNew,
      onPressed: () async {
        final LoginResult result = await FacebookAuth.instance.login(
            loginBehavior: LoginBehavior
                .nativeWithFallback); // by default we request the email and the public profile
        if (result.status == LoginStatus.success) {
          // you are logged
          final AccessToken accessToken = result.accessToken;
          final userData = await FacebookAuth.instance.getUserData();
          if (userData['email'] == null) {
            showError(
                'Your email cannot be accessed because of you Facebook Privacy settings.');
          } else {
            String email = userData['email'];
            String name = userData['name'];
            setState(() {
              _email = email;
              _password = '123456';
            });
            signinFB();
          }
        } else {
          showError(result.message.toString());
        }
      },
    );
  }

  Future<void> onGoogleSignInSuccess(User user) async {
    setState(() {
      showloading = true;
    });

    Utils().showLoaderDialog(context);

    var querySnapshot = await FirebaseFirestore.instance
        .collection("user")
        .where('email', isEqualTo: user.email)
        .get();
    Navigator.pop(context);
    setState(() {
      showloading = false;
    });

    if (querySnapshot.docs.length == 0) {
      var list = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data();
        list.add(data);
      }
      showError(
          'No Account found for ${user.email}. Please try signing up instead');
      Authentication.signOut(context: context);
      return;
    }
    Navigator.pop(context);
    Navigator.of(context).pushReplacement(new MaterialPageRoute<Welcome>(
      builder: (BuildContext context) {
        return new Welcome();
      },
    ));
  }
}
