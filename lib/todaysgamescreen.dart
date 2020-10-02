import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:passthecup/model/gameObject.dart';
import 'package:passthecup/utils.dart';

import 'api.dart';
import 'model/teamobject.dart';

class TodaysGameScreen extends StatefulWidget {
  @override
  _TodaysGameScreenState createState() => _TodaysGameScreenState();
}

class _TodaysGameScreenState extends State<TodaysGameScreen> {
  Future<List<GameObject>> futureResult;
  List<GameObject> gamesList;
  bool fetching;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureResult = API().fetchGames().then((value) {
      setState(() {
        gamesList = value;
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
          title: Text("Today's Game"),
          leading: NavBackButton(),
        ),
        body: getBody());
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
             // bool before = gamesList[index].status == "Final";
              return Visibility(
                child: GestureDetector(
                  onTap: () {
                    if (gamesList[index].status!="Canceled") {
                      Navigator.pop(context, gamesList[index]);
                    } else {
                      Utils().showToast("Canceled games cannot be selected", context);
                    }
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
    return Text(
      gamesList[index].awayTeam +
          " vs." +
          gamesList[index].homeTeam +
          "   (" +
          gamesList[index].status +
          ")",
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  Text getSubTitleText(int index) {
    bool before = gamesList[index].status == "Final";
    return Text(
      getinUserFormat(gamesList[index].dateTime) +
          ", " +
          getinDayUserFormat(gamesList[index].day),
      style: TextStyle(color: before ? Colors.red : null),
    );
  }
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

class NavBackButton extends StatelessWidget {
  const NavBackButton({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {Navigator.pop(context)},
      child: Icon(
        Icons.arrow_back_ios,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}
