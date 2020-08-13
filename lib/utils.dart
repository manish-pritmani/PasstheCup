import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Utils {
  Color getBGColor() {
    return Hexcolor("#ffffff");
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(margin: EdgeInsets.only(left: 5), child: Text("Loading")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Color getBlue() {
    return Hexcolor("#304ffe");
  }

  showToast(String text, BuildContext context,
      {Function() ok,
      bool cancel = false,
      String oktext = "OK",
      String noText = "Cancel"}) {
    showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
//          title: new Text("Message"),
              content: new Text(text),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: !cancel,
                  child: Text(oktext),
                  onPressed: () {
                    Navigator.pop(context);
                    if (ok != null) {
                      ok();
                    }
                  },
                ),
                cancel
                    ? CupertinoDialogAction(
                        child: Text(noText),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    : null,
              ],
            ));
  }

  showLoaderDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          CircularProgressIndicator(),
          Container(
              margin: EdgeInsets.only(left: 7), child: Text("Loading...")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
