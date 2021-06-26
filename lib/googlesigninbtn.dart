import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:passthecup/socialbutton.dart';
import 'package:passthecup/welcome.dart';

import 'authentication.dart';

class GoogleSignInButton extends StatefulWidget {
  final Null Function(User user) onSuccess;
  final String text;

  GoogleSignInButton({this.onSuccess,  this.text});

  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : buildOutlinedButton(context),
    );
  }

  Widget buildOutlinedButton(BuildContext context) {
    return SignInButtonCustom(
      Buttons.Google,
      text: widget.text,
      onPressed: onPress,
    );
//    return OutlinedButton(
//      style: ButtonStyle(
//        backgroundColor: MaterialStateProperty.all(Colors.white),
//        shape: MaterialStateProperty.all(
//          RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(40),
//          ),
//        ),
//      ),
//      onPressed:onPress,
//      child: Padding(
//        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//        child: Row(
//          mainAxisSize: MainAxisSize.min,
//          mainAxisAlignment: MainAxisAlignment.center,
//          children: <Widget>[
//            Image(
//              image: AssetImage("assets/google_logo.png"),
//              height: 35.0,
//            ),
//            Padding(
//              padding: const EdgeInsets.only(left: 10),
//              child: Text(
//                'Sign in with Google',
//                style: TextStyle(
//                  fontSize: 20,
//                  color: Colors.black54,
//                  fontWeight: FontWeight.w600,
//                ),
//              ),
//            )
//          ],
//        ),
//      ),
//    );
  }

  onPress() async {
    var currentUser = await FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      //Authentication.customSnackBar(context, content: currentUser.displayName);
      Authentication.signOut(context: context);
      return;
    }
    setState(() {
      _isSigningIn = true;
    });

    // TODO: Add a method call to the Google Sign-In authentication

    User user =
    await Authentication.signInWithGoogle(context: context);

    setState(() {
      _isSigningIn = false;
    });

    if (user != null) {
      if (widget.onSuccess != null) {
        widget.onSuccess.call(user);
      }
//                  Navigator.of(context).pushReplacement(
//                    MaterialPageRoute(
//                      builder: (context) {
//                        return Welcome();
//                      },
//                    ),
//                  );
    }
    setState(() {
      _isSigningIn = false;
    });
  }
}
