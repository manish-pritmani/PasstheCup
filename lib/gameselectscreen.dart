import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
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

  bool showPastGames;

  String _timezone;

  _GameSelectScreenState(this.currenteam);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlatformState();
    futureResult = API().fetchGames().then((value) {
      List<GameObject> filtered = getByTeam(value);
      setState(() {
        gamesList = filtered;
        fetching = false;
      });
      return null;
    });
    setState(() {
      showPastGames = false;
      fetching = true;
      gamesList = List<GameObject>();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String timezone;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      timezone = await FlutterNativeTimezone.getLocalTimezone();
    } on PlatformException {
      timezone = 'Failed to get the timezone.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _timezone = timezone;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a Game"),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                showPastGames = !showPastGames;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:
                  Center(child: Text(!showPastGames ? "Show past games" : "Hide past games")),
            ),
          )
        ],
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
              bool before = getDateTime(gamesList[index].dateTime)
                  .isBefore(DateTime.now());
              return Visibility(
                visible: !before || showPastGames,
                child: GestureDetector(
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
          gamesList[index].homeTeam +
          (before ? " (Simulated)" : ""),
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
