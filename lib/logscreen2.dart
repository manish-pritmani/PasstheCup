import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/model/firebasegameObject.dart';
import 'package:timeline_tile/timeline_tile.dart';

import 'utils.dart';

class LogScreen2 extends StatefulWidget {
  final FirebaseGameObject gameObject;

  LogScreen2(this.gameObject);

  @override
  _LogScreen2State createState() => _LogScreen2State();
}

class _LogScreen2State extends State<LogScreen2> {
//  List<DocumentSnapshot> docs;

  FirebaseGameObject gameObject;
  StreamSubscription<DocumentSnapshot> listen;

  Map<String, dynamic> data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchLogs();
  }

  void fetchLogs() async {
    listen = FirebaseFirestore.instance
        .collection('games')
        .doc(widget.gameObject.gameCode.toString())
        .snapshots(includeMetadataChanges: true)
        .listen((event) {
      if (event.data() != null) {
        setState(() {
          gameObject = FirebaseGameObject.fromJson(event.data());
          data = event.data();
        });
      } else {
        print(event.toString());
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    listen?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    for(var data2 in data["pointsAwarded"]){
     try{
       print(data2["Inning"].toString()+":"+data2["Result"] + ": " + data2["points"].toString());
     }catch(e){
      print(e.toString());
     }
    }

    var length2 = data['pointsAwarded']?.length ?? 0;
    return Scaffold(
      appBar: AppBar(
        title:
            Text("Play by Play: ${widget.gameObject.gameCode}"),
      ),
      body: Container(
        padding: EdgeInsets.all(4),
        // color: Colors.black87,
        child: gameObject == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemBuilder: (ctx, index) {
                  return getListItem(index);
                },
                itemCount: length2 ?? 0,
              ),
      ),
    );
  }

  Widget getListItem(int index) {
    var edoc = data['pointsAwarded'];
    var data2 = edoc[index];


//    var dateTime =
//        DateTime.fromMillisecondsSinceEpoch(edoc["time"], isUtc: true)
//            .add(Duration(hours: 5, minutes: 30));
//    var format = new DateFormat("hh:mm:ss a, dd MMM yyyy").format(dateTime);
//    var string =
//        // "Last Result: ${data2["lastResult"]}"
//        //"\nPoints awarded: ${data2["lastResultPointsAwarded"]}"
//        "Cup Score: ${data2["cupScore"]}\n${getAllPlayersScore(data2["players"], data2["currentActivePlayer"])}${data2['selectedGame']['CurrentHitter']}\n";
//    String inning = data2["selectedGame"]["Inning"].toString() +
//        data2["selectedGame"]["InningHalf"].toString();
    int lastPointsAwarded = data2["points"];

    String playersscrore = '';

//    for (var v = 0; v < data2['players']?.length??0; v++) {
//      playersscrore =
//          playersscrore + '\n' + data2['players'][v]['name'] + ': ' +
//              data2['players'][v]['gamescore2'].toString();
//      var index = v+1;
//      if(index<0 || index>=data2['players'].length){
//        index = 0;//data2['players'].length-1;
//      }
//      if (data2['email']==data2['players'][index]['email']) {
//          playersscrore  = playersscrore + ' 👈';
//      }
//    }
   try{
     playersscrore = data2['name'] +
//         ' (' +
//         data2['email'] +
         ' was awarded ' +
         data2['points'].toString();
   }catch(e){
     playersscrore = '';
   }

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
                data2['Inning'].toString() + '',
                style: TextStyle(
                    color: getColor3(lastPointsAwarded),
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
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
                Container(
                  width: 180,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
//                      Text(
//                        'LatestPlayID: ' + data2['lastPlayID'].toString(),
//                        style: TextStyle(fontWeight: FontWeight.bold),
//                      ),
                      Text(
                        'PlayID: ' + data2['PlayID'].toString(),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Cupscore: ' + data2['cupscore'].toString(),
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        playersscrore.toString().trim(),
                        style: TextStyle(fontSize: 16),
                      ),
//                      Flexible(
//                        child: Text(
//                          data2['lastResult'].toString(),
//                          style: TextStyle(fontSize: 12),
//                        ),
//                      ),
                      Text(data2['Description'].toString() + '',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Container(
                  width: 100,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      right: 16.0,
                      top: 8,
                      bottom: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          ("$lastPointsAwarded").toString(),
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: getColor(lastPointsAwarded)),
                        ),
                        Text(
                          ("${data2['Result']}").toString(),
                          style: TextStyle(
                              color: getColor(lastPointsAwarded), fontSize: 14),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
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
    //return Text('khsfghjkshgk');
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
    if (activePlayer == 0) {
      activePlayer = players.length;
    }
    String string = "";
    int index = 1;
    for (Map p in players) {
      string = string + p["name"] + ": " + p["gamescore"].toString();
      if (index == activePlayer) {
        string = "" + string + " 👈"; // " (Points Awarded)";
      } else {
        print(activePlayer.toString());
      }
      string = string + "\n";
      index++;
    }
    return string;
  }
}
