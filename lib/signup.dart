import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:passthecup/animation/animation_controller.dart';
import 'package:passthecup/main.dart';
import 'package:passthecup/socialbutton.dart';
import 'package:passthecup/utils.dart';
import 'package:passthecup/welcome.dart';

import 'authentication.dart';
import 'googlesigninbtn.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _name, _email, _password;

  bool showloading = false;

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    });
  }

  navigateToSignInScreen() {
    Navigator.pushReplacementNamed(context, '/signin');
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentication();
    setState(() {
      _name = "ayush mehre";
      _email = "ayushmehre@gmail.com";
      _password = "123456";
    });
  }

  signup() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        Utils().showAlertDialog(context);
        UserCredential user = await _auth.createUserWithEmailAndPassword(
          email: _email,
          password: _password,
        );
        Navigator.pop(context);
        if (user != null) {
          onSignupSuccess(user);
        }
      } catch (e) {
        Navigator.pop(context);
        showError(e.toString());
      }
    }
  }

  Future onSignupSuccess(UserCredential user) async {
    FirebaseFirestore.instance.collection("user").doc(_email).set({
      "score": 100,
      "name": _name,
      "email": _email,
      "password": _password,
      "gamerUid": user.user.uid,
      "createdOn": DateTime.now().toString(),
    });
    //          UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    //          userUpdateInfo.displayName = _name;
    //          user.user.updateProfile(userUpdateInfo);
    await FirebaseAuth.instance.currentUser.updateProfile(displayName: _name);
    Navigator.of(context).push(new MaterialPageRoute<Welcome>(
      builder: (BuildContext context) {
        return new Welcome();
      },
    ));
  }

  Future onSignupSuccessGoogle(User user) async {
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

    if (querySnapshot.docs.length > 0) {
      var list = [];
      for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
        var data = documentSnapshot.data();
        list.add(data);
      }
      showError(
          'It seems like you already have an account with ${user
              .email}. Please try logging in instead');
      return;
    }

    await FirebaseFirestore.instance.collection("user").doc(user.email).set({
      "score": 100,
      "name": user.displayName,
      "email": user.email,
      "password": 'googlesignin',
      "gamerUid": user.uid,
      "createdOn": DateTime.now().toString(),
    });
    //          UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    //          userUpdateInfo.displayName = _name;
    //          user.user.updateProfile(userUpdateInfo);
    await FirebaseAuth.instance.currentUser
        .updateProfile(displayName: user.displayName);
    Navigator.of(context).push(new MaterialPageRoute<Welcome>(
      builder: (BuildContext context) {
        return new Welcome();
      },
    ));
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
                color: Utils().getBGColor(),
                padding: EdgeInsets.symmetric(horizontal: 40),
                width: double.maxFinite,
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            FadeAnimation(
                                1,
                                Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            FadeAnimation(
                                1.2,
                                Text(
                                  "Create an account, It's free",
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.black),
                                )),
                          ],
                        ),
                        Column(
                          children: <Widget>[
                            FadeAnimation(
                                1.2,
                                makeInput(
                                    label: "Name",
                                    message: "Provide a name",
                                    onSave: _name)),
                            FadeAnimation(
                                1.2,
                                makeInput(
                                    label: "Email",
                                    message: "Provide email",
                                    onSave: _email)),
                            FadeAnimation(
                                1.3,
                                makeInput(
                                    label: "Password",
                                    obscureText: true,
                                    message: "Provide password",
                                    onSave: _password)),
                          ],
                        ),
                        FadeAnimation(
                            1.5,
                            Container(
                              padding: EdgeInsets.only(top: 3, left: 3),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  border: Border(
                                    bottom:
                                    BorderSide(color: Colors.transparent),
                                    top: BorderSide(color: Colors.transparent),
                                    left: BorderSide(color: Colors.transparent),
                                    right:
                                    BorderSide(color: Colors.transparent),
                                  )),
                              child: MaterialButton(
                                minWidth: double.infinity,
                                height: 60,
                                onPressed: signup,
                                color: Colors.redAccent,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50)),
                                child: Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 10,
                        ),
                        FadeAnimation(
                            1,
                            Column(
                              children: [
                                getGoogleSigninButton(),
                                getFBSigninButton(),
                              ],
                            )),
                        FadeAnimation(
                            1.6,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "Already have an account?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                FlatButton(
                                  onPressed: navigateToSignInScreen,
                                  child: Text(
                                    " Login",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18),
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
                    ))),
          ),
        ],
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
          return GoogleSignInButton(onSuccess: (user) {
            onSignupSuccessGoogle(user);
          },  text: 'Sign up using Google',);
        }
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Utils().getBlue(),
          ),
        );
      },
    );
  }

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
            return null;
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
                case "Name":
                  _name = input;
                  break;
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
      text: 'Sign up using Facebook',
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
              _name= name;
            });
            signupFB();
          }
        } else {
          showError(result.message.toString());
        }
      },
    );
  }

  signupFB() async {
    try {
      Utils().showAlertDialog(context);
      UserCredential user = await _auth.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );
      Navigator.pop(context);
      if (user != null) {
        onSignupSuccess(user);
      }
    } catch (e) {
      await FacebookAuth.instance.logOut();
      Navigator.pop(context);
      if(e.toString().contains('email-already-in-use')){
        showError('Account already exists with email $_email. Please Log in instead.');
      }else{
        showError(e.toString());
      }
    }
  }
}
