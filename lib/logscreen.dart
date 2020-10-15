import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/model/firebasegameObject.dart';

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
        docs = event.documents;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logs for Game: ${widget.gameObject.gameCode}"),
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        color: Colors.black87,
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
    var string = "Innings: ${data2["selectedGame"]["Inning"]}${data2["selectedGame"]["InningHalf"]}\nLast Result: ${data2["lastResult"]}"
        "\nPoints awarded: ${data2["lastResultPointsAwarded"]}"
        "\nCupScore: ${data2["cupScore"]}\n${getAllPlayersScore(data2["players"], data2["currentActivePlayer"])}";
    return Card(
      child: Padding(
        padding: EdgeInsets.all(4),
        child: ListTile(
          subtitle: Text("$format"),
          title: Text(string),
          isThreeLine: true,
        ),
      ),
    );
  }

 String getAllPlayersScore(List players, int activePlayer) {
    String string = "";
    int index = 0;
    for(Map p in players){
      string = string + p["name"]+": "+ p["gamescore"].toString();
      if(index+1==activePlayer){
        string = string+" (Points Awarded)";
      }
      string = string+"\n";
      index++;
    }
    return string;
 }
}
