class Player {
  String name;
  String email;
  int gamescore, gamescore2;
  bool host;

  Player({this.name, this.email, this.gamescore, this.gamescore2, this.host});

  Player.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    if (json["gamescore"] is double) {
      var d = json['gamescore'] as double;
      gamescore = d.toInt();
    } else {
      gamescore = json['gamescore'];
    }
    if (json['gamescore2']!=null) {
      if (json["gamescore2"] is double) {
        var d = json['gamescore2'] as double;
        gamescore2 = d.toInt();
      } else {
        gamescore2 = json['gamescore2'];
      }
    }else{
      gamescore2 = 0;
    }
    host = json['host'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['gamescore'] = this.gamescore;
    data['gamescore2'] = this.gamescore2;
    data['host'] = this.host;
    return data;
  }
}
