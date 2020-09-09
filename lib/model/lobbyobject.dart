import 'Player.dart';

class LobbyObject {
  List<Player> players;

  LobbyObject({
    this.players,
  });

  LobbyObject.fromJson(Map<String, dynamic> json) {
    if (json['players'] != null) {
      players = new List<Player>();
      json['players'].forEach((v) {
        players.add(new Player.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.players != null) {
      data['players'] = this.players.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
