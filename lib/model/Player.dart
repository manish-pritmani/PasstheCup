class Player {
  String name;
  String email;
  int gamescore;
  bool host;

  Player({this.name, this.email, this.gamescore, this.host});

  Player.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    gamescore = json['gamescore'];
    host = json['host'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['gamescore'] = this.gamescore;
    data['host'] = this.host;
    return data;
  }
}
