import 'package:flutter/material.dart';

import 'utils.dart';

class ScoreBoard extends StatefulWidget {
  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  Color positiveColor = Colors.green[00];
  Color negitiveColor = Colors.red[00];
  Color neutralColor = Colors.blueGrey[00];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Utils().getBlue(),
        title: Text("Score Board"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(0.0),
                child: Card(
                  elevation: 0,
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    child: Table(
                      children: [
                        TableRow(children: [
                          GetRowWidget(
                              text: "Results",
                              Point: "Points",
                              RowColors: Colors.white,
                              bg: true,
                              score: 1000,
                              isHeading: true),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Sacrifice",
                              Point: "0",
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Stolen Base",
                              Point: "0",
                              bg: true,
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Hit by Pitch",
                              Point: "1",
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Intentional Walk",
                              Point: "1",
                              bg: true,
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Single",
                              Point: "2",
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              bg: true,
                              text: "Double",
                              Point: "2",
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "RBI*",
                              Point: "2",
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Triple*",
                              bg: true,
                              Point: "5",
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Home Run",
                              Point: "Cup Cleared",
                              score: 1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Fielder's Choice",
                              bg: true,
                              Point: "-1",
                              score: -1,
                              RowColors: positiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Fly Out",
                              score: -1,
                              Point: "-1",
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Foul Out",
                              bg: true,
                              score: -1,
                              Point: "-1",
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Ground Out",
                              Point: "-1",
                              score: -1,
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Lineout",
                              bg: true,
                              Point: "-1",
                              score: -1,
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Pop Out",
                              Point: "-1",
                              score: -1,
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Strikeout Looking",
                              bg: true,
                              Point: "-2",
                              score: -1,
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Strikeout Swinging",
                              Point: "-2",
                              score: -1,
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Ground Into Double Play*",
                              bg: true,
                              Point: "-2",
                              score: -1,
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Line into Double Play",
                              Point: "-2",
                              score: -1,
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Line into Triple Play",
                              bg: true,
                              Point: "-5",
                              score: -1,
                              RowColors: negitiveColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Error",
                              Point: "0",
                              RowColors: neutralColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Catcher's Interference",
                              Point: "0",
                              bg: true,
                              RowColors: neutralColor),
                        ]),
                        TableRow(children: [
                          GetRowWidget(
                              text: "Sacrifice Fly",
                              Point: "0",
                              RowColors: neutralColor),
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget GetRowWidget(
      {String text,
      String Point,
      Color RowColors,
      bool isHeading = false,
      bool bg = false,
      int score = 0}) {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 0.0),
          padding: EdgeInsets.only(left: 16, top:10, bottom: 10, right: 16),
          decoration: BoxDecoration(
              color: bg ? Colors.grey[200] : Colors.white,
              //isHeading == true ? Colors.white : RowColors,
              borderRadius: BorderRadius.circular(0.0)),
          child: Row(
            children: [
              Text(
                text,
                style: TextStyle(
                    color: isHeading == true ? Colors.black : Colors.black,
                    fontSize: isHeading == true ? 20 : 16,
                    fontWeight: isHeading ? FontWeight.bold : FontWeight.w400),
              ),
              Spacer(),
              Text(
                Point,
                style: TextStyle(
                    color: isHeading == true ? Colors.black : Colors.black,
                    fontSize: isHeading == true ? 20 : 16,
                    fontWeight: isHeading ? FontWeight.bold : FontWeight.w400),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            color: getColor(score),
            width: 5,
            height: 40,
          ),
        ),
      ],
    );
  }

  Color getColor(int score) {
    if(score==1000){
      return Colors.white.withOpacity(0);
    }
    try {
      int i = score; //int.parse(score);
      if (i > 0) {
        return Colors.green;
      } else if (i < 0) {
        return Colors.red;
      } else {
        return Colors.blue[200];
      }
    } on Exception catch (e) {
      // TODO
    }

    return Colors.transparent;
  }
}
