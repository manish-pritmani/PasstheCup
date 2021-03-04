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
  static const String keyString = "?key=742224edf7fe4e75a30c9c7d2bfc6e3c";
  static const String startURL =
      "https://us-central1-passthecup-1b762.cloudfunctions.net/app/listUsers/Start/";

  static const String checkStatus =
      "http://161.8.42.170:8181/PTCGame/GetGameStatusId?GameId=";

  static const simGame1 = {
    "GameID": 60260,
    "Season": 2020,
    "SeasonType": 1,
    "Status": "Final",
    "Day": "2020-09-27T00:00:00",
    "DateTime": "2020-09-27T15:10:00",
    "AwayTeam": "CHC",
    "HomeTeam": "CHW",
    "AwayTeamID": 9,
    "HomeTeamID": 16,
    "RescheduledGameID": null,
    "StadiumID": 25,
    "Channel": "CSCh,TBS",
    "Inning": 9,
    "InningHalf": "B",
    "AwayTeamRuns": 1,
    "HomeTeamRuns": 1,
    "AwayTeamHits": 1,
    "HomeTeamHits": 2,
    "AwayTeamErrors": 0,
    "HomeTeamErrors": 0,
    "WinningPitcherID": 10008525,
    "LosingPitcherID": 10006183,
    "SavingPitcherID": 10000005,
    "Attendance": null,
    "AwayTeamProbablePitcherID": 10000247,
    "HomeTeamProbablePitcherID": 10006183,
    "Outs": null,
    "Balls": null,
    "Strikes": null,
    "CurrentPitcherID": null,
    "CurrentHitterID": null,
    "AwayTeamStartingPitcherID": 10008525,
    "HomeTeamStartingPitcherID": 10006183,
    "CurrentPitchingTeamID": null,
    "CurrentHittingTeamID": null,
    "PointSpread": -0.6,
    "OverUnder": 1.3,
    "AwayTeamMoneyLine": 49,
    "HomeTeamMoneyLine": -57,
    "ForecastTempLow": 23,
    "ForecastTempHigh": 23,
    "ForecastDescription": "Scrambled",
    "ForecastWindChill": 23,
    "ForecastWindSpeed": 2,
    "ForecastWindDirection": 124,
    "RescheduledFromGameID": null,
    "RunnerOnFirst": null,
    "RunnerOnSecond": null,
    "RunnerOnThird": null,
    "AwayTeamStartingPitcher": "Scrambled",
    "HomeTeamStartingPitcher": "Scrambled",
    "CurrentPitcher": "Scrambled",
    "CurrentHitter": "Scrambled",
    "WinningPitcher": "Scrambled",
    "LosingPitcher": "Scrambled",
    "SavingPitcher": "Scrambled",
    "DueUpHitterID1": null,
    "DueUpHitterID2": null,
    "DueUpHitterID3": null,
    "GlobalGameID": 10060260,
    "GlobalAwayTeamID": 10000009,
    "GlobalHomeTeamID": 10000016,
    "PointSpreadAwayTeamMoneyLine": -59,
    "PointSpreadHomeTeamMoneyLine": 49,
    "LastPlay": "Scrambled",
    "IsClosed": true,
    "Updated": "2020-09-28T22:01:24",
    "GameEndDateTime": "2020-09-27T18:51:32",
    "HomeRotationNumber": 347,
    "AwayRotationNumber": 347,
    "NeutralVenue": false,
    "InningDescription": null,
    "OverPayout": null,
    "UnderPayout": null,
    "Innings": [
      {
        "InningID": 385840,
        "GameID": 60260,
        "InningNumber": 1,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385849,
        "GameID": 60260,
        "InningNumber": 2,
        "AwayTeamRuns": 1,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385877,
        "GameID": 60260,
        "InningNumber": 3,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385887,
        "GameID": 60260,
        "InningNumber": 4,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385897,
        "GameID": 60260,
        "InningNumber": 5,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385908,
        "GameID": 60260,
        "InningNumber": 6,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385924,
        "GameID": 60260,
        "InningNumber": 7,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385942,
        "GameID": 60260,
        "InningNumber": 8,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 1
      },
      {
        "InningID": 385959,
        "GameID": 60260,
        "InningNumber": 9,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      }
    ]
  };

  static const simGame2 = {
    "GameID": 60631,
    "Season": 2020,
    "SeasonType": 1,
    "Status": "Final",
    "Day": "2020-09-26T00:00:00",
    "DateTime": "2020-09-26T19:10:00",
    "AwayTeam": "CHC",
    "HomeTeam": "CHW",
    "AwayTeamID": 9,
    "HomeTeamID": 16,
    "RescheduledGameID": null,
    "StadiumID": 25,
    "Channel": "CSCh",
    "Inning": 9,
    "InningHalf": "T",
    "AwayTeamRuns": 5,
    "HomeTeamRuns": 9,
    "AwayTeamHits": 5,
    "HomeTeamHits": 10,
    "AwayTeamErrors": 2,
    "HomeTeamErrors": 1,
    "WinningPitcherID": 10009098,
    "LosingPitcherID": 10000193,
    "SavingPitcherID": null,
    "Attendance": null,
    "AwayTeamProbablePitcherID": 10000193,
    "HomeTeamProbablePitcherID": 10007025,
    "Outs": null,
    "Balls": null,
    "Strikes": null,
    "CurrentPitcherID": null,
    "CurrentHitterID": null,
    "AwayTeamStartingPitcherID": 10000193,
    "HomeTeamStartingPitcherID": 10007025,
    "CurrentPitchingTeamID": null,
    "CurrentHittingTeamID": null,
    "PointSpread": -1.5,
    "OverUnder": 9.1,
    "AwayTeamMoneyLine": 128,
    "HomeTeamMoneyLine": -151,
    "ForecastTempLow": 71,
    "ForecastTempHigh": 72,
    "ForecastDescription": "Scrambled",
    "ForecastWindChill": 72,
    "ForecastWindSpeed": 18,
    "ForecastWindDirection": 204,
    "RescheduledFromGameID": null,
    "RunnerOnFirst": null,
    "RunnerOnSecond": null,
    "RunnerOnThird": null,
    "AwayTeamStartingPitcher": "Scrambled",
    "HomeTeamStartingPitcher": "Scrambled",
    "CurrentPitcher": "Scrambled",
    "CurrentHitter": "Scrambled",
    "WinningPitcher": "Scrambled",
    "LosingPitcher": "Scrambled",
    "SavingPitcher": "Scrambled",
    "DueUpHitterID1": null,
    "DueUpHitterID2": null,
    "DueUpHitterID3": null,
    "GlobalGameID": 10060631,
    "GlobalAwayTeamID": 10000009,
    "GlobalHomeTeamID": 10000016,
    "PointSpreadAwayTeamMoneyLine": -148,
    "PointSpreadHomeTeamMoneyLine": 122,
    "LastPlay": "Scrambled",
    "IsClosed": true,
    "Updated": "2020-09-26T22:38:15",
    "GameEndDateTime": "2020-09-26T22:33:10",
    "HomeRotationNumber": 948,
    "AwayRotationNumber": 947,
    "NeutralVenue": false,
    "InningDescription": null,
    "OverPayout": null,
    "UnderPayout": null,
    "Innings": [
      {
        "InningID": 385713,
        "GameID": 60631,
        "InningNumber": 1,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385719,
        "GameID": 60631,
        "InningNumber": 2,
        "AwayTeamRuns": 1,
        "HomeTeamRuns": 2
      },
      {
        "InningID": 385734,
        "GameID": 60631,
        "InningNumber": 3,
        "AwayTeamRuns": 4,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385749,
        "GameID": 60631,
        "InningNumber": 4,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 5
      },
      {
        "InningID": 385771,
        "GameID": 60631,
        "InningNumber": 5,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385786,
        "GameID": 60631,
        "InningNumber": 6,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 2
      },
      {
        "InningID": 385804,
        "GameID": 60631,
        "InningNumber": 7,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385811,
        "GameID": 60631,
        "InningNumber": 8,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": 0
      },
      {
        "InningID": 385814,
        "GameID": 60631,
        "InningNumber": 9,
        "AwayTeamRuns": 0,
        "HomeTeamRuns": null
      }
    ]
  };

  Future<List<GameObject>> fetchGames() async {
    List<GameObject> list;
    DateTime EastCoast = DateTime.now().toUtc().add(Duration(hours: -4));
//    curDateTimeByZone(zone: "EST");
//     var date = DateFormat("yyyy-MMM-dd").format(EastCoast);// "2020-SEP-27";
    var date = "2020-SEP-27";
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
      GameObject simulationGameObject = GameObject.fromJson(simGame1);
      GameObject simulationGameObject2 = GameObject.fromJson(simGame2);

      list.insert(0, simulationGameObject);
      list.insert(1, simulationGameObject2);
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
    if(hitterID==null){
      hitterID = 10000001;
    }
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


  Future<bool> startSimulation(int gameID, String gameCode) async {
    var checkURL = checkStatus + gameID.toString();

    var stopURL =
        'http://161.8.42.170:8181/PTCGame/UpadteGameStatusInDB?GameId=$gameID&Status=-1';
    final response = await http.get(stopURL);
    print(response.body);

    var response2 = await http.get(checkURL);
    if (response2.body == "0") {
      return false;
    }

    var simURL =
        'http://161.8.42.170:8181/PTCGame/UpadteGameStatusInDB?GameId=$gameID&Status=1';
    final response1 = await http.get(simURL);
    print(response1.body);

   return true;
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
