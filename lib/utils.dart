import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Utils{
  Color getBGColor() {
    return Hexcolor("#ffffff");
  }

  showAlertDialog(BuildContext context){
    AlertDialog alert=AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5),child:Text("Loading" )),
        ],),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }

  Color getBlue() {
    return  Hexcolor("#304ffe");
  }

  showToast(String text, BuildContext context, {Function() ok}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
//          title: new Text("Message"),
          content: new Text(text),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                if (ok != null) {
                  ok();
                }
              },
            ),
//            CupertinoDialogAction(
//              child: Text("No"),
//            )
          ],
        ));
  }

}