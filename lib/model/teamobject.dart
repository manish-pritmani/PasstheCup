class TeamObject {
  int teamID;
  String key;
  bool active;
  String city;
  String name;
  int stadiumID;
  String league;
  String division;
  String primaryColor;
  String secondaryColor;
  String tertiaryColor;
  var quaternaryColor;
  String wikipediaLogoUrl;
  String wikipediaWordMarkUrl;
  int globalTeamID;

  TeamObject(
      {this.teamID,
        this.key,
        this.active,
        this.city,
        this.name,
        this.stadiumID,
        this.league,
        this.division,
        this.primaryColor,
        this.secondaryColor,
        this.tertiaryColor,
        this.quaternaryColor,
        this.wikipediaLogoUrl,
        this.wikipediaWordMarkUrl,
        this.globalTeamID});

  TeamObject.fromJson(Map<String, dynamic> json) {
    teamID = json['TeamID'];
    key = json['Key'];
    active = json['Active'];
    city = json['City'];
    name = json['Name'];
    stadiumID = json['StadiumID'];
    league = json['League'];
    division = json['Division'];
    primaryColor = json['PrimaryColor'];
    secondaryColor = json['SecondaryColor'];
    tertiaryColor = json['TertiaryColor'];
    quaternaryColor = json['QuaternaryColor'];
    wikipediaLogoUrl = json['WikipediaLogoUrl'];
    wikipediaWordMarkUrl = json['WikipediaWordMarkUrl'];
    globalTeamID = json['GlobalTeamID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['TeamID'] = this.teamID;
    data['Key'] = this.key;
    data['Active'] = this.active;
    data['City'] = this.city;
    data['Name'] = this.name;
    data['StadiumID'] = this.stadiumID;
    data['League'] = this.league;
    data['Division'] = this.division;
    data['PrimaryColor'] = this.primaryColor;
    data['SecondaryColor'] = this.secondaryColor;
    data['TertiaryColor'] = this.tertiaryColor;
    data['QuaternaryColor'] = this.quaternaryColor;
    data['WikipediaLogoUrl'] = this.wikipediaLogoUrl;
    data['WikipediaWordMarkUrl'] = this.wikipediaWordMarkUrl;
    data['GlobalTeamID'] = this.globalTeamID;
    return data;
  }
}
