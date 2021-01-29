import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/model/firebasegameObject.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'utils.dart';

class LogScreen extends StatefulWidget {
  final FirebaseGameObject gameObject;

  LogScreen(this.gameObject);

  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  List<DocumentSnapshot> docs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchLogs();
  }

  void fetchLogs() async {
    Query query = Firestore.instance
        .collection("snapshots")
        .where("gameId", isEqualTo: widget.gameObject.gameCode)
        .orderBy("time", descending: true);

    query.snapshots(includeMetadataChanges: false).listen((event) {
      setState(() {
        docs = event.documents.reversed.toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Play by Play Data: ${widget.gameObject.gameCode}"),
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        // color: Colors.black87,
        child: docs == null
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
          itemBuilder: (ctx, index) {
            return getListItem(index);
          },
          itemCount: docs?.length ?? 0,
        ),
      ),
    );
  }

  Widget getListItem(int index) {
    var edoc = docs[index];
    var data2 = edoc.data["data"];
    var dateTime =
    DateTime.fromMillisecondsSinceEpoch(edoc["time"], isUtc: true)
        .add(Duration(hours: 5, minutes: 30));
    var format = new DateFormat("hh:mm:ss a, dd MMM yyyy").format(dateTime);
    var string =
    // "Last Result: ${data2["lastResult"]}"
    //"\nPoints awarded: ${data2["lastResultPointsAwarded"]}"
        "Cup Score: ${data2["cupScore"]}\n${getAllPlayersScore(
        data2["players"], data2["currentActivePlayer"])}";
    String inning = data2["selectedGame"]["Inning"].toString() +
        data2["selectedGame"]["InningHalf"].toString();
    int lastPointsAwarded = data2["lastResultPointsAwarded"];
    return Padding(
      padding: EdgeInsets.only(left: 16),
      child: TimelineTile(
        alignment: TimelineAlign.start,

        indicatorStyle: IndicatorStyle(
          width: 40,
          height: 35,
          padding: const EdgeInsets.all(8),
          indicator: Container(
            decoration: BoxDecoration(
              color: getColor2(lastPointsAwarded),
              border: Border.fromBorderSide(
                BorderSide(
                  color: Colors.white,
                ),
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                inning,
                style: TextStyle(
                    color: getColor3(lastPointsAwarded),
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
        ),
        endChild: Card(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 12, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(string, style: TextStyle(fontSize: 16),),
                    Text("$format",
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0, top: 8, bottom: 8,),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("$lastPointsAwarded", style: TextStyle(fontSize: 24,
                          fontWeight: FontWeight.bold, color: getColor(
                              lastPointsAwarded)),),
                      Text("${data2["lastResult"]}", style: TextStyle(color: getColor(lastPointsAwarded)),),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        // subtitle: Text("$format"),
        // title: Text(string),
        // isThreeLine: true,
      ),
    );
  }

  Color getColor(int lastPointsAwarded) {
    if (lastPointsAwarded > 0) {
      return Colors.green;
    } else if (lastPointsAwarded < 0) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }

  Color getColor2(int lastPointsAwarded) {
    if (lastPointsAwarded > 0) {
      return Colors.green[400];
    } else if (lastPointsAwarded < 0) {
      return Colors.red[400];
    } else {
      return Colors.grey[300];
    }
  }

  Color getColor3(int lastPointsAwarded) {
    if (lastPointsAwarded > 0) {
      return Colors.white;
    } else if (lastPointsAwarded < 0) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  String getAllPlayersScore(List players, int activePlayer) {
    String string = "";
    int index = 0;
    for (Map p in players) {
      string = string + p["name"] + ": " + p["gamescore"].toString();
      if (index + 1 == activePlayer) {
        string = string + " (Points Awarded)";
      }
      string = string + "\n";
      index++;
    }
    return string;
  }
}
