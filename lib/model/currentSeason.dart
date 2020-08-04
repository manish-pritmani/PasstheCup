class CurrentSeason {
  int season;
  String regularSeasonStartDate;
  String postSeasonStartDate;
  String seasonType;
  String apiSeason;

  CurrentSeason(
      {this.season,
        this.regularSeasonStartDate,
        this.postSeasonStartDate,
        this.seasonType,
        this.apiSeason});

  CurrentSeason.fromJson(Map<String, dynamic> json) {
    season = json['Season'];
    regularSeasonStartDate = json['RegularSeasonStartDate'];
    postSeasonStartDate = json['PostSeasonStartDate'];
    seasonType = json['SeasonType'];
    apiSeason = json['ApiSeason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Season'] = this.season;
    data['RegularSeasonStartDate'] = this.regularSeasonStartDate;
    data['PostSeasonStartDate'] = this.postSeasonStartDate;
    data['SeasonType'] = this.seasonType;
    data['ApiSeason'] = this.apiSeason;
    return data;
  }
}
