import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
//import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';

import 'api.dart';
import 'model/teamobject.dart';

class TeamSelectScreen extends StatefulWidget {
  @override
  _TeamSelectScreenState createState() => _TeamSelectScreenState();
}

class _TeamSelectScreenState extends State<TeamSelectScreen> {
  Future<List<TeamObject>> futureResult;
  List<TeamObject> teamsList;
  bool fetching;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    futureResult = API().fetchTeams().then((value) {
      setState(() {
        teamsList = value;
        fetching = false;
      });
      return null;
    });
    setState(() {
      fetching = true;
      teamsList = List<TeamObject>();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select a team"),
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
            itemCount: teamsList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context, teamsList[index]);
                },
                child: Card(
                  elevation: 1,
                  margin: EdgeInsets.all(4),
                  child: ListTile(
                    leading:
                        getImageWidget(teamsList[index].wikipediaWordMarkUrl),
                    title: Text(teamsList[index].name),
                    subtitle: Text(teamsList[index].city +
                        " (" +
                        teamsList[index].division +
                        ")"),
                  ),
                ),
              );
            }),
      );
    }
  }

  Widget getImageWidget(String url) {
    if (url.endsWith("png")) {
      return Image.network(
        url,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
//      return Container();
      return SvgPicture.network(
        url,
        width: 50,
        height: 50,
        fit: BoxFit.cover,
        placeholderBuilder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(30.0),
            child: const CircularProgressIndicator()),
      );
    }
  }
}
