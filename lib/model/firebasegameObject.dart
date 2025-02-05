import 'package:passthecup/model/gameObject.dart';
import 'package:passthecup/model/teamobject.dart';

import 'Player.dart';

class FirebaseGameObject {
  bool attending;
  int joinPlayers;
  TeamObject selectedTeam;
  String creatorId;
  String name;
  String hostID;
  String gameCode;
  int gameID;
  GameObject selectedGame;
  Map latestPlay;
  String createdOn;
  int status;
  int cupScore;
  int cupScore2;
  bool simulation;
  List<Player> players;
  String lastResult;
  int lastResultPointsAwarded;
  int lastPlayID;
  String currentHitter;
  String currentPitcher;
  int currentHitterID;
  int currentPitcherID;
  int currentInningNumber;
  String currentInningHalf;
  int currentActivePlayer;
  String lastUpdatedAt;

  FirebaseGameObject(
      {this.joinPlayers,
      this.attending,
      this.selectedTeam,
      this.creatorId,
      this.name,
      this.players,
      this.hostID,
      this.gameCode,
      this.gameID,
      this.selectedGame,
      this.cupScore,
      this.cupScore2,
      this.createdOn,
      this.simulation,
      this.status,
      this.lastResult,
      this.lastPlayID,
      this.lastResultPointsAwarded,
      this.currentHitter,
      this.currentPitcher,
      this.currentHitterID,
      this.currentPitcherID,
      this.currentInningNumber,
      this.currentInningHalf,
      this.currentActivePlayer,
      this.lastUpdatedAt});

  FirebaseGameObject.fromJson(Map<String, dynamic> json) {
    attending = json['attending'];
    if (attending == null) {
      attending = false;
    }
    joinPlayers = json['joinPlayers'];
    creatorId = json['creatorId'];
    name = json['name'];
    hostID = json['hostID'];
    gameCode = json['gameCode'];
    if (json["gameID"] is String) {
      gameID = int.parse(json["gameID"]);
    } else {
      gameID = json["gameID"];
    }
    if (json['selectedGame'] != null) {
      var jsonSelectedGame = json['selectedGame'];
      selectedGame = new GameObject.fromJson(jsonSelectedGame);
    } else {
      selectedGame = null;
    }

    if (json['latestPlay'] != null) {
      var jsonSelectedGame = json['latestPlay'];
      latestPlay = jsonSelectedGame;
    } else {
      latestPlay = null;
    }

    if (json['selectedTeam'] != null) {
      Map<String, dynamic> jsonTeam = json['selectedTeam'];
      selectedTeam = new TeamObject.fromJson(jsonTeam);
    } else {
      selectedTeam = null;
    }
    createdOn = json['createdOn'];
    simulation = json['simulation'];
    status = json['status'];
    cupScore = json['cupScore'];
    if (json['cupScore2'] != null) {
      cupScore2 = json['cupScore2'];
    } else {
      cupScore2 = 0;
    }
    if (json['players'] != null) {
      players = new List<Player>();
      json['players'].forEach((v) {
        players.add(new Player.fromJson(v));
      });
    }
    lastResult = json['lastResult'];
    lastPlayID = json['lastPlayID'];
    lastResultPointsAwarded = json['lastResultPointsAwarded'];
    currentHitter = json['currentHitter'];
    currentPitcher = json['currentPitcher'];
    currentHitterID = json['currentHitterID'];
    currentPitcherID = json['currentPitcherID'];
    currentInningNumber = json['currentInningNumber'];
    currentInningHalf = json['currentInningHalf'];
    currentActivePlayer = json['currentActivePlayer'];
    lastUpdatedAt = json['lastUpdatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['joinPlayers'] = this.joinPlayers;
    data['attending'] = this.attending;
    if (this.selectedTeam != null) {
      data['selectedTeam'] = this.selectedTeam.toJson();
    }
    data['creatorId'] = this.creatorId;
    data['cupScore'] = this.cupScore;
    data['cupScore2'] = this.cupScore2;
    data['name'] = this.name;
    data['simulation'] = simulation;
    data['hostID'] = this.hostID;
    data['gameCode'] = this.gameCode;
    data['gameID'] = this.gameID;
    if (this.selectedGame != null) {
      data['selectedGame'] = this.selectedGame.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['status'] = this.status;
    if (this.players != null) {
      data['players'] = this.players.map((v) => v.toJson()).toList();
    }
    data['lastResult'] = this.lastResult;
    data['lastPlayID'] = this.lastPlayID;
    data['lastResultPointsAwarded'] = this.lastResultPointsAwarded;
    data['currentHitter'] = this.currentHitter;
    data['currentPitcher'] = this.currentPitcher;
    data['currentHitterID'] = this.currentHitterID;
    data['currentPitcherID'] = this.currentPitcherID;
    data['currentInningNumber'] = this.currentInningNumber;
    data['currentInningHalf'] = this.currentInningHalf;
    data['currentActivePlayer'] = this.currentActivePlayer;
    data['lastUpdatedAt'] = this.lastUpdatedAt;
    return data;
  }
}
