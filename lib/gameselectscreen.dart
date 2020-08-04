import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

import 'api.dart';
import 'model/gameObject.dart';
import 'model/teamobject.dart';

class GameSelectScreen extends StatefulWidget {
  final TeamObject currenteam;

  GameSelectScreen({this.currenteam});

  @override
  _GameSelectScreenState createState() => _GameSelectScreenState(currenteam);
}

class _GameSelectScreenState extends State<GameSelectScreen> {
  Future<List<GameObject>> futureResult;
  List<String> days;
  List<GameObject> gamesList;
  bool fetching;
  TeamObject currenteam;

  _GameSelectScreenState(this.currenteam);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureResult = API().fetchGames().then((value) {
      List<GameObject> filtered = getByTeam(value);
      setState(() {
        gamesList = filtered;
        fetching = false;
      });
      return null;
    });
    setState(() {
      fetching = true;
      gamesList = List<GameObject>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Game"),
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    if (fetching) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Container(
        padding: EdgeInsets.all(4),
        color: Hexcolor("#eeeeee"),
        child: ListView.builder(
            itemCount: gamesList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, gamesList[index]);
                },
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.all(4),
                  child: ListTile(
                    title: getTitleText(index),
                    subtitle: getSubTitleText(index),
                  ),
                ),
              );
            }),
      );
    }
  }

  Text getTitleText(int index) {
    bool before =
    getDateTime(gamesList[index].dateTime).isBefore(DateTime.now());
    return Text(
                    gamesList[index].awayTeam +
                        " vs." +
                        gamesList[index].homeTeam +(before?" (Simulated)":""),
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  );
  }

  Text getSubTitleText(int index) {
    bool before =
        getDateTime(gamesList[index].dateTime).isBefore(DateTime.now());
    return Text(
      getinUserFormat(gamesList[index].dateTime) +
          ", " +
          getinDayUserFormat(gamesList[index].day),
      style: TextStyle(color: before ? Colors.red : null),
    );
  }

  String getinUserFormat(String eventDate) {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd'T'hh:mm:ss");
    DateTime parse = dateFormat.parse(eventDate);
    return new DateFormat("dd MMM, hh:mm a").format(parse);
  }

  String getinDayUserFormat(String eventDate) {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd'T'hh:mm:ss");
    DateTime parse = dateFormat.parse(eventDate);
    return new DateFormat("EEEE").format(parse);
  }

  List<GameObject> getByTeam(List<GameObject> value) {
    if (currenteam != null) {
      List<GameObject> filtered = List<GameObject>();
      for (GameObject object in value) {
        if (object.awayTeamID == currenteam.teamID ||
            object.homeTeamID == currenteam.teamID) {
          var dateTimeGame = getDateTime(object.dateTime);
          var dateTimeNow = DateTime.now();
//          if (dateTimeGame.isAfter(dateTimeNow)) {
          filtered.add(object);
//          }
        }
      }
      return filtered;
    } else {
      return value;
    }
  }

  DateTime getDateTime(String eventDate) {
    DateFormat dateFormat = new DateFormat("yyyy-MM-dd'T'hh:mm:ss");
    DateTime parsed = dateFormat.parse(eventDate);
    return parsed;
  }
}
