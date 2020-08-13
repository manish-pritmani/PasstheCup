import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:passthecup/model/gameObjectPlaybyPlay.dart';
import 'package:passthecup/model/teamobject.dart';
import 'model/fullplayerobject.dart';
import 'model/gameObject.dart';

class API {
  static const String BaseUrl = "https://api.sportsdata.io/v3/mlb/scores/json/";
  static const String keyString = "?key=be3c8c7f48c742a68a47e87a3bc3d1c3";

  Future<List<GameObject>> fetchGames() async {
    List<GameObject> list;
    var url = BaseUrl + "Games/2020REG" + keyString;
    final response = await http.get(url);

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
    var url = "https://api.sportsdata.io/v3/mlb/pbp/json/PlayByPlay/$gamid$keyString";
    final response =
        await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return GameObjectPlayByPlay.fromJson(json.decode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load game data');
    }
  }

  Future<String> fetchPlayerImage(int hitterID) async {
    var url = "https://api.sportsdata.io/v3/mlb/scores/json/Player/$hitterID$keyString";
    final response =
        await http.get(url);

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
}
