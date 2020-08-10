import 'package:passthecup/model/gameObject.dart';
import 'package:passthecup/model/teamobject.dart';

import 'Player.dart';

class FirebaseGameObject {
  int joinPlayers;
  TeamObject selectedTeam;
  String creatorId;
  String name;
  String hostID;
  String gameCode;
  GameObject selectedGame;
  String createdOn;
  int status;
  List<Player> players;

  FirebaseGameObject(
      {this.joinPlayers,
        this.selectedTeam,
        this.creatorId,
        this.name,
        this.players,
        this.hostID,
        this.gameCode,
        this.selectedGame,
        this.createdOn,
        this.status});

  FirebaseGameObject.fromJson(Map<String, dynamic> json) {
    joinPlayers = json['joinPlayers'];
    creatorId = json['creatorId'];
    name = json['name'];
    hostID = json['hostID'];
    gameCode = json['gameCode'];
    if (json['selectedGame'] != null) {
      selectedGame = new GameObject.fromJson(json['selectedGame']);
    } else {
      selectedGame = null;
    }
    if (json['selectedTeam'] != null) {
      Map<String, dynamic> jsonTeam = json['selectedTeam'];
      selectedTeam = new TeamObject.fromJson(jsonTeam);
    } else {
      selectedTeam = null;
    }
    createdOn = json['createdOn'];
    status = json['status'];
    if (json['players'] != null) {
      players = new List<Player>();
      json['players'].forEach((v) {
        players.add(new Player.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['joinPlayers'] = this.joinPlayers;
    if (this.selectedTeam != null) {
      data['selectedTeam'] = this.selectedTeam.toJson();
    }
    data['creatorId'] = this.creatorId;
    data['name'] = this.name;
    data['hostID'] = this.hostID;
    data['gameCode'] = this.gameCode;
    if (this.selectedGame != null) {
      data['selectedGame'] = this.selectedGame.toJson();
    }
    data['createdOn'] = this.createdOn;
    data['status'] = this.status;
    if (this.players != null) {
      data['players'] = this.players.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


