import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:passthecup/model/gameObjectPlaybyPlay.dart';
import 'package:passthecup/model/teamobject.dart';
import 'instant.dart';
import 'model/fullplayerobject.dart';
import 'model/gameObject.dart';

class API {
  static const String BaseUrl = "https://api.sportsdata.io/v3/mlb/scores/json/";
  static const String keyString = "?key=be3c8c7f48c742a68a47e87a3bc3d1c3";
  static const String startURL =
      "https://us-central1-passthecup-1b762.cloudfunctions.net/app/listUsers/Start/";

  Future<List<GameObject>> fetchGames() async {
    List<GameObject> list;
    DateTime EastCoast = DateTime.now().toUtc().add(Duration(hours: -4));
//    curDateTimeByZone(zone: "EST");
    var date = /*DateFormat("yyyy-MMM-dd").format(EastCoast);*/ "2020-SEP-27";
    var url =
        "https://api.sportsdata.io/v3/mlb/scores/json/GamesByDate/$date?key=5863b9d2fa7746cd8495fb3cc4b53743"; //BaseUrl + "Games/2020REG" + keyString;
    final response =
        await http.get(url).timeout(Duration(seconds: 300), onTimeout: () {
      throw Exception('TimedOut');
    }).catchError((onError) {
      print(onError);
    });

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data as List;
      print(rest);
      list = rest.map<GameObject>((json) => GameObject.fromJson(json)).toList();
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load games');
    }
  }

  Future<List<TeamObject>> fetchTeams() async {
    List<TeamObject> list;
    var url = BaseUrl + "teams" + keyString;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      var rest = data as List;
      print(rest);
      list = rest.map<TeamObject>((json) => TeamObject.fromJson(json)).toList();
      return list;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load teams');
    }
  }

  Future<GameObjectPlayByPlay> fetchGamePlayByPlay(String gamid) async {
    var url =
        "https://api.sportsdata.io/v3/mlb/pbp/json/PlayByPlay/$gamid$keyString";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      //print(response.body);
      return GameObjectPlayByPlay.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load game data');
    }
  }

  Future<String> fetchPlayerImage(int hitterID) async {
    var url =
        "https://api.sportsdata.io/v3/mlb/scores/json/Player/$hitterID$keyString";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      try {
        return FullPlayerObject.fromJson(json.decode(response.body)).photoUrl;
      } catch (e) {
        print(e);
        return "";
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return "";
    }
  }

  Future<FullPlayerObject> fetchPlayerProfile(int hitterID) async {
    var url =
        "https://api.sportsdata.io/v3/mlb/scores/json/Player/$hitterID$keyString";
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      try {
        return FullPlayerObject.fromJson(json.decode(response.body));
      } catch (e) {
        print(e);
        throw e;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception("");
    }
  }

  Future<bool> startGame(int gameID, String gameCode) async {
    var url = "$startURL/$gameID/$gameCode";
    final response = await http.get(url);

    // var simURL = 'http://61.0.171.102/PTCGame/UpadteGameStatusInDB?GameId=$gameID&Status=1';
    var simURL = 'http://161.8.42.170:8181/PTCGame/UpadteGameStatusInDB?GameId=$gameID&Status=1';
    final response1 = await http.get(simURL);
    print(response1.body);

    if (response.statusCode == 200) {
      try {
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return false;
    }
  }

  Future<List<TeamObject>> fetchTeamImage() async {
    var url = "https://api.sportsdata.io/v3/mlb/scores/json/teams$keyString";
    final response = await http.get(url);
    List<TeamObject> teams = List();
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      try {
        teams = (json.decode(response.body) as List)
            .map((i) => TeamObject.fromJson(i))
            .toList();
        return teams;
      } catch (e) {
        print(e);
        return List<TeamObject>();
      }
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      return List<TeamObject>();
    }
  }
}
